defmodule ZenEx.Model.JobStatus do
  alias ZenEx.HTTPClient
  alias ZenEx.Entity.JobStatus

  @moduledoc """
  Provides functions to operate Zendesk JobStatus.
  """

  @doc """
  List job_statuses.

  ## Examples

      iex> ZenEx.Model.JobStatus.list
      [%ZenEx.Entity.JobStatus{id: xxx, ...}, ...]

  """
  @spec list :: list(%JobStatus{})
  def list do
    HTTPClient.get("/api/v2/job_statuses.json") |> _create_job_statuses
  end


  @doc """
  Show job_status specified by id.

  ## Examples

      iex> ZenEx.Model.JobStatus.show("xxx")
      %ZenEx.Entity.JobStatus{id: "xxx", ...}

  """
  @spec show(binary) :: %JobStatus{}
  def show(id) when is_binary(id) do
    HTTPClient.get("/api/v2/job_statuses/#{id}.json") |> _create_job_status
  end


  @doc """
  Show multiple job_statuses specified by ids.

  ## Examples

      iex> ZenEx.Model.JobStatus.show_many(["xxx", ...])
      [%ZenEx.Entity.JobStatus{id: "xxx", ...}, ...]

  """
  @spec show_many(list(binary)) :: list(%JobStatus{})
  def show_many(ids) when is_list(ids) do
    HTTPClient.get("/api/v2/job_statuses/show_many.json?ids=#{Enum.join(ids, ",")}") |> _create_job_statuses
  end


  @doc false
  @spec _create_job_statuses(%HTTPotion.Response{}) :: list(%JobStatus{})
  def _create_job_statuses(%HTTPotion.Response{} = res) do
    res.body |> Poison.decode!(keys: :atoms, as: %{job_statuses: [%JobStatus{}]}) |> Map.get(:job_statuses)
  end


  @doc false
  @spec _create_job_status(%HTTPotion.Response{}) :: %JobStatus{}
  def _create_job_status(%HTTPotion.Response{} = res) do
    res.body |> Poison.decode!(keys: :atoms, as: %{job_status: %JobStatus{}}) |> Map.get(:job_status)
  end
end
