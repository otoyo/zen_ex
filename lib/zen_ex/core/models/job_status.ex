defmodule ZenEx.Model.JobStatus do
  alias ZenEx.HTTPClient
  alias ZenEx.Query
  alias ZenEx.Entity.JobStatus

  @moduledoc """
  Provides functions to operate Zendesk JobStatus.
  """

  @doc """
  List job_statuses.

  ## Examples

      iex> ZenEx.Model.JobStatus.list
      %ZenEx.Collection{}

  """
  @spec list :: %ZenEx.Collection{}
  def list(opts \\ []) when is_list(opts) do
    "/api/v2/job_statuses.json#{Query.build(opts)}"
    |> HTTPClient.get(job_statuses: [JobStatus])
  end


  @doc """
  Show job_status specified by id.

  ## Examples

      iex> ZenEx.Model.JobStatus.show("xxx")
      %ZenEx.Entity.JobStatus{id: "xxx", ...}

  """
  @spec show(binary) :: %JobStatus{}
  def show(id) when is_binary(id) do
    HTTPClient.get("/api/v2/job_statuses/#{id}.json", job_status: JobStatus)
  end


  @doc """
  Show multiple job_statuses specified by ids.

  ## Examples

      iex> ZenEx.Model.JobStatus.show_many(["xxx", ...])
      %ZenEx.Collection{}

  """
  @spec show_many(list(binary)) :: %ZenEx.Collection{}
  def show_many(ids) when is_list(ids) do
    HTTPClient.get("/api/v2/job_statuses/show_many.json#{Query.build(ids: ids)}", job_statuses: [JobStatus])
  end
end
