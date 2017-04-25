defmodule Zendex.Model.User do
  alias Zendex.Core.Client
  alias Zendex.Entity.User

  @spec list :: list(%User{})
  def list do
    Client.get("/api/v2/users.json") |> response_to_users
  end

  @spec show(integer) :: %User{}
  def show(id) when is_integer(id) do
    Client.get("/api/v2/users/#{id}.json") |> response_to_user
  end

  @spec create(%User{}) :: %User{}
  def create(%User{} = user) do
    Client.post("/api/v2/users.json", %{user: user}) |> response_to_user
  end

  @spec update(%User{}) :: %User{}
  def update(%User{} = user) do
    Client.put("/api/v2/users/#{user.id}.json", %{user: user}) |> response_to_user
  end

  @spec create_or_update(%User{}) :: %User{}
  def create_or_update(%User{} = user) do
    Client.post("/api/v2/users/create_or_update.json", %{user: user}) |> response_to_user
  end

  @spec destroy(integer) :: %User{}
  def destroy(id) when is_integer(id) do
    Client.delete("/api/v2/users/#{id}.json") |> response_to_user
  end

  @spec create_many(list(%User{})) :: %HTTPotion.Response{}
  def create_many(users) when is_list(users) do
    Client.post "/api/v2/users/create_many.json", %{users: users}
  end

  @spec update_many(list(%User{})) :: %HTTPotion.Response{}
  def update_many(users) when is_list(users) do
    Client.put "/api/v2/users/update_many.json", %{users: users}
  end

  @spec create_or_update_many(list(%User{})) :: %HTTPotion.Response{}
  def create_or_update_many(users) when is_list(users) do
    Client.post "/api/v2/users/create_or_update_many.json", %{users: users}
  end

  @spec destroy_many(list(integer)) :: %HTTPotion.Response{}
  def destroy_many(ids) when is_list(ids) do
    Client.delete "/api/v2/users/destroy_many.json?ids=#{Enum.join(ids, ",")}"
  end

  @spec response_to_users(%HTTPotion.Response{}) :: list(%User{})
  def response_to_users(%HTTPotion.Response{} = res) do
    res.body |> Poison.decode!(keys: :atoms, as: %{users: [%User{}]}) |> Map.get(:users)
  end

  @spec response_to_user(%HTTPotion.Response{}) :: %User{}
  def response_to_user(%HTTPotion.Response{} = res) do
    res.body |> Poison.decode!(keys: :atoms, as: %{user: %User{}}) |> Map.get(:user)
  end
end
