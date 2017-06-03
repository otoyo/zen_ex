defmodule ZenEx.HelpCenter.Entity.Category do

  defstruct [:id, :name, :description, :locale, :source_locale, :url, :html_url,
             :outdated, :position, :translation_ids, :created_at, :updated_at]

  @moduledoc """
  Category entity corresponding to Zendesk HelpCenter Category
  """
end
