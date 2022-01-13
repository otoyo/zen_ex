defmodule ZenEx.Entity.Locale do

  @derive Jason.Encoder
defstruct [:id, :url, :locale, :name, :created_at, :updated_at]

  @moduledoc """
  Locale entity corresponding to Zendesk Locale
  """
end
