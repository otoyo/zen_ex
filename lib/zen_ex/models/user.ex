defmodule ZenEx.Model.User do
  alias ZenEx.Core.Client
  alias ZenEx.Model
  alias ZenEx.Entity.{User,JobStatus}

  @moduledoc """
  Provides functions to operate Zendesk User.
  """

  @doc """
  List users.

  ## Examples

      iex> ZenEx.Model.User.list
      [%ZenEx.Entity.User{id: xxx, name: "xxx", ...}, ...]

  """
  @spec list :: list(%User{})
  def list do
    Client.get("/api/v2/users.json") |> __create_users__
  end


  @doc """
  Show user specified by id.

  ## Examples

      iex> ZenEx.Model.User.show(1)
      %ZenEx.Entity.User{id: 1, name: "xxx", ...}

  """
  @spec show(integer) :: %User{}
  def show(id) when is_integer(id) do
    Client.get("/api/v2/users/#{id}.json") |> __create_user__
  end


  @doc """
  Create user.

  ## Examples

      iex> ZenEx.Model.User.create(%ZenEx.Entity.User{name: "xxx", email: "xxx@xxx"})
      %ZenEx.Entity.User{name: "xxx", email: "xxx@xxx", ...}

  """
  @spec create(%User{}) :: %User{}
  def create(%User{} = user) do
    Client.post("/api/v2/users.json", %{user: user}) |> __create_user__
  end


  @doc """
  Update user specified by id.

  ## Examples

      iex> ZenEx.Model.User.update(%ZenEx.Entity.User{id: 1, name: "xxx"})
      %ZenEx.Entity.User{id: 1, name: "xxx", ...}

  """
  @spec update(%User{}) :: %User{}
  def update(%User{} = user) do
    Client.put("/api/v2/users/#{user.id}.json", %{user: user}) |> __create_user__
  end


  @doc """
  Create or update user specified by id.

  ## Examples

      iex> ZenEx.Model.User.create_or_update(%ZenEx.Entity.User{name: "xxx", email: "xxx@xxx"})
      %ZenEx.Entity.User{id: xxx, name: "xxx", email: "xxx@xxx", ...}

  """
  @spec create_or_update(%User{}) :: %User{}
  def create_or_update(%User{} = user) do
    Client.post("/api/v2/users/create_or_update.json", %{user: user}) |> __create_user__
  end


  @doc """
  Delete (deactivate) user specified by id.

  ## Examples

      iex> ZenEx.Model.User.destroy(1)
      %ZenEx.Entity.User{id: 1, name: "xxx", active: false, ...}

  """
  @spec destroy(integer) :: %User{}
  def destroy(id) when is_integer(id) do
    Client.delete("/api/v2/users/#{id}.json") |> __create_user__
  end


  @doc """
  Create multiple users.

  ## Examples

      iex> ZenEx.Model.User.create_many([%ZenEx.Entity.User{name: "xxx"}, ...])
      %ZenEx.Entity.JobStatus{id: "xxx"}

  """
  @spec create_many(list(%User{})) :: %JobStatus{}
  def create_many(users) when is_list(users) do
    Client.post("/api/v2/users/create_many.json", %{users: users}) |> Model.JobStatus.__create_job_status__
  end


  @doc """
  Update multiple users specified by id.

  ## Examples

      iex> ZenEx.Model.User.update_many([%ZenEx.Entity.User{id: xxx, name: "xxx"}, ...])
      %ZenEx.Entity.JobStatus{id: "xxx"}

  """
  @spec update_many(list(%User{})) :: %JobStatus{}
  def update_many(users) when is_list(users) do
    Client.put("/api/v2/users/update_many.json", %{users: users}) |> Model.JobStatus.__create_job_status__
  end


  @doc """
  Create or update multiple users specified by id.

  ## Examples

      iex> ZenEx.Model.User.create_or_update_many([%ZenEx.Entity.User{id: xxx, name: "xxx"}, ...])
      %ZenEx.Entity.JobStatus{id: "xxx"}

  """
  @spec create_or_update_many(list(%User{})) :: %JobStatus{}
  def create_or_update_many(users) when is_list(users) do
    Client.post("/api/v2/users/create_or_update_many.json", %{users: users}) |> Model.JobStatus.__create_job_status__
  end


  @doc """
  Delete (deactivate) multiple users specified by id.

  ## Examples

      iex> ZenEx.Model.User.destroy_many([xxx, ...])
      %ZenEx.Entity.JobStatus{id: "xxx"}

  """
  @spec destroy_many(list(integer)) :: %JobStatus{}
  def destroy_many(ids) when is_list(ids) do
    Client.delete("/api/v2/users/destroy_many.json?ids=#{Enum.join(ids, ",")}") |> Model.JobStatus.__create_job_status__
  end


  @doc false
  @spec __create_users__(%HTTPotion.Response{}) :: list(%User{})
  def __create_users__(%HTTPotion.Response{} = res) do
    res.body |> Poison.decode!(keys: :atoms, as: %{users: [%User{}]}) |> Map.get(:users)
  end


  @doc false
  @spec __create_user__(%HTTPotion.Response{}) :: %User{}
  def __create_user__(%HTTPotion.Response{} = res) do
    res.body |> Poison.decode!(keys: :atoms, as: %{user: %User{}}) |> Map.get(:user)
  end
end
