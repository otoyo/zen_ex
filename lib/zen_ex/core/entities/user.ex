defmodule ZenEx.Entity.User do

  @derive Jason.Encoder
defstruct [:id, :url, :name, :external_id, :alias, :created_at, :updated_at,:active, :verified,
             :shared, :shared_agent, :locale, :locale_id, :time_zone, :last_login_at, :email, :phone,
             :signature, :details, :notes, :organization_id, :role, :custom_role_id, :moderator,
             :ticket_restriction, :only_private_comments, :tags, :restricted_agent, :suspended, :user_fields]

  @moduledoc """
  User entity corresponding to Zendesk User
  """
end
