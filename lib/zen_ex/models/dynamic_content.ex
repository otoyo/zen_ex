defmodule ZenEx.Model.DynamicContent do
  alias ZenEx.HTTPClient
  alias ZenEx.Model
  alias ZenEx.Entity.DynamicContent

  @moduledoc """
  Provides functions to operate Zendesk Dynamic content.
  """


  @doc """
  List dynamic_contents.

  ## Examples

      iex> ZenEx.Model.DynamicContent.list
      [%ZenEx.Entity.DynamicContent{id: xxx, default_locale_id: xxx, variants: [%ZenEx.Entity.DynamicContent.Variant{...}, ...], ...}, ...]

  """
  @spec list :: list(%DynamicContent{})
  def list do
    HTTPClient.get("/api/v2/dynamic_content/items.json") |> _create_dynamic_contents
  end


  @doc """
  Show dynamic_content specified by id.

  ## Examples

      iex> ZenEx.Model.DynamicContent.show(xxx)
      %ZenEx.Entity.DynamicContent{id: xxx, default_locale_id: xxx, variants: [%ZenEx.Entity.DynamicContent.Variant{...}, ...], ...}

  """
  @spec show(integer) :: %DynamicContent{}
  def show(id) when is_integer(id) do
    HTTPClient.get("/api/v2/dynamic_content/items/#{id}.json") |> _create_dynamic_content
  end


  @doc """
  Create dynamic_content.

  ## Examples

      iex> ZenEx.Model.DynamicContent.create(%ZenEx.Entity.DynamicContent{default_locale_id: xxx, variants: [%ZenEx.Entity.DynamicContent.Variant{...}, ...], ...})
      %ZenEx.Entity.DynamicContent{id: xxx, default_locale_id: xxx, ...}

  """
  @spec create(%DynamicContent{}) :: %DynamicContent{}
  def create(%DynamicContent{} = dynamic_content) do
    HTTPClient.post("/api/v2/dynamic_content/items.json", %{item: dynamic_content}) |> _create_dynamic_content
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
    HTTPClient.put("/api/v2/dynamic_content/items/#{dynamic_content.id}.json", %{item: dynamic_content}) |> _create_dynamic_content
  end


  @doc """
  Delete dynamic_content specified by id.

  ## Examples

      iex> ZenEx.Model.DynamicContent.destroy(1)
      :ok

  """
  @spec destroy(integer) :: :ok | :error
  def destroy(id) when is_integer(id) do
    case HTTPClient.delete("/api/v2/dynamic_content/items/#{id}.json").status_code do
      204 -> :ok
      _   -> :error
    end
  end


  @doc false
  @spec _create_dynamic_contents(%HTTPotion.Response{}) :: list(%DynamicContent{})
  def _create_dynamic_contents(%HTTPotion.Response{} = res) do
    res.body
    |> Poison.decode!(keys: :atoms, as: %{items: [%DynamicContent{}]})
    |> Map.get(:items)
    |> Enum.map(fn dynamic_content ->
      Map.update(dynamic_content, :variants, [], &Model.DynamicContent.Variant._create_variants/1)
    end)
  end


  @doc false
  @spec _create_dynamic_content(%HTTPotion.Response{}) :: %DynamicContent{}
  def _create_dynamic_content(%HTTPotion.Response{} = res) do
    res.body
    |> Poison.decode!(keys: :atoms, as: %{item: %DynamicContent{}})
    |> Map.get(:item)
    |> Map.update(:variants, [], &Model.DynamicContent.Variant._create_variants/1)
  end
end
