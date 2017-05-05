defmodule ZenEx.Model.DynamicContent.Variant do
  alias ZenEx.Core.Client
  alias ZenEx.Model
  alias ZenEx.Entity.JobStatus
  alias ZenEx.Entity.DynamicContent.Variant

  @moduledoc """
  Provides functions to operate variants of Zendesk Dynamic content.
  """


  @doc """
  List variants of the dynamic_content.

  ## Examples

      iex> ZenEx.Model.DynamicContent.Variant.list(xxx)
      [%ZenEx.Entity.DynamicContent.Variant{id: xxx, default: xxx, content: "xxx", ...}, ...]

  """
  @spec list(integer) :: list(%Variant{})
  def list(dynamic_content_id) when is_integer(dynamic_content_id) do
    Client.get("/api/v2/dynamic_content/items/#{dynamic_content_id}/variants.json") |> __create_variants__
  end


  @doc """
  Show variant of the dynamic_content specified by id.

  ## Examples

      iex> ZenEx.Model.DynamicContent.Variant.show(xxx)
      %ZenEx.Entity.DynamicContent.Variant{id: xxx, default: xxx, content: "xxx", ...}

  """
  @spec show(integer, integer) :: %Variant{}
  def show(dynamic_content_id, variant_id) when is_integer(dynamic_content_id) and is_integer(variant_id) do
    Client.get("/api/v2/dynamic_content/items/#{dynamic_content_id}/variants/#{variant_id}.json") |> __create_variant__
  end


  @doc """
  Create variant of the dynamic_content.

  ## Examples

      iex> ZenEx.Model.DynamicContent.Variant.create(%ZenEx.Entity.DynamicContent.Variant{id: xxx, default: xxx, content: "xxx", ...})
      %ZenEx.Entity.DynamicContent.Variant{id: xxx, default: xxx, content: "xxx", ...}

  """
  @spec create(integer, %Variant{}) :: %Variant{}
  def create(dynamic_content_id, %Variant{} = variant) when is_integer(dynamic_content_id) do
    Client.post("/api/v2/dynamic_content/items/#{dynamic_content_id}/variants.json", %{variant: variant}) |> __create_variant__
  end


  @doc """
  Create multiple variants of the dynamic_content.

  ## Examples

      iex> ZenEx.Model.DynamicContent.Variant.create_many([%ZenEx.Entity.DynamicContent.Variant{id: xxx, default: xxx, content: "xxx", ...}, ...])
      %ZenEx.Entity.JobStatus{id: "xxx"}

  """
  @spec create_many(integer, list(%Variant{})) :: %JobStatus{}
  def create_many(dynamic_content_id, variants) when is_integer(dynamic_content_id) and is_list(variants) do
    Client.post("/api/v2/dynamic_content/items/#{dynamic_content_id}/variants/create_many.json", %{variants: variants}) |> Model.JobStatus.__create_job_status__
  end


  @doc """
  Update variant of the dynamic_content specified by id.

  ## Examples

      iex> ZenEx.Model.DynamicContent.Variant.update(%ZenEx.Entity.DynamicContent.Variant{id: xxx, default: xxx, content: "xxx", ...})
      %ZenEx.Entity.DynamicContent.Variant{id: xxx, default: xxx, content: "xxx", ...}

  """
  @spec update(integer, %Variant{}) :: %Variant{}
  def update(dynamic_content_id, %Variant{} = variant) when is_integer(dynamic_content_id) do
    Client.put("/api/v2/dynamic_content/items/#{dynamic_content_id}/variants/#{variant.id}.json", %{variant: variant}) |> __create_variant__
  end


  @doc """
  Update multiple variants of the dynamic_content specified by id.

  ## Examples

      iex> ZenEx.Model.DynamicContent.Variant.update_many([%ZenEx.Entity.DynamicContent.Variant{id: xxx, default: xxx, content: "xxx", ...}, ...])
      %ZenEx.Entity.JobStatus{id: "xxx"}

  """
  @spec update_many(integer, list(%Variant{})) :: %JobStatus{}
  def update_many(dynamic_content_id, variants) when is_integer(dynamic_content_id) and is_list(variants) do
    Client.put("/api/v2/dynamic_content/items/#{dynamic_content_id}/variants/update_many.json", %{variants: variants}) |> Model.JobStatus.__create_job_status__
  end


  @doc """
  Delete variant of the dynamic_content specified by id.

  ## Examples

      iex> ZenEx.Model.DynamicContent.Variant.destroy(xxx, xxx)
      :ok

  """
  @spec destroy(integer, integer) :: :ok | :error
  def destroy(dynamic_content_id, variant_id) when is_integer(dynamic_content_id) and is_integer(variant_id) do
    case Client.delete("/api/v2/dynamic_content/items/#{dynamic_content_id}/variants/#{variant_id}.json").status_code do
      204 -> :ok
      _   -> :error
    end
  end


  @doc false
  @spec __create_variants__(%HTTPotion.Response{}) :: list(%Variant{})
  def __create_variants__(%HTTPotion.Response{} = res) do
    res.body |> Poison.decode!(keys: :atoms, as: %{variants: [%Variant{}]}) |> Map.get(:variants)
  end

  @spec __create_variants__(list(Map.t)) :: list(%Variant{})
  def __create_variants__(maps), do: Enum.map(maps, &__create_variant__/1)


  @doc false
  @spec __create_variant__(%HTTPotion.Response{}) :: %Variant{}
  def __create_variant__(%HTTPotion.Response{} = res) do
    res.body |> Poison.decode!(keys: :atoms, as: %{variant: %Variant{}}) |> Map.get(:variant)
  end

  @spec __create_variant__(Map.t) :: %Variant{}
  def __create_variant__(%{} = map), do: struct(Variant, map)
end
