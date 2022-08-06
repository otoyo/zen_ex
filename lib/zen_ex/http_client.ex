defmodule ZenEx.HTTPClient do
  @moduledoc false

  alias Tesla.Env
  alias ZenEx.Collection

  def auth_conn(middlewares \\ []) do
    Tesla.client(
      [
        {Tesla.Middleware.EncodeJson, [engine: Jason]},
        {Tesla.Middleware.BasicAuth,
         %{username: "#{get_env(:user)}/token", password: "#{get_env(:api_token)}"}}
      ] ++ middlewares
    )
  end

  def get("https://" <> _ = url) do
    with {:ok, response} <- Tesla.get(auth_conn([Tesla.Middleware.Compression]), url) do
      response
    end
  end

  def get(endpoint) do
    endpoint |> build_url |> get
  end

  def get("https://" <> _ = url, decode_as) do
    url |> get |> _build_entity(decode_as)
  end

  def get(endpoint, decode_as) do
    endpoint |> build_url |> get(decode_as)
  end

  def post(endpoint, %{} = param, decode_as) do
    with {:ok, response} <-
           Tesla.post(auth_conn(), build_url(endpoint), param) do
      response |> _build_entity(decode_as)
    end
  end

  def put(endpoint, %{} = param, decode_as) do
    with {:ok, response} <-
           Tesla.put(auth_conn(), build_url(endpoint), param) do
      response |> _build_entity(decode_as)
    end
  end

  def put(endpoint, %{} = param) do
    with {:ok, response} <- Tesla.put(auth_conn(), build_url(endpoint), param) do
      response
    end
  end

  def delete(endpoint, decode_as), do: delete(endpoint) |> _build_entity(decode_as)

  def delete(endpoint) do
    with {:ok, response} <- Tesla.delete(auth_conn(), build_url(endpoint)) do
      response
    end
  end

  def build_url(endpoint) do
    "https://#{get_env(:subdomain)}.zendesk.com#{endpoint}"
  end

  def _build_entity(%Env{} = response, [{key, [module]}]) do
    {entities, page} =
      response.body
      |> Poison.decode!(keys: :atoms, as: %{key => [struct(module)]})
      |> Map.pop(key)

    struct(Collection, Map.merge(page, %{entities: entities, decode_as: [{key, [module]}]}))
  end

  def _build_entity(%Env{} = response, [{key, module}]) do
    response.body |> Poison.decode!(keys: :atoms, as: %{key => struct(module)}) |> Map.get(key)
  end

  def _build_entity({:error, error}, _) do
    {:error, error}
  end

  defp get_env(key) do
    case Process.get(:zendesk_config_module) do
      nil -> Application.get_env(:zen_ex, key)
      config_module -> Application.get_env(:zen_ex, config_module)[key]
    end
  end
end
