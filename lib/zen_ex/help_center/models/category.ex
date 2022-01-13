defmodule ZenEx.HelpCenter.Model.Category do
  alias ZenEx.HTTPClient
  alias ZenEx.Query
  alias ZenEx.HelpCenter.Entity.Category

  @moduledoc """
  Provides functions to operate Zendesk HelpCenter Category.
  """

  @doc """
  List categories specified by bcp-47 code of locale (es-419, en-us, pr-br).

  ## Examples

      iex> ZenEx.HelpCenter.Model.Category.list("en-us")
      %ZenEx.Collection{}

  """
  @spec list(keyword()) :: %ZenEx.Collection{}
  def list(locale, opts \\ []) when is_list(opts) do
    "/api/v2/help_center/#{locale}/categories.json#{Query.build(opts)}"
    |> HTTPClient.get(categories: [Category])
  end


  @doc """
  Show category specified by bcp-47 code of locale (es-419, en-us, pr-br) and id.

  ## Examples

      iex> ZenEx.HelpCenter.Model.Category.show("en-us", 1)
      %ZenEx.HelpCenter.Entity.Category{id: 1, name: xxx, locale: "en-us", ...}

  """
  @spec show(String.t, integer) :: %Category{}
  def show(locale, id) when is_integer(id) do
    HTTPClient.get("/api/v2/help_center/#{locale}/categories/#{id}.json", category: Category)
  end


  @doc """
  Create category.

  ## Examples

      iex> ZenEx.HelpCenter.Model.Category.create(%ZenEx.HelpCenter.Entity.Category{name: xxx, locale: xxx, ...})
      %ZenEx.HelpCenter.Entity.Category{name: xxx, locale: xxx, ...}

  """
  @spec create(%Category{}) :: %Category{}
  def create(%Category{} = category) do
    HTTPClient.post("/api/v2/help_center/categories.json", %{category: category}, category: Category)
  end


  @doc """
  Update category specified by id.

  ## Examples

      iex> ZenEx.HelpCenter.Model.Category.update(%ZenEx.HelpCenter.Entity.Category{id: 1, name: xxx, locale: xxx, ...})
      %ZenEx.HelpCenter.Entity.Category{id: 1, name: xxx, locale: xxx, ...}

  """
  @spec update(%Category{}) :: %Category{}
  def update(%Category{} = category) do
    HTTPClient.put("/api/v2/help_center/categories/#{category.id}.json", %{category: category}, category: Category)
  end


  @doc """
  Delete category specified by id.

  ## Examples

      iex> ZenEx.HelpCenter.Model.Category.destroy(1)
      :ok

  """
  @spec destroy(integer) :: :ok | :error
  def destroy(id) when is_integer(id) do
    case HTTPClient.delete("/api/v2/help_center/categories/#{id}.json").status do
      204 -> :ok
      _   -> :error
    end
  end
end
