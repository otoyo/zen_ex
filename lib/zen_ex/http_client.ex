defmodule ZenEx.HTTPClient do

  @moduledoc false

  @content_type "application/json"

  alias ZenEx.Collection

  def get("https://" <> _ = url) do
    url |> HTTPotion.get([basic_auth: basic_auth()])
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
    build_url(endpoint)
    |> HTTPotion.post([body: Poison.encode!(param), headers: ["Content-Type": @content_type], basic_auth: basic_auth()])
    |> _build_entity(decode_as)
  end

  def put(endpoint, %{} = param, decode_as) do
    build_url(endpoint)
    |> HTTPotion.put([body: Poison.encode!(param), headers: ["Content-Type": @content_type], basic_auth: basic_auth()])
    |> _build_entity(decode_as)
  end

  def delete(endpoint, decode_as), do: delete(endpoint) |> _build_entity(decode_as)
  def delete(endpoint) do
    build_url(endpoint) |> HTTPotion.delete([basic_auth: basic_auth()])
  end

  def build_url(endpoint) do
    "https://#{get_env(:subdomain)}.zendesk.com#{endpoint}"
  end

  def basic_auth do
    {"#{get_env(:user)}/token", "#{get_env(:api_token)}"}
  end

  def _build_entity(%HTTPotion.Response{} = res, [{key, [module]}]) do
    {entities, page} =
      res.body
      |> Poison.decode!(keys: :atoms, as: %{key => [struct(module)]})
      |> Map.pop(key)

    struct(Collection, Map.merge(page, %{entities: entities, decode_as: [{key, [module]}]}))
  end
  def _build_entity(%HTTPotion.Response{} = res, [{key, module}]) do
    res.body |> Poison.decode!(keys: :atoms, as: %{key => struct(module)}) |> Map.get(key)
  end
  def _build_entity(%HTTPotion.ErrorResponse{message: error}, _) do
    {:error, error}
  end

  defp get_env(key) do
    config_module = Process.get(:zendesk_config_module)
    if config_module, do: Application.get_env(:zen_ex, config_module) |> Keyword.get(key), else: Application.get_env(:zen_ex, key)
  end
end
