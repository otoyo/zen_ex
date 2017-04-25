defmodule Zendex.Core.ClientSpec do
  use ESpec

  alias Zendex.Core.Client

  let :endpoint, do: "/api/v2/users.json"
  let :url, do: Client.build_url endpoint()
  let :param, do: %{}
  let :body, do: Poison.encode!(param())
  let :headers, do: ["Content-Type": "application/json"]
  let :basic_auth, do: Client.basic_auth

  describe "get" do
    before do: allow HTTPotion |> to(accept :get, fn(_, _) -> nil end)

    it "calls HTTPotion.get" do
      Client.get endpoint()
      expect HTTPotion |> to(accepted :get, [url(), [basic_auth: basic_auth()]])
    end
  end

  describe "post" do
    before do: allow HTTPotion |> to(accept :post, fn(_, _) -> nil end)

    it "calls HTTPotion.post" do
      Client.post endpoint(), param()
      expect HTTPotion |> to(accepted :post, [url(), [body: body(), headers: headers(), basic_auth: basic_auth()]])
    end
  end

  describe "put" do
    before do: allow HTTPotion |> to(accept :put, fn(_, _) -> nil end)

    it "calls HTTPotion.put" do
      Client.put endpoint(), param()
      expect HTTPotion |> to(accepted :put, [url(), [body: body(), headers: headers(), basic_auth: basic_auth()]])
    end
  end

  describe "delete" do
    before do: allow HTTPotion |> to(accept :delete, fn(_, _) -> nil end)

    it "calls HTTPotion.delete" do
      Client.delete endpoint()
      expect HTTPotion |> to(accepted :delete, [url(), [basic_auth: basic_auth()]])
    end
  end

  describe "build_url" do
    subject do: Client.build_url endpoint()
    it do: is_expected() |> to(eq "https://testdomain.zendesk.com/api/v2/users.json")
  end

  describe "basic_auth" do
    subject do: Client.basic_auth
    it do: is_expected() |> to(eq {"testuser@testdomain.zendesk.com/token", "testapitoken"})
  end
end
