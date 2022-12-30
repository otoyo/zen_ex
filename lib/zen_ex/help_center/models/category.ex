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
      {:ok, %ZenEx.Collection{}}

  """
  @spec list(keyword()) :: {:ok, %ZenEx.Collection{}} | {:error, any()}
  def list(locale, opts \\ []) when is_list(opts) do
    "/api/v2/help_center/#{locale}/categories.json#{Query.build(opts)}"
    |> HTTPClient.get(categories: [Category])
  end

  @doc """
  Show category specified by bcp-47 code of locale (es-419, en-us, pr-br) and id.

  ## Examples

      iex> ZenEx.HelpCenter.Model.Category.show("en-us", 1)
      {:ok, %ZenEx.HelpCenter.Entity.Category{id: 1, name: xxx, locale: "en-us", ...}}

  """
  @spec show(String.t(), integer) :: {:ok, %Category{}} | {:error, any()}
  def show(locale, id) when is_integer(id) do
    HTTPClient.get("/api/v2/help_center/#{locale}/categories/#{id}.json", category: Category)
  end

  @doc """
  Create category.

  ## Examples

      iex> ZenEx.HelpCenter.Model.Category.create(%ZenEx.HelpCenter.Entity.Category{name: xxx, locale: xxx, ...})
      {:ok, %ZenEx.HelpCenter.Entity.Category{name: xxx, locale: xxx, ...}}

  """
  @spec create(%Category{}) :: {:ok, %Category{}} | {:error, any()}
  def create(%Category{} = category) do
    HTTPClient.post("/api/v2/help_center/categories.json", %{category: category},
      category: Category
    )
  end

  @doc """
  Update category specified by id.

  ## Examples

      iex> ZenEx.HelpCenter.Model.Category.update(%ZenEx.HelpCenter.Entity.Category{id: 1, name: xxx, locale: xxx, ...})
      {:ok, %ZenEx.HelpCenter.Entity.Category{id: 1, name: xxx, locale: xxx, ...}}

  """
  @spec update(%Category{}) :: {:ok, %Category{}} | {:error, any()}
  def update(%Category{} = category) do
    HTTPClient.put("/api/v2/help_center/categories/#{category.id}.json", %{category: category},
      category: Category
    )
  end

  @doc """
  Delete category specified by id.

  ## Examples

      iex> ZenEx.HelpCenter.Model.Category.destroy(1)
      :ok

  """
  @spec destroy(integer) :: :ok | {:error, any()}
  def destroy(id) when is_integer(id) do
    HTTPClient.delete("/api/v2/help_center/categories/#{id}.json")
    |> case do
      {:ok, _} -> :ok
      {:error, response} -> {:error, response}
    end
  end
end
