defmodule ZenEx.HTTPClientSpec do
  use ESpec

  alias ZenEx.{HTTPClient, Collection}
  alias ZenEx.Entity.User

  let :endpoint, do: "/api/v2/users/223443.json"
  let :url, do: HTTPClient.build_url endpoint()
  let :param, do: %{}
  let :body, do: Poison.encode!(param())
  let :headers, do: ["Content-Type": "application/json"]
  let :basic_auth, do: HTTPClient.basic_auth
  let :json_user, do: ~s({"user":{"id":223443,"name":"Johnny Agent"}})
  let :response, do: %HTTPotion.Response{body: json_user()}
  let :decode_as, do: [user: User]

  describe "get" do
    before do: allow HTTPotion |> to(accept :get, fn(_, _) -> response() end)

    it "calls HTTPotion.get" do
      HTTPClient.get endpoint(), decode_as()
      expect HTTPotion |> to(accepted :get, [url(), [basic_auth: basic_auth()]])
    end
  end

  describe "post" do
    before do: allow HTTPotion |> to(accept :post, fn(_, _) -> response() end)

    it "calls HTTPotion.post" do
      HTTPClient.post endpoint(), param(), decode_as()
      expect HTTPotion |> to(accepted :post, [url(), [body: body(), headers: headers(), basic_auth: basic_auth()]])
    end
  end

  describe "put" do
    before do: allow HTTPotion |> to(accept :put, fn(_, _) -> response() end)

    it "calls HTTPotion.put" do
      HTTPClient.put endpoint(), param(), decode_as()
      expect HTTPotion |> to(accepted :put, [url(), [body: body(), headers: headers(), basic_auth: basic_auth()]])
    end
  end

  describe "delete" do
    before do: allow HTTPotion |> to(accept :delete, fn(_, _) -> response() end)

    it "calls HTTPotion.delete" do
      HTTPClient.delete endpoint()
      expect HTTPotion |> to(accepted :delete, [url(), [basic_auth: basic_auth()]])
    end
  end

  describe "build_url" do
    subject do: HTTPClient.build_url endpoint()
    it do: is_expected() |> to(eq "https://testdomain.zendesk.com/api/v2/users/223443.json")
  end

  describe "basic_auth" do
    subject do: HTTPClient.basic_auth
    it do: is_expected() |> to(eq {"testuser@testdomain.zendesk.com/token", "testapitoken"})
  end

  describe "_build_entity" do
    describe "with a module" do
      it "returns %User{}" do
        user = HTTPClient._build_entity response(), decode_as()
        expect user |> to(be_struct User)
      end
    end

    describe "with multiple modules" do
      let :json_users do
        ~s({"count":2,"users":[{"id":223443,"name":"Johnny Agent"},{"id":8678530,"name":"James A. Rosen"}]})
      end
      let :response, do: %HTTPotion.Response{body: json_users()}
      let :decode_as, do: [users: [User]]

      it "returns %Collection{}" do
        collection = HTTPClient._build_entity response(), decode_as()
        expect collection |> to(be_struct Collection)
      end
    end
  end
end
