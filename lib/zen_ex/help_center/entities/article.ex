defmodule ZenEx.HelpCenter.Entity.Article do

  @derive Jason.Encoder
defstruct [:id, :url, :html_url, :title, :body, :locale, :source_locale, :author_id,
             :comments_disabled, :outdated_locales, :outdated, :label_names, :draft,
             :promoted, :position, :vote_sum, :vote_count, :section_id, :created_at, :updated_at]

  @moduledoc """
  Article entity corresponding to Zendesk HelpCenter Article
  """
end
