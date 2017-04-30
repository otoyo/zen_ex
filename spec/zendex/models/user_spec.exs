defmodule Zendex.Model.UserSpec do
  use ESpec

  alias Zendex.Core.Client
  alias Zendex.Entity.User
  alias Zendex.Model

  let :json_users do
    ~s({"users":[{"id":223443,"name":"Johnny Agent"},{"id":8678530,"name":"James A. Rosen"}]})
  end
  let :users do
    [struct(User, %{id: 223443, name: "Johnny Agent"}), struct(User, %{id: 8678530, name: "James A. Rosen"})]
  end

  let :json_user, do: ~s({"user":{"id":223443,"name":"Johnny Agent"}})
  let :user, do: struct(User, %{id: 223443, name: "Johnny Agent"})

  let :response_user, do: %HTTPotion.Response{body: json_user()}
  let :response_users, do: %HTTPotion.Response{body: json_users()}

  describe "list" do
    before do: allow Client |> to(accept :get, fn(_) -> response_users() end)
    it do: expect Model.User.list |> to(eq users())
  end

  describe "show" do
    before do: allow Client |> to(accept :get, fn(_) -> response_user() end)
    it do: expect Model.User.show(user().id) |> to(eq user())
  end

  describe "create" do
    before do: allow Client |> to(accept :post, fn(_, _) -> response_user() end)
    it do: expect Model.User.create(user()) |> to(be_struct User)
  end

  describe "update" do
    before do: allow Client |> to(accept :put, fn(_, _) -> response_user() end)
    it do: expect Model.User.update(user()) |> to(be_struct User)
  end

  describe "create_or_update" do
    before do: allow Client |> to(accept :post, fn(_, _) -> response_user() end)
    it do: expect Model.User.create_or_update(user()) |> to(be_struct User)
  end

  describe "destroy" do
    before do: allow Client |> to(accept :delete, fn(_) -> response_user() end)
    it do: expect Model.User.destroy(user().id) |> to(be_struct User)
  end

  describe "create_many" do
    before do: allow Client |> to(accept :post, fn(_, _) -> nil end)

    it "calls Client.post" do
      Model.User.create_many(users())
      expect Client |> to(accepted :post)
    end
  end

  describe "update_many" do
    before do: allow Client |> to(accept :put, fn(_, _) -> nil end)

    it "calls Client.put" do
      Model.User.update_many(users())
      expect Client |> to(accepted :put)
    end
  end

  describe "create_or_update_many" do
    before do: allow Client |> to(accept :post, fn(_, _) -> nil end)

    it "calls Client.post" do
      Model.User.create_or_update_many(users())
      expect Client |> to(accepted :post)
    end
  end

  describe "destroy_many" do
    before do: allow Client |> to(accept :delete)

    it "calls Client.delete" do
      Model.User.destroy_many(Enum.map(users(), &(&1.id)))
      expect Client |> to(accepted :delete)
    end
  end

  describe "response_to_users" do
    subject do: Model.User.response_to_users response_users()
    it do: is_expected() |> to(eq users())
  end

  describe "response_to_user" do
    subject do: Model.User.response_to_user response_user()
    it do: is_expected() |> to(eq user())
  end
end
