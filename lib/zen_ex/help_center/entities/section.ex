defmodule ZenEx.HelpCenter.Entity.Section do

  @derive Jason.Encoder
defstruct [:id, :name, :description, :locale, :source_locale, :url, :html_url,
             :category_id, :outdated, :position, :translation_ids, :created_at, :updated_at]

  @moduledoc """
  Section entity corresponding to Zendesk HelpCenter Section
  """
end
