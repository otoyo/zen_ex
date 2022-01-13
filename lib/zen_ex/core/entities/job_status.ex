defmodule ZenEx.Entity.JobStatus do
  @derive Jason.Encoder
  defstruct [:id, :url, :total, :progress, :status, :message, :results]

  @moduledoc """
  JobStatus entity corresponding to Zendesk JobStatus
  """
end
