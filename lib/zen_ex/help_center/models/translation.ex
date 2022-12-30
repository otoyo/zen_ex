defmodule ZenEx.HelpCenter.Model.Translation do
  alias ZenEx.HTTPClient
  alias ZenEx.Query
  alias ZenEx.HelpCenter.Entity.Translation

  @moduledoc """
  Provides functions to operate Zendesk HelpCenter Translation.
  """

  @doc """
  List translations by category or section or article id.

  ## Examples

      iex> ZenEx.HelpCenter.Model.Translation.list(article_id: 1)
      {:ok, %ZenEx.Collection{}}

  """
  @spec list(keyword()) :: {:ok, %ZenEx.Collection{}} | {:error, any()}
  def list(_, opts \\ [])

  def list([category_id: category_id], opts) when is_list(opts) do
    "/api/v2/help_center/categories/#{category_id}/translations.json#{Query.build(opts)}"
    |> HTTPClient.get(translations: [Translation])
  end

  def list([section_id: section_id], opts) when is_list(opts) do
    "/api/v2/help_center/sections/#{section_id}/translations.json#{Query.build(opts)}"
    |> HTTPClient.get(translations: [Translation])
  end

  def list([article_id: article_id], opts) when is_list(opts) do
    "/api/v2/help_center/articles/#{article_id}/translations.json#{Query.build(opts)}"
    |> HTTPClient.get(translations: [Translation])
  end

  @doc """
  List missing locales by category or section or article id.

  ## Examples

      iex> ZenEx.HelpCenter.Model.Translation.list_missing(article_id: 1)
      {:ok, ["en-us", "da-dk"]}

  """
  @spec list_missing(category_id: integer) :: {:ok, list(String.t())} | {:error, any()}
  def list_missing(category_id: category_id) do
    with {:ok, %{body: body}} <-
           HTTPClient.get(
             "/api/v2/help_center/categories/#{category_id}/translations/missing.json"
           ),
         {:ok, decoded_body} <- Poison.decode(body, keys: :atoms) do
      Map.fetch(decoded_body, :locales)
    else
      {:error, err} -> {:error, err}
    end
  end

  @spec list_missing(section_id: integer) :: {:ok, list(String.t())} | {:error, any()}
  def list_missing(section_id: section_id) do
    with {:ok, %{body: body}} <-
           HTTPClient.get("/api/v2/help_center/sections/#{section_id}/translations/missing.json"),
         {:ok, decoded_body} <- Poison.decode(body, keys: :atoms) do
      Map.fetch(decoded_body, :locales)
    else
      {:error, err} -> {:error, err}
    end
  end

  @spec list_missing(article_id: integer) :: {:ok, list(String.t())} | {:error, any()}
  def list_missing(article_id: article_id) do
    with {:ok, %{body: body}} <-
           HTTPClient.get("/api/v2/help_center/articles/#{article_id}/translations/missing.json"),
         {:ok, decoded_body} <- Poison.decode(body, keys: :atoms) do
      Map.fetch(decoded_body, :locales)
    else
      {:error, err} -> {:error, err}
    end
  end

  @doc """
  Show translation specified by bcp-47 code of locale (es-419, en-us, pr-br) and article id.

  ## Examples

      iex> ZenEx.HelpCenter.Model.Translation.show("en-us", 1)
      {:ok, %ZenEx.HelpCenter.Entity.Translation{id: 1, title: xxx, locale: "en-us", ...}}

  """
  @spec show(String.t(), integer) :: {:ok, %Translation{}} | {:error, any()}
  def show(locale, article_id) when is_integer(article_id) do
    HTTPClient.get("/api/v2/help_center/articles/#{article_id}/translations/#{locale}.json",
      translation: Translation
    )
  end

  @doc """
  Create translation specified by category or section or article id.

  ## Examples

      iex> ZenEx.HelpCenter.Model.Translation.create([article_id: 1], %ZenEx.HelpCenter.Entity.Translation{title: xxx, locale: xxx, ...})
      {:ok, %ZenEx.HelpCenter.Entity.Translation{title: xxx, locale: xxx, ...}}

  """
  @spec create([category_id: integer], %Translation{}) :: {:ok, %Translation{}} | {:error, any()}
  def create([category_id: category_id], %Translation{} = translation) do
    HTTPClient.post(
      "/api/v2/help_center/categories/#{category_id}/translations.json",
      %{translation: translation},
      translation: Translation
    )
  end

  @spec create([section_id: integer], %Translation{}) :: {:ok, %Translation{}} | {:error, any()}
  def create([section_id: section_id], %Translation{} = translation) do
    HTTPClient.post(
      "/api/v2/help_center/sections/#{section_id}/translations.json",
      %{translation: translation},
      translation: Translation
    )
  end

  @spec create([article_id: integer], %Translation{}) :: {:ok, %Translation{}} | {:error, any()}
  def create([article_id: article_id], %Translation{} = translation) do
    HTTPClient.post(
      "/api/v2/help_center/articles/#{article_id}/translations.json",
      %{translation: translation},
      translation: Translation
    )
  end

  @doc """
  Update translation specified by category or section or article id.

  ## Examples

      iex> ZenEx.HelpCenter.Model.Translation.update([article_id: 1], %ZenEx.HelpCenter.Entity.Translation{id: 1, title: xxx, locale: xxx, ...})
      {:ok, %ZenEx.HelpCenter.Entity.Translation{id: 1, title: xxx, locale: xxx, ...}}

  """
  @spec update([category_id: integer], %Translation{}) :: {:ok, %Translation{}} | {:error, any()}
  def update([category_id: category_id], %Translation{} = translation) do
    HTTPClient.put(
      "/api/v2/help_center/categories/#{category_id}/translations/#{translation.locale}.json",
      %{translation: translation},
      translation: Translation
    )
  end

  @spec update([section_id: integer], %Translation{}) :: {:ok, %Translation{}} | {:error, any()}
  def update([section_id: section_id], %Translation{} = translation) do
    HTTPClient.put(
      "/api/v2/help_center/sections/#{section_id}/translations/#{translation.locale}.json",
      %{translation: translation},
      translation: Translation
    )
  end

  @spec update([article_id: integer], %Translation{}) :: {:ok, %Translation{}} | {:error, any()}
  def update([article_id: article_id], %Translation{} = translation) do
    HTTPClient.put(
      "/api/v2/help_center/articles/#{article_id}/translations/#{translation.locale}.json",
      %{translation: translation},
      translation: Translation
    )
  end

  @doc """
  Delete translation specified by id.

  ## Examples

      iex> ZenEx.HelpCenter.Model.Translation.destroy(1)
      :ok

  """
  @spec destroy(integer) :: :ok | {:error, any()}
  def destroy(id) when is_integer(id) do
    HTTPClient.delete("/api/v2/help_center/translations/#{id}.json")
    |> case do
      {:ok, _} -> :ok
      {:error, response} -> {:error, response}
    end
  end
end
