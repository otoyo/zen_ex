defmodule ZenEx.HelpCenter.Entity.Translation do

  @derive Jason.Encoder
defstruct [:id, :url, :html_url, :source_id, :source_type, :locale, :title, :body,
             :outdated, :draft, :created_at, :updated_at, :updated_by_id, :created_by_id]

  @moduledoc """
  Translation entity corresponding to Zendesk HelpCenter Translation
  """
end
