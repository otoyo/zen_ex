defmodule ZenEx.HelpCenter.Model.Section do
  alias ZenEx.HTTPClient
  alias ZenEx.HelpCenter.Entity.Section

  @moduledoc """
  Provides functions to operate Zendesk HelpCenter Section.
  """

  @doc """
  List sections specified by bcp-47 code of locale (es-419, en-us, pr-br) or
  locale and category_id.

  ## Examples

      iex> ZenEx.HelpCenter.Model.Section.list("en-us")
      %ZenEx.Collection{}

  """
  @spec list(String.t) :: %ZenEx.Collection{}
  def list(locale) do
    HTTPClient.get("/api/v2/help_center/#{locale}/sections.json", sections: [Section])
  end

  @spec list(String.t, integer) :: %ZenEx.Collection{}
  def list(locale, category_id) when is_integer(category_id) do
    HTTPClient.get("/api/v2/help_center/#{locale}/categories/#{category_id}/sections.json", sections: [Section])
  end


  @doc """
  Show section specified by bcp-47 code of locale (es-419, en-us, pr-br) and id.

  ## Examples

      iex> ZenEx.HelpCenter.Model.Section.show("en-us", 1)
      %ZenEx.HelpCenter.Entity.Section{id: 1, name: xxx, locale: "en-us", ...}

  """
  @spec show(String.t, integer) :: %Section{}
  def show(locale, id) when is_integer(id) do
    HTTPClient.get("/api/v2/help_center/#{locale}/sections/#{id}.json", section: Section)
  end


  @doc """
  Create section.

  ## Examples

      iex> ZenEx.HelpCenter.Model.Section.create(%ZenEx.HelpCenter.Entity.Section{name: xxx, locale: xxx, ...})
      %ZenEx.HelpCenter.Entity.Section{name: xxx, locale: xxx, ...}

  """
  @spec create(%Section{}) :: %Section{}
  def create(%Section{} = section) do
    HTTPClient.post("/api/v2/help_center/sections.json", %{section: section}, section: Section)
  end


  @doc """
  Update section specified by id.

  ## Examples

      iex> ZenEx.HelpCenter.Model.Section.update(%ZenEx.HelpCenter.Entity.Section{id: 1, name: xxx, locale: xxx, ...})
      %ZenEx.HelpCenter.Entity.Section{id: 1, name: xxx, locale: xxx, ...}

  """
  @spec update(%Section{}) :: %Section{}
  def update(%Section{} = section) do
    HTTPClient.put("/api/v2/help_center/sections/#{section.id}.json", %{section: section}, section: Section)
  end


  @doc """
  Delete section specified by id.

  ## Examples

      iex> ZenEx.HelpCenter.Model.Section.destroy(1)
      :ok

  """
  @spec destroy(integer) :: :ok | :error
  def destroy(id) when is_integer(id) do
    case HTTPClient.delete("/api/v2/help_center/sections/#{id}.json").status_code do
      204 -> :ok
      _   -> :error
    end
  end
end
