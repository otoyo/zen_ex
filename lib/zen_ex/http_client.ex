defmodule ZenEx.HTTPClient do

  @moduledoc false

  @content_type "application/json"

  def get(endpoint) do
    build_url(endpoint)
    |> HTTPotion.get([basic_auth: basic_auth()])
  end

  def post(endpoint, %{} = param) do
    build_url(endpoint)
    |> HTTPotion.post([body: Poison.encode!(param), headers: ["Content-Type": @content_type], basic_auth: basic_auth()])
  end

  def put(endpoint, %{} = param) do
    build_url(endpoint)
    |> HTTPotion.put([body: Poison.encode!(param), headers: ["Content-Type": @content_type], basic_auth: basic_auth()])
  end

  def delete(endpoint) do
    build_url(endpoint)
    |> HTTPotion.delete([basic_auth: basic_auth()])
  end

  def build_url(endpoint) do
    "https://#{Application.get_env(:zen_ex, :subdomain)}.zendesk.com#{endpoint}"
  end

  def basic_auth do
    {"#{Application.get_env(:zen_ex, :user)}/token", "#{Application.get_env(:zen_ex, :api_token)}"}
  end
end
