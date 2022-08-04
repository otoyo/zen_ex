defmodule ZenEx.Entity.UserIdentity do
  @derive Jason.Encoder
  defstruct [
    :id,
    :created_at,
    :deliverable_state,
    :primary,
    :type,
    :undeliverable_count,
    :updated_at,
    :url,
    :user_id,
    :value,
    :verified
  ]

  @moduledoc """
  User Identity entity corresponding to Zendesk User Identity
  """
end
