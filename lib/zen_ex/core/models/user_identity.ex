defmodule ZenEx.Model.UserIdentity do
  alias ZenEx.HTTPClient
  alias ZenEx.Query
  alias ZenEx.Entity.{User, UserIdentity}

  @moduledoc """
  Provides functions to operate Zendesk User Identities.
  """

  @doc """
  List user's identities.

  ## Examples

      iex> ZenEx.Model.UserIdentity.list(%ZenEx.Entity.User{id: xxx})
      %ZenEx.Collection{}

  """
  @spec list(%User{}) :: %ZenEx.Collection{} | {:error, String.t()}
  def list(%User{id: user_id}, opts \\ []) when is_list(opts) do
    "/api/v2/users/#{user_id}/identities#{Query.build(opts)}"
    |> HTTPClient.get(identities: [UserIdentity])
  end

  @doc """
  Show user's identity specified by id.

  ## Examples

      iex> ZenEx.Model.UserIdentity.show(%ZenEx.Entity.User{id: xxx}, 1)
      %ZenEx.Entity.UserIdentity{id: 1, type: "xxx", ...}

  """
  @spec show(%User{}, integer) :: %UserIdentity{} | {:error, String.t()}
  def show(%User{id: user_id}, id) when is_integer(id) do
    HTTPClient.get("/api/v2/users/#{user_id}/identities/#{id}.json", identity: UserIdentity)
  end

  @doc """
  Create user's identity.

  ## Examples

      iex> ZenEx.Model.UserIdentity.create(%ZenEx.Entity.User{id: xxx}, %ZenEx.Entity.UserIdentity{type: "xxx", value: "xxx"})
      %ZenEx.Entity.UserIdentity{id: xxx, value: "xxx", ...}

  """
  @spec create(%User{}, %UserIdentity{}) :: %UserIdentity{} | {:error, String.t()} | nil
  def create(%User{id: user_id}, %UserIdentity{} = identity) do
    HTTPClient.post("/api/v2/users/#{user_id}/identities.json", %{identity: identity},
      identity: UserIdentity
    )
  end

  @doc """
  Update user's identity specified by id.

  ## Examples

      iex> ZenEx.Model.UserIdentity.update(%ZenEx.Entity.User{id: 1}, %ZenEx.Entity.UserIdentity{id: xxx, type: "xxx"})
      %ZenEx.Entity.UserIdentity{id: 1, type: "xxx", ...}

  """
  @spec update(%User{}, %UserIdentity{}) :: %UserIdentity{} | {:error, String.t()}
  def update(%User{id: user_id}, %UserIdentity{} = identity) do
    HTTPClient.put(
      "/api/v2/users/#{user_id}/identities/#{identity.id}.json",
      %{identity: identity},
      identity: UserIdentity
    )
  end

  @doc """
  Make primary user's identity specified by id.

  ## Examples

      iex> ZenEx.Model.UserIdentity.make_primary(%ZenEx.Entity.User{id: 1}, 1)
      %ZenEx.Collection{}

  """
  @spec make_primary(%User{}, integer) :: %ZenEx.Collection{} | {:error, String.t()}
  def make_primary(%User{id: user_id}, id) when is_integer(id) do
    HTTPClient.put("/api/v2/users/#{user_id}/identities/#{id}/make_primary", %{},
      identities: [UserIdentity]
    )
  end

  @doc """
  Verify user's identity specified by id.

  ## Examples

      iex> ZenEx.Model.UserIdentity.verify(%ZenEx.Entity.User{id: 1}, 1)
      :ok

  """
  @spec verify(%User{}, integer) :: :ok | :error
  def verify(%User{id: user_id}, id) when is_integer(id) do
    case HTTPClient.put("/api/v2/users/#{user_id}/identities/#{id}/verify", %{}).status do
      200 -> :ok
      _ -> :error
    end
  end

  @doc """
  Request user verification for user's identity specified by id.

  ## Examples

      iex> ZenEx.Model.UserIdentity.request_user_verification(%ZenEx.Entity.User{id: 1}, 1)
      %ZenEx.Collection{}

  """
  @spec request_user_verification(%User{}, integer) :: :ok | :error
  def request_user_verification(%User{id: user_id}, id) when is_integer(id) do
    case HTTPClient.put("/api/v2/users/#{user_id}/identities/#{id}/request_verification", %{}).status do
      200 -> :ok
      _ -> :error
    end
  end

  @doc """
  Delete user's identity specified by id.

  ## Examples

      iex> ZenEx.Model.UserIdentity.destroy(%ZenEx.Entity.User{id: 1}, 1)
      :ok

  """
  @spec destroy(%User{}, integer) :: :ok | :error
  def destroy(%User{id: user_id}, id) when is_integer(id) do
    case HTTPClient.delete("/api/v2/users/#{user_id}/identities/#{id}.json").status do
      204 -> :ok
      _ -> :error
    end
  end
end
