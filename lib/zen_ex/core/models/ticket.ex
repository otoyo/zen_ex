defmodule ZenEx.Model.Ticket do
  alias ZenEx.HTTPClient
  alias ZenEx.Query
  alias ZenEx.Entity.{Ticket, JobStatus}

  @moduledoc """
  Provides functions to operate Zendesk Ticket.
  """

  @doc """
  List tickets.

  ## Examples

      iex> ZenEx.Model.Ticket.list
      %ZenEx.Collection{}

  """
  @spec list :: %ZenEx.Collection{} | {:error, String.t()}
  def list(opts \\ []) when is_list(opts) do
    "/api/v2/tickets.json#{Query.build(opts)}"
    |> HTTPClient.get(tickets: [Ticket])
  end


  @doc """
  Show ticket specified by id.

  ## Examples

      iex> ZenEx.Model.Ticket.show(1)
      %ZenEx.Entity.Ticket{id: 1, requester_id: xxx, subject: "Ticket Subject", description: "Ticket desc", ...}

  """
  @spec show(integer) :: %Ticket{} | {:error, String.t()}
  def show(id) when is_integer(id) do
    HTTPClient.get("/api/v2/tickets/#{id}.json", ticket: Ticket)
  end


  @doc """
  Create ticket.

  ## Examples

      iex> ZenEx.Model.Ticket.create(%ZenEx.Entity.Ticket{requester_id: xxx, subject: "Ticket Subject", description: "Ticket desc", ...})
      %ZenEx.Entity.Ticket{requester_id: xxx, ...}

  """
  @spec create(%Ticket{}) :: %Ticket{} | {:error, String.t()}
  def create(%Ticket{} = ticket) do
    HTTPClient.post("/api/v2/tickets.json", %{ticket: _desc_to_comment(ticket)}, ticket: Ticket)
  end


  @doc """
  Update ticket specified by id.

  ## Examples

      iex> ZenEx.Model.Ticket.update(%ZenEx.Entity.Ticket{id: 1, requester_id: xxx, subject: "Ticket Subject", description: "Ticket desc", ...})
      %ZenEx.Entity.Ticket{id: 1, requester_id: xxx, ...}

  """
  @spec update(%Ticket{}) :: %Ticket{} | {:error, String.t()}
  def update(%Ticket{} = ticket) do
    HTTPClient.put("/api/v2/tickets/#{ticket.id}.json", %{ticket: _desc_to_comment(ticket)}, ticket: Ticket)
  end


  @doc """
  Delete ticket specified by id.

  ## Examples

      iex> ZenEx.Model.Ticket.destroy(1)
      :ok

  """
  @spec destroy(integer) :: :ok | :error
  def destroy(id) when is_integer(id) do
    case HTTPClient.delete("/api/v2/tickets/#{id}.json").status_code do
      204 -> :ok
      _   -> :error
    end
  end


  @doc """
  Create multiple tickets.

  ## Examples

      iex> ZenEx.Model.Ticket.create_many([%ZenEx.Entity.Ticket{requester_id: xxx, subject: "Ticket Subject", description: "Ticket desc", ...}, ...])
      %ZenEx.Entity.JobStatus{id: "xxx"}

  """
  @spec create_many(list(%Ticket{})) :: %JobStatus{} | {:error, String.t()}
  def create_many(tickets) when is_list(tickets) do
    HTTPClient.post("/api/v2/tickets/create_many.json", %{tickets: _desc_to_comment(tickets)}, job_status: JobStatus)
  end


  @doc """
  Update multiple tickets specified by id.

  ## Examples

      iex> ZenEx.Model.Ticket.update_many([%ZenEx.Entity.Ticket{id: xxx, requester_id: xxx, subject: "Ticket Subject", description: "Ticket desc", ...}, ...])
      %ZenEx.Entity.JobStatus{id: "xxx"}

  """
  @spec update_many(list(%Ticket{})) :: %JobStatus{} | {:error, String.t()}
  def update_many(tickets) when is_list(tickets) do
    HTTPClient.put("/api/v2/tickets/update_many.json", %{tickets: _desc_to_comment(tickets)}, job_status: JobStatus)
  end


  @doc """
  Delete multiple tickets specified by id.

  ## Examples

      iex> ZenEx.Model.Ticket.destroy_many([xxx, ...])
      %ZenEx.Entity.JobStatus{id: "xxx"}

  """
  @spec destroy_many(list(integer)) :: %JobStatus{} | {:error, String.t()}
  def destroy_many(ids) when is_list(ids) do
    HTTPClient.delete("/api/v2/tickets/destroy_many.json?ids=#{Enum.join(ids, ",")}", job_status: JobStatus)
  end


  @doc false
  @spec _desc_to_comment(list(%Ticket{})) :: list(%Ticket{})
  def _desc_to_comment(tickets) when is_list(tickets), do: Enum.map(tickets, &_desc_to_comment(&1))

  @spec _desc_to_comment(%Ticket{}) :: %Ticket{}
  def _desc_to_comment(%Ticket{} = ticket), do: Map.merge(ticket, %{comment: %{body: ticket.description}})
end
