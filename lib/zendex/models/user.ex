defmodule Zendex.Model.User do
  alias Zendex.Core.Client
  alias Zendex.Model
  alias Zendex.Entity.{User,JobStatus}

  @spec list :: list(%User{})
  def list do
    Client.get("/api/v2/users.json") |> __create_users__
  end

  @spec show(integer) :: %User{}
  def show(id) when is_integer(id) do
    Client.get("/api/v2/users/#{id}.json") |> __create_user__
  end

  @spec create(%User{}) :: %User{}
  def create(%User{} = user) do
    Client.post("/api/v2/users.json", %{user: user}) |> __create_user__
  end

  @spec update(%User{}) :: %User{}
  def update(%User{} = user) do
    Client.put("/api/v2/users/#{user.id}.json", %{user: user}) |> __create_user__
  end

  @spec create_or_update(%User{}) :: %User{}
  def create_or_update(%User{} = user) do
    Client.post("/api/v2/users/create_or_update.json", %{user: user}) |> __create_user__
  end

  @spec destroy(integer) :: %User{}
  def destroy(id) when is_integer(id) do
    Client.delete("/api/v2/users/#{id}.json") |> __create_user__
  end

  @spec create_many(list(%User{})) :: %JobStatus{}
  def create_many(users) when is_list(users) do
    Client.post("/api/v2/users/create_many.json", %{users: users}) |> Model.JobStatus.__create_job_status__
  end

  @spec update_many(list(%User{})) :: %JobStatus{}
  def update_many(users) when is_list(users) do
    Client.put("/api/v2/users/update_many.json", %{users: users}) |> Model.JobStatus.__create_job_status__
  end

  @spec create_or_update_many(list(%User{})) :: %JobStatus{}
  def create_or_update_many(users) when is_list(users) do
    Client.post("/api/v2/users/create_or_update_many.json", %{users: users}) |> Model.JobStatus.__create_job_status__
  end

  @spec destroy_many(list(integer)) :: %JobStatus{}
  def destroy_many(ids) when is_list(ids) do
    Client.delete("/api/v2/users/destroy_many.json?ids=#{Enum.join(ids, ",")}") |> Model.JobStatus.__create_job_status__
  end

  @spec __create_users__(%HTTPotion.Response{}) :: list(%User{})
  def __create_users__(%HTTPotion.Response{} = res) do
    res.body |> Poison.decode!(keys: :atoms, as: %{users: [%User{}]}) |> Map.get(:users)
  end

  @spec __create_user__(%HTTPotion.Response{}) :: %User{}
  def __create_user__(%HTTPotion.Response{} = res) do
    res.body |> Poison.decode!(keys: :atoms, as: %{user: %User{}}) |> Map.get(:user)
  end
end
