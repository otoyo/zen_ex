defmodule Zendex.Model.JobStatus do
  alias Zendex.Core.Client
  alias Zendex.Entity.JobStatus

  @spec list :: list(%JobStatus{})
  def list do
    Client.get("/api/v2/job_statuses.json") |> response_to_job_statuses
  end

  @spec show(binary) :: %JobStatus{}
  def show(id) when is_binary(id) do
    Client.get("/api/v2/job_statuses/#{id}.json") |> response_to_job_status
  end

  @spec show_many(list(binary)) :: list(%JobStatus{})
  def show_many(ids) when is_list(ids) do
    Client.get("/api/v2/job_statuses/show_many.json?ids=#{Enum.join(ids, ",")}") |> response_to_job_statuses
  end

  @spec response_to_job_statuses(%HTTPotion.Response{}) :: list(%JobStatus{})
  def response_to_job_statuses(%HTTPotion.Response{} = res) do
    res.body |> Poison.decode!(keys: :atoms, as: %{job_statuses: [%JobStatus{}]}) |> Map.get(:job_statuses)
  end

  @spec response_to_job_status(%HTTPotion.Response{}) :: %JobStatus{}
  def response_to_job_status(%HTTPotion.Response{} = res) do
    res.body |> Poison.decode!(keys: :atoms, as: %{job_status: %JobStatus{}}) |> Map.get(:job_status)
  end
end
