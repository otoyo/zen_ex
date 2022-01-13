defmodule ZenEx.Model.DynamicContent do
  alias ZenEx.HTTPClient
  alias ZenEx.Query
  alias ZenEx.Entity.{DynamicContent, DynamicContent.Variant}

  @moduledoc """
  Provides functions to operate Zendesk Dynamic content.
  """

  @doc """
  List dynamic_contents.

  ## Examples

      iex> ZenEx.Model.DynamicContent.list
      %ZenEx.Collection{}

  """
  @spec list :: %ZenEx.Collection{}
  def list(opts \\ []) when is_list(opts) do
    "/api/v2/dynamic_content/items.json#{Query.build(opts)}"
    |> HTTPClient.get(items: [DynamicContent])
    |> Map.update(:entities, [], fn dynamic_contents ->
      Enum.map(dynamic_contents, &_build_variants/1)
    end)
  end

  @doc """
  Show dynamic_content specified by id.

  ## Examples

      iex> ZenEx.Model.DynamicContent.show(xxx)
      %ZenEx.Entity.DynamicContent{id: xxx, default_locale_id: xxx, variants: [%ZenEx.Entity.DynamicContent.Variant{...}, ...], ...}

  """
  @spec show(integer) :: %DynamicContent{}
  def show(id) when is_integer(id) do
    HTTPClient.get("/api/v2/dynamic_content/items/#{id}.json", item: DynamicContent)
    |> _build_variants
  end

  @doc """
  Create dynamic_content.

  ## Examples

      iex> ZenEx.Model.DynamicContent.create(%ZenEx.Entity.DynamicContent{default_locale_id: xxx, variants: [%ZenEx.Entity.DynamicContent.Variant{...}, ...], ...})
      %ZenEx.Entity.DynamicContent{id: xxx, default_locale_id: xxx, ...}

  """
  @spec create(%DynamicContent{}) :: %DynamicContent{}
  def create(%DynamicContent{} = dynamic_content) do
    HTTPClient.post("/api/v2/dynamic_content/items.json", %{item: dynamic_content},
      item: DynamicContent
    )
    |> _build_variants
  end

  @doc """
  Update dynamic_content specified by id.
  This function won't change variants.

  ## Examples

      iex> ZenEx.Model.DynamicContent.update(%ZenEx.Entity.DynamicContent{id: xxx, default_locale_id: xxx, ...})
      %ZenEx.Entity.DynamicContent{id: xxx, default_locale_id: xxx, ...}

  """
  @spec update(%DynamicContent{}) :: %DynamicContent{}
  def update(%DynamicContent{} = dynamic_content) do
    HTTPClient.put(
      "/api/v2/dynamic_content/items/#{dynamic_content.id}.json",
      %{item: dynamic_content},
      item: DynamicContent
    )
    |> _build_variants
  end

  @doc """
  Delete dynamic_content specified by id.

  ## Examples

      iex> ZenEx.Model.DynamicContent.destroy(1)
      :ok

  """
  @spec destroy(integer) :: :ok | :error
  def destroy(id) when is_integer(id) do
    case HTTPClient.delete("/api/v2/dynamic_content/items/#{id}.json").status do
      204 -> :ok
      _ -> :error
    end
  end

  @doc false
  @spec _build_variants(%DynamicContent{}) :: %DynamicContent{}
  def _build_variants(%DynamicContent{} = dynamic_content) do
    dynamic_content
    |> Map.update(:variants, [], fn variants ->
      Enum.map(variants, fn variant -> struct(Variant, variant) end)
    end)
  end
end
