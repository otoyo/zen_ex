defmodule ZenEx.HelpCenter.Model.Translation do
  alias ZenEx.HTTPClient
  alias ZenEx.HelpCenter.Entity.Translation

  @moduledoc """
  Provides functions to operate Zendesk HelpCenter Translation.
  """

  @doc """
  List translations by category or section or article id.

  ## Examples

      iex> ZenEx.HelpCenter.Model.Translation.list(article_id: 1)
      [%ZenEx.HelpCenter.Entity.Translation{id: xxx, title: xxx, locale: xxx, ...}, ...]

  """
  @spec list(category_id: integer) :: list(%Translation{})
  def list(category_id: category_id) do
    HTTPClient.get("/api/v2/help_center/categories/#{category_id}/translations.json") |> _create_translations
  end

  @spec list(section_id: integer) :: list(%Translation{})
  def list(section_id: section_id) do
    HTTPClient.get("/api/v2/help_center/sections/#{section_id}/translations.json") |> _create_translations
  end

  @spec list(article_id: integer) :: list(%Translation{})
  def list(article_id: article_id) do
    HTTPClient.get("/api/v2/help_center/articles/#{article_id}/translations.json") |> _create_translations
  end


  @doc """
  List missing locales by category or section or article id.

  ## Examples

      iex> ZenEx.HelpCenter.Model.Translation.list_missing(article_id: 1)
      ["en-us", "da-dk"]

  """
  @spec list_missing(category_id: integer) :: list(String.t)
  def list_missing(category_id: category_id) do
    HTTPClient.get("/api/v2/help_center/categories/#{category_id}/translations/missing.json").body
    |> Poison.decode!(keys: :atoms) |> Map.get(:locales)
  end

  @spec list_missing(section_id: integer) :: list(String.t)
  def list_missing(section_id: section_id) do
    HTTPClient.get("/api/v2/help_center/sections/#{section_id}/translations/missing.json").body
    |> Poison.decode!(keys: :atoms) |> Map.get(:locales)
  end

  @spec list_missing(article_id: integer) :: list(String.t)
  def list_missing(article_id: article_id) do
    HTTPClient.get("/api/v2/help_center/articles/#{article_id}/translations/missing.json").body
    |> Poison.decode!(keys: :atoms) |> Map.get(:locales)
  end


  @doc """
  Show translation specified by bcp-47 code of locale (es-419, en-us, pr-br) and article id.

  ## Examples

      iex> ZenEx.HelpCenter.Model.Translation.show("en-us", 1)
      %ZenEx.HelpCenter.Entity.Translation{id: 1, title: xxx, locale: "en-us", ...}

  """
  @spec show(String.t, integer) :: %Translation{}
  def show(locale, article_id) when is_integer(article_id) do
    HTTPClient.get("/api/v2/help_center/articles/#{article_id}/translations/#{locale}.json") |> _create_translation
  end


  @doc """
  Create translation specified by category or section or article id.

  ## Examples

      iex> ZenEx.HelpCenter.Model.Translation.create([article_id: 1], %ZenEx.HelpCenter.Entity.Translation{title: xxx, locale: xxx, ...})
      %ZenEx.HelpCenter.Entity.Translation{title: xxx, locale: xxx, ...}

  """
  @spec create([category_id: integer], %Translation{}) :: %Translation{}
  def create([category_id: category_id], %Translation{} = translation) do
    HTTPClient.post("/api/v2/help_center/categories/#{category_id}/translations.json", %{translation: translation}) |> _create_translation
  end

  @spec create([section_id: integer], %Translation{}) :: %Translation{}
  def create([section_id: section_id], %Translation{} = translation) do
    HTTPClient.post("/api/v2/help_center/sections/#{section_id}/translations.json", %{translation: translation}) |> _create_translation
  end

  @spec create([article_id: integer], %Translation{}) :: %Translation{}
  def create([article_id: article_id], %Translation{} = translation) do
    HTTPClient.post("/api/v2/help_center/articles/#{article_id}/translations.json", %{translation: translation}) |> _create_translation
  end


  @doc """
  Update translation specified by category or section or article id.

  ## Examples

      iex> ZenEx.HelpCenter.Model.Translation.update([article_id: 1], %ZenEx.HelpCenter.Entity.Translation{id: 1, title: xxx, locale: xxx, ...})
      %ZenEx.HelpCenter.Entity.Translation{id: 1, title: xxx, locale: xxx, ...}

  """
  @spec update([category_id: integer], %Translation{}) :: %Translation{}
  def update([category_id: category_id], %Translation{} = translation) do
    HTTPClient.put("/api/v2/help_center/categories/#{category_id}/translations/#{translation.locale}.json", %{translation: translation}) |> _create_translation
  end

  @spec update([section_id: integer], %Translation{}) :: %Translation{}
  def update([section_id: section_id], %Translation{} = translation) do
    HTTPClient.put("/api/v2/help_center/sections/#{section_id}/translations/#{translation.locale}.json", %{translation: translation}) |> _create_translation
  end

  @spec update([article_id: integer], %Translation{}) :: %Translation{}
  def update([article_id: article_id], %Translation{} = translation) do
    HTTPClient.put("/api/v2/help_center/articles/#{article_id}/translations/#{translation.locale}.json", %{translation: translation}) |> _create_translation
  end


  @doc """
  Delete translation specified by id.

  ## Examples

      iex> ZenEx.HelpCenter.Model.Translation.destroy(1)
      :ok

  """
  @spec destroy(integer) :: :ok | :error
  def destroy(id) when is_integer(id) do
    case HTTPClient.delete("/api/v2/help_center/translations/#{id}.json").status_code do
      204 -> :ok
      _   -> :error
    end
  end


  @doc false
  @spec _create_translations(%HTTPotion.Response{}) :: list(%Translation{})
  def _create_translations(%HTTPotion.Response{} = res) do
    res.body |> Poison.decode!(keys: :atoms, as: %{translations: [%Translation{}]}) |> Map.get(:translations)
  end


  @doc false
  @spec _create_translation(%HTTPotion.Response{}) :: %Translation{}
  def _create_translation(%HTTPotion.Response{} = res) do
    res.body |> Poison.decode!(keys: :atoms, as: %{translation: %Translation{}}) |> Map.get(:translation)
  end
end
