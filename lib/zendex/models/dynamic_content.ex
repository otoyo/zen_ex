defmodule Zendex.Model.DynamicContent do
  alias Zendex.Core.Client
  alias Zendex.Model
  alias Zendex.Entity.DynamicContent

  @moduledoc """
  Provides functions to operate Zendesk Dynamic content.
  """


  @doc """
  List dynamic_contents.

  ## Examples

    iex> Zendex.Model.DynamicContent.list
    [%Zendex.Entity.DynamicContent{id: xxx, default_locale_id: xxx, variants: [%Zendex.Entity.DynamicContent.Variant{...}, ...], ...}, ...]

  """
  @spec list :: list(%DynamicContent{})
  def list do
    Client.get("/api/v2/dynamic_content/items.json") |> __create_dynamic_contents__
  end


  @doc """
  Show dynamic_content specified by id.

  ## Examples

    iex> Zendex.Model.DynamicContent.show(xxx)
    %Zendex.Entity.DynamicContent{id: xxx, default_locale_id: xxx, variants: [%Zendex.Entity.DynamicContent.Variant{...}, ...], ...}

  """
  @spec show(integer) :: %DynamicContent{}
  def show(id) when is_integer(id) do
    Client.get("/api/v2/dynamic_content/items/#{id}.json") |> __create_dynamic_content__
  end


  @doc """
  Create dynamic_content.

  ## Examples

    iex> Zendex.Model.DynamicContent.create(%Zendex.Entity.DynamicContent{default_locale_id: xxx, variants: [%Zendex.Entity.DynamicContent.Variant{...}, ...], ...})
    %Zendex.Entity.DynamicContent{id: xxx, default_locale_id: xxx, ...}

  """
  @spec create(%DynamicContent{}) :: %DynamicContent{}
  def create(%DynamicContent{} = dynamic_content) do
    Client.post("/api/v2/dynamic_content/items.json", %{item: dynamic_content}) |> __create_dynamic_content__
  end


  @doc """
  Update dynamic_content specified by id.
  This function won't change variants.

  ## Examples

    iex> Zendex.Model.DynamicContent.update(%Zendex.Entity.DynamicContent{id: xxx, default_locale_id: xxx, ...})
    %Zendex.Entity.DynamicContent{id: xxx, default_locale_id: xxx, ...}

  """
  @spec update(%DynamicContent{}) :: %DynamicContent{}
  def update(%DynamicContent{} = dynamic_content) do
    Client.put("/api/v2/dynamic_content/items/#{dynamic_content.id}.json", %{item: dynamic_content}) |> __create_dynamic_content__
  end


  @doc """
  Delete dynamic_content specified by id.

  ## Examples

    iex> Zendex.Model.DynamicContent.destroy(1)
    :ok

  """
  @spec destroy(integer) :: :ok | :error
  def destroy(id) when is_integer(id) do
    case Client.delete("/api/v2/dynamic_content/items/#{id}.json").status_code do
      204 -> :ok
      _   -> :error
    end
  end


  @doc false
  @spec __create_dynamic_contents__(%HTTPotion.Response{}) :: list(%DynamicContent{})
  def __create_dynamic_contents__(%HTTPotion.Response{} = res) do
    res.body
    |> Poison.decode!(keys: :atoms, as: %{items: [%DynamicContent{}]})
    |> Map.get(:items)
    |> Enum.map(fn dynamic_content ->
      Map.update(dynamic_content, :variants, [], &Model.DynamicContent.Variant.__create_variants__/1)
    end)
  end


  @doc false
  @spec __create_dynamic_content__(%HTTPotion.Response{}) :: %DynamicContent{}
  def __create_dynamic_content__(%HTTPotion.Response{} = res) do
    res.body
    |> Poison.decode!(keys: :atoms, as: %{item: %DynamicContent{}})
    |> Map.get(:item)
    |> Map.update(:variants, [], &Model.DynamicContent.Variant.__create_variants__/1)
  end
end
