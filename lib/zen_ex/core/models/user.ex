defmodule ZenEx.Model.User do
  alias ZenEx.HTTPClient
  alias ZenEx.Query
  alias ZenEx.SearchQuery
  alias ZenEx.Entity.{User, JobStatus}

  @moduledoc """
  Provides functions to operate Zendesk User.
  """

  @doc """
  List users.

  ## Examples

      iex> ZenEx.Model.User.list
      %ZenEx.Collection{}

  """
  @spec list :: %ZenEx.Collection{} | {:error, String.t()}
  def list(opts \\ []) when is_list(opts) do
    "/api/v2/users.json#{Query.build(opts)}"
    |> HTTPClient.get(users: [User])
  end


  @doc """
  Show user specified by id.

  ## Examples

      iex> ZenEx.Model.User.show(1)
      %ZenEx.Entity.User{id: 1, name: "xxx", ...}

  """
  @spec show(integer) :: %User{} | {:error, String.t()}
  def show(id) when is_integer(id) do
    HTTPClient.get("/api/v2/users/#{id}.json", user: User)
  end


  @doc """
  Create user.

  ## Examples

      iex> ZenEx.Model.User.create(%ZenEx.Entity.User{name: "xxx", email: "xxx@xxx"})
      %ZenEx.Entity.User{name: "xxx", email: "xxx@xxx", ...}

  """
  @spec create(%User{}) :: %User{} | {:error, String.t()} | nil
  def create(%User{} = user) do
    HTTPClient.post("/api/v2/users.json", %{user: user}, user: User)
  end


  @doc """
  Update user specified by id.

  ## Examples

      iex> ZenEx.Model.User.update(%ZenEx.Entity.User{id: 1, name: "xxx"})
      %ZenEx.Entity.User{id: 1, name: "xxx", ...}

  """
  @spec update(%User{}) :: %User{} | {:error, String.t()}
  def update(%User{} = user) do
    HTTPClient.put("/api/v2/users/#{user.id}.json", %{user: user}, user: User)
  end


  @doc """
  Create or update user specified by id.

  ## Examples

      iex> ZenEx.Model.User.create_or_update(%ZenEx.Entity.User{name: "xxx", email: "xxx@xxx"})
      %ZenEx.Entity.User{id: xxx, name: "xxx", email: "xxx@xxx", ...}

  """
  @spec create_or_update(%User{}) :: %User{} | {:error, String.t()}
  def create_or_update(%User{} = user) do
    HTTPClient.post("/api/v2/users/create_or_update.json", %{user: user}, user: User)
  end


  @doc """
  Delete (deactivate) user specified by id.

  ## Examples

      iex> ZenEx.Model.User.destroy(1)
      %ZenEx.Entity.User{id: 1, name: "xxx", active: false, ...}

  """
  @spec destroy(integer) :: %User{} | {:error, String.t()}
  def destroy(id) when is_integer(id) do
    HTTPClient.delete("/api/v2/users/#{id}.json", user: User)
  end


  @doc """
  Create multiple users.

  ## Examples

      iex> ZenEx.Model.User.create_many([%ZenEx.Entity.User{name: "xxx"}, ...])
      %ZenEx.Entity.JobStatus{id: "xxx"}

  """
  @spec create_many(list(%User{})) :: %JobStatus{} | {:error, String.t()}
  def create_many(users) when is_list(users) do
    HTTPClient.post("/api/v2/users/create_many.json", %{users: users}, job_status: JobStatus)
  end


  @doc """
  Update multiple users specified by id.

  ## Examples

      iex> ZenEx.Model.User.update_many([%ZenEx.Entity.User{id: xxx, name: "xxx"}, ...])
      %ZenEx.Entity.JobStatus{id: "xxx"}

  """
  @spec update_many(list(%User{})) :: %JobStatus{} | {:error, String.t()}
  def update_many(users) when is_list(users) do
    HTTPClient.put("/api/v2/users/update_many.json", %{users: users}, job_status: JobStatus)
  end


  @doc """
  Create or update multiple users specified by id.

  ## Examples

      iex> ZenEx.Model.User.create_or_update_many([%ZenEx.Entity.User{id: xxx, name: "xxx"}, ...])
      %ZenEx.Entity.JobStatus{id: "xxx"}

  """
  @spec create_or_update_many(list(%User{})) :: %JobStatus{} | {:error, String.t()}
  def create_or_update_many(users) when is_list(users) do
    HTTPClient.post("/api/v2/users/create_or_update_many.json", %{users: users}, job_status: JobStatus)
  end


  @doc """
  Delete (deactivate) multiple users specified by id.

  ## Examples

      iex> ZenEx.Model.User.destroy_many([xxx, ...])
      %ZenEx.Entity.JobStatus{id: "xxx"}

  """
  @spec destroy_many(list(integer)) :: %JobStatus{} | {:error, String.t()}
  def destroy_many(ids) when is_list(ids) do
    HTTPClient.delete("/api/v2/users/destroy_many.json?ids=#{Enum.join(ids, ",")}", job_status: JobStatus)
  end

  @doc """
  Search for users specified by query.

  ## Examples

      iex> ZenEx.Model.User.search(%{email: "first.last@domain.com"})
      %ZenEx.Collection{}

      iex> ZenEx.Model.User.search("David"})
      %ZenEx.Collection{}

  """
  @spec search(map()) :: %ZenEx.Collection{} | {:error, String.t()}
  def search(opts) when is_map(opts) do
    search(SearchQuery.build(opts))
  end

  @spec search(String.t()) :: %ZenEx.Collection{} | {:error, String.t()}
  def search(query) do
    "/api/v2/users/search.json?query=#{query}"
    |> HTTPClient.get(users: [User])
  end
end
