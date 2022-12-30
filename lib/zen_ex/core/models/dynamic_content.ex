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
      {:ok, %ZenEx.Collection{}}

  """
  @spec list :: {:ok, %ZenEx.Collection{}} | {:error, any()}
  def list(opts \\ []) when is_list(opts) do
    HTTPClient.get("/api/v2/dynamic_content/items.json#{Query.build(opts)}",
      items: [DynamicContent]
    )
    |> case do
      {:ok, collection} ->
        collection_with_variants =
          Map.update(collection, :entities, [], fn dynamic_contents ->
            Enum.map(dynamic_contents, &_build_variants/1)
          end)

        {:ok, collection_with_variants}

      {:error, err} ->
        {:error, err}
    end
  end

  @doc """
  Show dynamic_content specified by id.

  ## Examples

      iex> ZenEx.Model.DynamicContent.show(xxx)
      {:ok, %ZenEx.Entity.DynamicContent{id: xxx, default_locale_id: xxx, variants: [%ZenEx.Entity.DynamicContent.Variant{...}, ...], ...}}

  """
  @spec show(integer) :: {:ok, %DynamicContent{}} | {:error, any()}
  def show(id) when is_integer(id) do
    HTTPClient.get("/api/v2/dynamic_content/items/#{id}.json", item: DynamicContent)
    |> case do
      {:ok, dynamic_content} -> {:ok, _build_variants(dynamic_content)}
      {:error, response} -> {:error, response}
    end
  end

  @doc """
  Create dynamic_content.

  ## Examples

      iex> ZenEx.Model.DynamicContent.create(%ZenEx.Entity.DynamicContent{default_locale_id: xxx, variants: [%ZenEx.Entity.DynamicContent.Variant{...}, ...], ...})
      {:ok, %ZenEx.Entity.DynamicContent{id: xxx, default_locale_id: xxx, ...}}

  """
  @spec create(%DynamicContent{}) :: {:ok, %DynamicContent{}} | {:error, any()}
  def create(%DynamicContent{} = dynamic_content) do
    HTTPClient.post("/api/v2/dynamic_content/items.json", %{item: dynamic_content},
      item: DynamicContent
    )
    |> case do
      {:ok, dynamic_content} -> {:ok, _build_variants(dynamic_content)}
      {:error, response} -> {:error, response}
    end
  end

  @doc """
  Update dynamic_content specified by id.
  This function won't change variants.

  ## Examples

      iex> ZenEx.Model.DynamicContent.update(%ZenEx.Entity.DynamicContent{id: xxx, default_locale_id: xxx, ...})
      {:ok, %ZenEx.Entity.DynamicContent{id: xxx, default_locale_id: xxx, ...}}

  """
  @spec update(%DynamicContent{}) :: {:ok, %DynamicContent{}} | {:error, any()}
  def update(%DynamicContent{} = dynamic_content) do
    HTTPClient.put(
      "/api/v2/dynamic_content/items/#{dynamic_content.id}.json",
      %{item: dynamic_content},
      item: DynamicContent
    )
    |> case do
      {:ok, dynamic_content} -> {:ok, _build_variants(dynamic_content)}
      {:error, response} -> {:error, response}
    end
  end

  @doc """
  Delete dynamic_content specified by id.

  ## Examples

      iex> ZenEx.Model.DynamicContent.destroy(1)
      :ok

  """
  @spec destroy(integer) :: :ok | {:error, any()}
  def destroy(id) when is_integer(id) do
    HTTPClient.delete("/api/v2/dynamic_content/items/#{id}.json")
    |> case do
      {:ok, _} -> :ok
      {:error, response} -> {:error, response}
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
