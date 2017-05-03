defmodule Zendex.Model.User do
  alias Zendex.Core.Client
  alias Zendex.Model
  alias Zendex.Entity.{User,JobStatus}

  @moduledoc """
  Provides functions to operate Zendesk User.
  """

  @doc """
  List users.

  ## Examples

    iex> Zendex.Model.User.list
    [%Zendex.Entity.User{id: xxx, name: "xxx", ...}, ...]

  """
  @spec list :: list(%User{})
  def list do
    Client.get("/api/v2/users.json") |> __create_users__
  end


  @doc """
  Show user specified by id.

  ## Examples

    iex> Zendex.Model.User.show(1)
    %Zendex.Entity.User{id: 1, name: "xxx", ...}

  """
  @spec show(integer) :: %User{}
  def show(id) when is_integer(id) do
    Client.get("/api/v2/users/#{id}.json") |> __create_user__
  end


  @doc """
  Create user.

  ## Examples

    iex> Zendex.Model.User.create(%Zendex.Entity.User{name: "xxx", email: "xxx@xxx"})
    %Zendex.Entity.User{name: "xxx", email: "xxx@xxx", ...}

  """
  @spec create(%User{}) :: %User{}
  def create(%User{} = user) do
    Client.post("/api/v2/users.json", %{user: user}) |> __create_user__
  end


  @doc """
  Update user specified by id.

  ## Examples

    iex> Zendex.Model.User.update(%Zendex.Entity.User{id: 1, name: "xxx"})
    %Zendex.Entity.User{id: 1, name: "xxx", ...}

  """
  @spec update(%User{}) :: %User{}
  def update(%User{} = user) do
    Client.put("/api/v2/users/#{user.id}.json", %{user: user}) |> __create_user__
  end


  @doc """
  Create or update user specified by id.

  ## Examples

    iex> Zendex.Model.User.create_or_update(%Zendex.Entity.User{name: "xxx", email: "xxx@xxx"})
    %Zendex.Entity.User{id: xxx, name: "xxx", email: "xxx@xxx", ...}

  """
  @spec create_or_update(%User{}) :: %User{}
  def create_or_update(%User{} = user) do
    Client.post("/api/v2/users/create_or_update.json", %{user: user}) |> __create_user__
  end


  @doc """
  Delete (deactivate) user specified by id.

  ## Examples

    iex> Zendex.Model.User.destroy(1)
    %Zendex.Entity.User{id: 1, name: "xxx", active: false, ...}

  """
  @spec destroy(integer) :: %User{}
  def destroy(id) when is_integer(id) do
    Client.delete("/api/v2/users/#{id}.json") |> __create_user__
  end


  @doc """
  Create multiple users.

  ## Examples

    iex> Zendex.Model.User.create_many([%Zendex.Entity.User{name: "xxx"}, ...])
    %Zendex.Entity.JobStatus{id: "xxx"}

  """
  @spec create_many(list(%User{})) :: %JobStatus{}
  def create_many(users) when is_list(users) do
    Client.post("/api/v2/users/create_many.json", %{users: users}) |> Model.JobStatus.__create_job_status__
  end


  @doc """
  Update multiple users specified by id.

  ## Examples

    iex> Zendex.Model.User.update_many([%Zendex.Entity.User{id: xxx, name: "xxx"}, ...])
    %Zendex.Entity.JobStatus{id: "xxx"}

  """
  @spec update_many(list(%User{})) :: %JobStatus{}
  def update_many(users) when is_list(users) do
    Client.put("/api/v2/users/update_many.json", %{users: users}) |> Model.JobStatus.__create_job_status__
  end


  @doc """
  Create or update multiple users specified by id.

  ## Examples

    iex> Zendex.Model.User.create_or_update_many([%Zendex.Entity.User{id: xxx, name: "xxx"}, ...])
    %Zendex.Entity.JobStatus{id: "xxx"}

  """
  @spec create_or_update_many(list(%User{})) :: %JobStatus{}
  def create_or_update_many(users) when is_list(users) do
    Client.post("/api/v2/users/create_or_update_many.json", %{users: users}) |> Model.JobStatus.__create_job_status__
  end


  @doc """
  Delete (deactivate) multiple users specified by id.

  ## Examples

    iex> Zendex.Model.User.destroy_many([xxx, ...])
    %Zendex.Entity.JobStatus{id: "xxx"}

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
