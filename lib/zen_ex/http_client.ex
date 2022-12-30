defmodule ZenEx.HTTPClient do
  @moduledoc false

  alias Tesla.Env
  alias ZenEx.Collection

  @spec auth_conn(list()) :: list()
  def auth_conn(middlewares \\ []) do
    Tesla.client(
      [
        {Tesla.Middleware.EncodeJson, [engine: Jason]},
        {Tesla.Middleware.BasicAuth,
         %{username: "#{get_env(:user)}/token", password: "#{get_env(:api_token)}"}}
      ] ++ middlewares
    )
  end

  @spec get(String.t()) :: {:ok, %Env{}} | {:error, any()}
  def get("https://" <> _ = url) do
    Tesla.get(auth_conn([Tesla.Middleware.Compression]), url)
  end

  @spec get(String.t()) :: {:ok, %Env{}} | {:error, any()}
  def get(endpoint) do
    endpoint |> build_url |> get
  end

  @spec get(String.t(), %{}) :: {:ok, %{}} | {:error, any()}
  def get("https://" <> _ = url, decode_as) do
    url
    |> get
    |> case do
      {:ok, response} -> _build_entity(response, decode_as)
      {:error, response} -> {:error, response}
    end
  end

  @spec get(String.t(), %{}) :: {:ok, %{}} | {:error, any()}
  def get(endpoint, decode_as) do
    endpoint |> build_url |> get(decode_as)
  end

  @spec post(String.t(), map(), %{}) :: {:ok, %{}} | {:error, any()}
  def post(endpoint, %{} = param, decode_as) do
    Tesla.post(auth_conn(), build_url(endpoint), param)
    |> case do
      {:ok, response} -> _build_entity(response, decode_as)
      {:error, response} -> {:error, response}
    end
  end

  @spec put(String.t(), map(), %{}) :: {:ok, %{}} | {:error, any()}
  def put(endpoint, %{} = param, decode_as) do
    Tesla.put(auth_conn(), build_url(endpoint), param)
    |> case do
      {:ok, response} -> _build_entity(response, decode_as)
      {:error, response} -> {:error, response}
    end
  end

  @spec put(String.t(), map()) :: {:ok, %Env{}} | {:error, any()}
  def put(endpoint, %{} = param) do
    Tesla.put(auth_conn(), build_url(endpoint), param)
  end

  @spec delete(String.t(), %{}) :: {:ok, %Env{}} | {:error, any()}
  def delete(endpoint, decode_as) do
    endpoint
    |> delete
    |> case do
      {:ok, response} -> _build_entity(response, decode_as)
      {:error, response} -> {:error, response}
    end
  end

  @spec delete(String.t()) :: {:ok, %Env{}} | {:error, any()}
  def delete(endpoint) do
    Tesla.delete(auth_conn(), build_url(endpoint))
  end

  @spec build_url(String.t()) :: String.t()
  def build_url(endpoint) do
    "https://#{get_env(:subdomain)}.zendesk.com#{endpoint}"
  end

  @spec _build_entity(%Env{}, key: [%{}]) :: {:ok, %Collection{}} | {:error, any()}
  def _build_entity(%Env{status: status, body: body}, [{key, [module]}])
      when status in 200..299 do
    with {:ok, parser} <-
           body |> Poison.decode(keys: :atoms, as: %{key => [struct(module)]}),
         {entities, page} <-
           Map.pop(parser, key) do
      {:ok,
       struct(Collection, Map.merge(page, %{entities: entities, decode_as: [{key, [module]}]}))}
    else
      {:error, err} -> {:error, err}
    end
  end

  @spec _build_entity(%Env{}, key: %{}) :: {:ok, %{}} | {:error, any()}
  def _build_entity(%Env{status: status, body: body}, [{key, module}]) when status in 200..299 do
    body
    |> Poison.decode(keys: :atoms, as: %{key => struct(module)})
    |> case do
      {:ok, parser} -> Map.fetch(parser, key)
      {:error, err} -> {:error, err}
    end
  end

  @spec _build_entity(%Env{}, any()) :: {:error, %Env{}}
  def _build_entity(%Env{} = response, _), do: {:error, response}

  defp get_env(key) do
    case Process.get(:zendesk_config_module) do
      nil -> Application.get_env(:zen_ex, key)
      config_module -> Application.get_env(:zen_ex, config_module)[key]
    end
  end
end
