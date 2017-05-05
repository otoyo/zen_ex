defmodule ZenEx.Model.JobStatus do
  alias ZenEx.Core.Client
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
    Client.get("/api/v2/job_statuses.json") |> __create_job_statuses__
  end


  @doc """
  Show job_status specified by id.

  ## Examples

      iex> ZenEx.Model.JobStatus.show("xxx")
      %ZenEx.Entity.JobStatus{id: "xxx", ...}

  """
  @spec show(binary) :: %JobStatus{}
  def show(id) when is_binary(id) do
    Client.get("/api/v2/job_statuses/#{id}.json") |> __create_job_status__
  end


  @doc """
  Show multiple job_statuses specified by ids.

  ## Examples

      iex> ZenEx.Model.JobStatus.show_many(["xxx", ...])
      [%ZenEx.Entity.JobStatus{id: "xxx", ...}, ...]

  """
  @spec show_many(list(binary)) :: list(%JobStatus{})
  def show_many(ids) when is_list(ids) do
    Client.get("/api/v2/job_statuses/show_many.json?ids=#{Enum.join(ids, ",")}") |> __create_job_statuses__
  end


  @doc false
  @spec __create_job_statuses__(%HTTPotion.Response{}) :: list(%JobStatus{})
  def __create_job_statuses__(%HTTPotion.Response{} = res) do
    res.body |> Poison.decode!(keys: :atoms, as: %{job_statuses: [%JobStatus{}]}) |> Map.get(:job_statuses)
  end


  @doc false
  @spec __create_job_status__(%HTTPotion.Response{}) :: %JobStatus{}
  def __create_job_status__(%HTTPotion.Response{} = res) do
    res.body |> Poison.decode!(keys: :atoms, as: %{job_status: %JobStatus{}}) |> Map.get(:job_status)
  end
end
