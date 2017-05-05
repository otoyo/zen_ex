defmodule ZenEx.Entity.DynamicContent do

  defstruct [:id, :url, :name, :placeholder, :default_locale_id, :outdated, :created_at, :updated_at, :variants]

  @moduledoc """
  dynamic content (items) entity corresponding to Zendesk dynamic content
  """
end
