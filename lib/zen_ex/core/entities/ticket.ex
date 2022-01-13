defmodule ZenEx.Entity.Ticket do
  @derive Jason.Encoder
  defstruct [
    :id,
    :url,
    :external_id,
    :created_at,
    :updated_at,
    :type,
    :subject,
    :raw_subject,
    :description,
    :priority,
    :status,
    :recipient,
    :requester_id,
    :submitter_id,
    :assignee_id,
    :organization_id,
    :group_id,
    :collaborator_ids,
    :forum_topic_id,
    :problem_id,
    :has_incidents,
    :due_at,
    :tags,
    :via,
    :ticket_form_id,
    :custom_fields,
    :satisfaction_rating,
    :sharing_agreement_ids
  ]

  @moduledoc """
  Ticket entity corresponding to Zendesk Ticket
  """
end
