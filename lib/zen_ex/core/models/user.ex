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
      {:ok, %ZenEx.Collection{}}

  """
  @spec list :: {:ok, %ZenEx.Collection{}} | {:error, any()}
  def list(opts \\ []) when is_list(opts) do
    "/api/v2/users.json#{Query.build(opts)}"
    |> HTTPClient.get(users: [User])
  end

  @doc """
  Show user specified by id.

  ## Examples

      iex> ZenEx.Model.User.show(1)
      {:ok, %ZenEx.Entity.User{id: 1, name: "xxx", ...}}

  """
  @spec show(integer) :: {:ok, %User{}} | {:error, any()}
  def show(id) when is_integer(id) do
    HTTPClient.get("/api/v2/users/#{id}.json", user: User)
  end

  @doc """
  Create user.

  ## Examples

      iex> ZenEx.Model.User.create(%ZenEx.Entity.User{name: "xxx", email: "xxx@xxx"})
      {:ok, %ZenEx.Entity.User{name: "xxx", email: "xxx@xxx", ...}}

  """
  @spec create(%User{}) :: {:ok, %User{}} | {:error, any()}
  def create(%User{} = user) do
    HTTPClient.post("/api/v2/users.json", %{user: user}, user: User)
  end

  @doc """
  Update user specified by id.

  ## Examples

      iex> ZenEx.Model.User.update(%ZenEx.Entity.User{id: 1, name: "xxx"})
      {:ok, %ZenEx.Entity.User{id: 1, name: "xxx", ...}}

  """
  @spec update(%User{}) :: {:ok, %User{}} | {:error, any()}
  def update(%User{} = user) do
    HTTPClient.put("/api/v2/users/#{user.id}.json", %{user: user}, user: User)
  end

  @doc """
  Create or update user specified by id.

  ## Examples

      iex> ZenEx.Model.User.create_or_update(%ZenEx.Entity.User{name: "xxx", email: "xxx@xxx"})
      {:ok, %ZenEx.Entity.User{id: xxx, name: "xxx", email: "xxx@xxx", ...}}

  """
  @spec create_or_update(%User{}) :: {:ok, %User{}} | {:error, any()}
  def create_or_update(%User{} = user) do
    HTTPClient.post("/api/v2/users/create_or_update.json", %{user: user}, user: User)
  end

  @doc """
  Delete (deactivate) user specified by id.

  ## Examples

      iex> ZenEx.Model.User.destroy(1)
      :ok

  """
  @spec destroy(integer) :: {:ok, %User{}} | {:error, any()}
  def destroy(id) when is_integer(id) do
    HTTPClient.delete("/api/v2/users/#{id}.json", user: User)
  end

  @doc """
  Permanently delete deactivated user specified by id.

  ## Examples

      iex> ZenEx.Model.User.permanently_destroy(1)
      :ok

  """
  @spec permanently_destroy(integer) :: {:ok, %User{}} | {:error, any()}
  def permanently_destroy(id) when is_integer(id) do
    HTTPClient.delete("/api/v2/deleted_users/#{id}.json", deleted_user: User)
  end

  @doc """
  Create multiple users.

  ## Examples

      iex> ZenEx.Model.User.create_many([%ZenEx.Entity.User{name: "xxx"}, ...])
      {:ok, %ZenEx.Entity.JobStatus{id: "xxx"}}

  """
  @spec create_many(list(%User{})) :: {:ok, %JobStatus{}} | {:error, any()}
  def create_many(users) when is_list(users) do
    HTTPClient.post("/api/v2/users/create_many.json", %{users: users}, job_status: JobStatus)
  end

  @doc """
  Update multiple users specified by id.

  ## Examples

      iex> ZenEx.Model.User.update_many([%ZenEx.Entity.User{id: xxx, name: "xxx"}, ...])
      {:ok, %ZenEx.Entity.JobStatus{id: "xxx"}}

  """
  @spec update_many(list(%User{})) :: {:ok, %JobStatus{}} | {:error, any()}
  def update_many(users) when is_list(users) do
    HTTPClient.put("/api/v2/users/update_many.json", %{users: users}, job_status: JobStatus)
  end

  @doc """
  Create or update multiple users specified by id.

  ## Examples

      iex> ZenEx.Model.User.create_or_update_many([%ZenEx.Entity.User{id: xxx, name: "xxx"}, ...])
      {:ok, %ZenEx.Entity.JobStatus{id: "xxx"}}

  """
  @spec create_or_update_many(list(%User{})) :: {:ok, %JobStatus{}} | {:error, any()}
  def create_or_update_many(users) when is_list(users) do
    HTTPClient.post("/api/v2/users/create_or_update_many.json", %{users: users},
      job_status: JobStatus
    )
  end

  @doc """
  Delete (deactivate) multiple users specified by id.

  ## Examples

      iex> ZenEx.Model.User.destroy_many([xxx, ...])
      {:ok, %ZenEx.Entity.JobStatus{id: "xxx"}}

  """
  @spec destroy_many(list(integer)) :: {:ok, %JobStatus{}} | {:error, any()}
  def destroy_many(ids) when is_list(ids) do
    HTTPClient.delete("/api/v2/users/destroy_many.json?ids=#{Enum.join(ids, ",")}",
      job_status: JobStatus
    )
  end

  @doc """
  Search for users specified by query.

  ## Examples

      iex> ZenEx.Model.User.search(%{email: "first.last@domain.com"})
      {:ok, %ZenEx.Collection{}}

      iex> ZenEx.Model.User.search("David"})
      {:ok, %ZenEx.Collection{}}

  """
  @spec search(map()) :: {:ok, %ZenEx.Collection{}} | {:error, any()}
  def search(opts) when is_map(opts) do
    search(SearchQuery.build(opts))
  end

  @spec search(String.t()) :: {:ok, %ZenEx.Collection{}} | {:error, any()}
  def search(query) do
    "/api/v2/users/search.json?query=#{query}"
    |> HTTPClient.get(users: [User])
  end
end
