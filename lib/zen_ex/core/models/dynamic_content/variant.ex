defmodule ZenEx.Model.DynamicContent.Variant do
  alias ZenEx.HTTPClient
  alias ZenEx.Query
  alias ZenEx.Entity.JobStatus
  alias ZenEx.Entity.DynamicContent.Variant

  @moduledoc """
  Provides functions to operate variants of Zendesk Dynamic content.
  """

  @doc """
  List variants of the dynamic_content.

  ## Examples

      iex> ZenEx.Model.DynamicContent.Variant.list(xxx)
      {:ok, %ZenEx.Collection{}}

  """
  @spec list(integer) :: {:ok, %ZenEx.Collection{}} | {:error, any()}
  def list(dynamic_content_id, opts \\ [])
      when is_integer(dynamic_content_id) and is_list(opts) do
    "/api/v2/dynamic_content/items/#{dynamic_content_id}/variants.json#{Query.build(opts)}"
    |> HTTPClient.get(variants: [Variant])
  end

  @doc """
  Show variant of the dynamic_content specified by id.

  ## Examples

      iex> ZenEx.Model.DynamicContent.Variant.show(xxx)
      {:ok, %ZenEx.Entity.DynamicContent.Variant{id: xxx, default: xxx, content: "xxx", ...}}

  """
  @spec show(integer, integer) :: {:ok, %Variant{}} | {:error, any()}
  def show(dynamic_content_id, variant_id)
      when is_integer(dynamic_content_id) and is_integer(variant_id) do
    HTTPClient.get(
      "/api/v2/dynamic_content/items/#{dynamic_content_id}/variants/#{variant_id}.json",
      variant: Variant
    )
  end

  @doc """
  Create variant of the dynamic_content.

  ## Examples

      iex> ZenEx.Model.DynamicContent.Variant.create(%ZenEx.Entity.DynamicContent.Variant{id: xxx, default: xxx, content: "xxx", ...})
      {:ok, %ZenEx.Entity.DynamicContent.Variant{id: xxx, default: xxx, content: "xxx", ...}}

  """
  @spec create(integer, %Variant{}) :: {:ok, %Variant{}} | {:error, any()}
  def create(dynamic_content_id, %Variant{} = variant) when is_integer(dynamic_content_id) do
    HTTPClient.post(
      "/api/v2/dynamic_content/items/#{dynamic_content_id}/variants.json",
      %{variant: variant},
      variant: Variant
    )
  end

  @doc """
  Create multiple variants of the dynamic_content.

  ## Examples

      iex> ZenEx.Model.DynamicContent.Variant.create_many([%ZenEx.Entity.DynamicContent.Variant{id: xxx, default: xxx, content: "xxx", ...}, ...])
      {:ok, %ZenEx.Entity.JobStatus{id: "xxx"}}

  """
  @spec create_many(integer, list(%Variant{})) :: {:ok, %JobStatus{}} | {:error, any()}
  def create_many(dynamic_content_id, variants)
      when is_integer(dynamic_content_id) and is_list(variants) do
    HTTPClient.post(
      "/api/v2/dynamic_content/items/#{dynamic_content_id}/variants/create_many.json",
      %{variants: variants},
      job_status: JobStatus
    )
  end

  @doc """
  Update variant of the dynamic_content specified by id.

  ## Examples

      iex> ZenEx.Model.DynamicContent.Variant.update(%ZenEx.Entity.DynamicContent.Variant{id: xxx, default: xxx, content: "xxx", ...})
      {:ok, %ZenEx.Entity.DynamicContent.Variant{id: xxx, default: xxx, content: "xxx", ...}}

  """
  @spec update(integer, %Variant{}) :: {:ok, %Variant{}} | {:error, any()}
  def update(dynamic_content_id, %Variant{} = variant) when is_integer(dynamic_content_id) do
    HTTPClient.put(
      "/api/v2/dynamic_content/items/#{dynamic_content_id}/variants/#{variant.id}.json",
      %{variant: variant},
      variant: Variant
    )
  end

  @doc """
  Update multiple variants of the dynamic_content specified by id.

  ## Examples

      iex> ZenEx.Model.DynamicContent.Variant.update_many([%ZenEx.Entity.DynamicContent.Variant{id: xxx, default: xxx, content: "xxx", ...}, ...])
      {:ok, %ZenEx.Entity.JobStatus{id: "xxx"}}

  """
  @spec update_many(integer, list(%Variant{})) :: {:ok, %JobStatus{}} | {:error, any()}
  def update_many(dynamic_content_id, variants)
      when is_integer(dynamic_content_id) and is_list(variants) do
    HTTPClient.put(
      "/api/v2/dynamic_content/items/#{dynamic_content_id}/variants/update_many.json",
      %{variants: variants},
      job_status: JobStatus
    )
  end

  @doc """
  Delete variant of the dynamic_content specified by id.

  ## Examples

      iex> ZenEx.Model.DynamicContent.Variant.destroy(xxx, xxx)
      :ok

  """
  @spec destroy(integer, integer) :: :ok | {:error, any()}
  def destroy(dynamic_content_id, variant_id)
      when is_integer(dynamic_content_id) and is_integer(variant_id) do
    HTTPClient.delete(
      "/api/v2/dynamic_content/items/#{dynamic_content_id}/variants/#{variant_id}.json"
    )
    |> case do
      {:ok, _} -> :ok
      {:error, response} -> {:error, response}
    end
  end
end
