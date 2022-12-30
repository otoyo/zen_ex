defmodule ZenEx.HelpCenter.Model.Article do
  alias ZenEx.HTTPClient
  alias ZenEx.Query
  alias ZenEx.HelpCenter.Entity.Article

  @moduledoc """
  Provides functions to operate Zendesk HelpCenter Article.
  """

  @doc """
  List articles specified by bcp-47 code of locale (es-419, en-us, pr-br) or
  locale and section_id.

  ## Examples

      iex> ZenEx.HelpCenter.Model.Article.list("en-us")
      {:ok, %ZenEx.Collection{}}

      iex> ZenEx.HelpCenter.Model.Article.list("en-us", 1)
      {:ok, %ZenEx.Collection{}}

  """
  @spec list(keyword()) :: {:ok, %ZenEx.Collection{}} | {:error, any()}
  def list(locale, section_id_or_opts \\ [], opts \\ []) when is_list(opts) do
    case section_id_or_opts do
      section_id when is_integer(section_id) ->
        "/api/v2/help_center/#{locale}/sections/#{section_id}/articles.json#{Query.build(opts)}"

      _ ->
        "/api/v2/help_center/#{locale}/articles.json#{Query.build(section_id_or_opts)}"
    end
    |> HTTPClient.get(articles: [Article])
  end

  @doc """
  Show article specified by bcp-47 code of locale (es-419, en-us, pr-br) and id.

  ## Examples

      iex> ZenEx.HelpCenter.Model.Article.show("en-us", 1)
      {:ok, %ZenEx.HelpCenter.Entity.Article{id: 1, name: xxx, locale: "en-us", ...}}

  """
  @spec show(String.t(), integer) :: {:ok, %Article{}} | {:error, any()}
  def show(locale, id) when is_integer(id) do
    HTTPClient.get("/api/v2/help_center/#{locale}/articles/#{id}.json", article: Article)
  end

  @doc """
  Create article.

  ## Examples

      iex> ZenEx.HelpCenter.Model.Article.create(%ZenEx.HelpCenter.Entity.Article{name: xxx, locale: xxx, ...})
      {:ok, %ZenEx.HelpCenter.Entity.Article{name: xxx, locale: xxx, ...}}

  """
  @spec create(%Article{}) :: {:ok, %Article{}} | {:error, any()}
  def create(%Article{} = article) do
    HTTPClient.post("/api/v2/help_center/articles.json", %{article: article}, article: Article)
  end

  @doc """
  Update article specified by id.

  ## Examples

      iex> ZenEx.HelpCenter.Model.Article.update(%ZenEx.HelpCenter.Entity.Article{id: 1, name: xxx, locale: xxx, ...})
      {:ok, %ZenEx.HelpCenter.Entity.Article{id: 1, name: xxx, locale: xxx, ...}}

  """
  @spec update(%Article{}) :: {:ok, %Article{}} | {:error, any()}
  def update(%Article{} = article) do
    HTTPClient.put("/api/v2/help_center/articles/#{article.id}.json", %{article: article},
      article: Article
    )
  end

  @doc """
  Delete article specified by id.

  ## Examples

      iex> ZenEx.HelpCenter.Model.Article.destroy(1)
      :ok

  """
  @spec destroy(integer) :: :ok | {:error, any()}
  def destroy(id) when is_integer(id) do
    HTTPClient.delete("/api/v2/help_center/articles/#{id}.json")
    |> case do
      {:ok, _} -> :ok
      {:error, response} -> {:error, response}
    end
  end

  @doc """
  Search articles by using query.

  ## Examples

      iex> ZenEx.HelpCenter.Model.Article.search("query={search_string}&updated_after=2017-01-01")
      {:ok, %ZenEx.Collection{}}

  """
  @spec search(String.t()) :: {:ok, %ZenEx.Collection{}} | {:error, any()}
  def search(query) do
    HTTPClient.get("/api/v2/help_center/articles/search.json?#{query}", results: [Article])
  end
end
