defmodule ZenEx.Model.Ticket do
  alias ZenEx.Core.Client
  alias ZenEx.Model
  alias ZenEx.Entity.{Ticket,JobStatus}

  @moduledoc """
  Provides functions to operate Zendesk Ticket.
  """

  @doc """
  List tickets.

  ## Examples

      iex> ZenEx.Model.Ticket.list
      [%ZenEx.Entity.Ticket{id: xxx, requester_id: xxx, subject: "Ticket Subject", description: "Ticket desc", ...}, ...]

  """
  @spec list :: list(%Ticket{})
  def list do
    Client.get("/api/v2/tickets.json") |> _create_tickets
  end


  @doc """
  Show ticket specified by id.

  ## Examples

      iex> ZenEx.Model.Ticket.show(1)
      %ZenEx.Entity.Ticket{id: 1, requester_id: xxx, subject: "Ticket Subject", description: "Ticket desc", ...}

  """
  @spec show(integer) :: %Ticket{}
  def show(id) when is_integer(id) do
    Client.get("/api/v2/tickets/#{id}.json") |> _create_ticket
  end


  @doc """
  Create ticket.

  ## Examples

      iex> ZenEx.Model.Ticket.create(%ZenEx.Entity.Ticket{requester_id: xxx, subject: "Ticket Subject", description: "Ticket desc", ...})
      %ZenEx.Entity.Ticket{requester_id: xxx, ...}

  """
  @spec create(%Ticket{}) :: %Ticket{}
  def create(%Ticket{} = ticket) do
    Client.post("/api/v2/tickets.json", %{ticket: _desc_to_comment(ticket)}) |> _create_ticket
  end


  @doc """
  Update ticket specified by id.

  ## Examples

      iex> ZenEx.Model.Ticket.update(%ZenEx.Entity.Ticket{id: 1, requester_id: xxx, subject: "Ticket Subject", description: "Ticket desc", ...})
      %ZenEx.Entity.Ticket{id: 1, requester_id: xxx, ...}

  """
  @spec update(%Ticket{}) :: %Ticket{}
  def update(%Ticket{} = ticket) do
    Client.put("/api/v2/tickets/#{ticket.id}.json", %{ticket: _desc_to_comment(ticket)}) |> _create_ticket
  end


  @doc """
  Delete ticket specified by id.

  ## Examples

      iex> ZenEx.Model.Ticket.destroy(1)
      :ok

  """
  @spec destroy(integer) :: :ok | :error
  def destroy(id) when is_integer(id) do
    case Client.delete("/api/v2/tickets/#{id}.json").status_code do
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
  @spec create_many(list(%Ticket{})) :: %JobStatus{}
  def create_many(tickets) when is_list(tickets) do
    Client.post("/api/v2/tickets/create_many.json", %{tickets: _desc_to_comment(tickets)}) |> Model.JobStatus._create_job_status
  end


  @doc """
  Update multiple tickets specified by id.

  ## Examples

      iex> ZenEx.Model.Ticket.update_many([%ZenEx.Entity.Ticket{id: xxx, requester_id: xxx, subject: "Ticket Subject", description: "Ticket desc", ...}, ...])
      %ZenEx.Entity.JobStatus{id: "xxx"}

  """
  @spec update_many(list(%Ticket{})) :: %JobStatus{}
  def update_many(tickets) when is_list(tickets) do
    Client.put("/api/v2/tickets/update_many.json", %{tickets: _desc_to_comment(tickets)}) |> Model.JobStatus._create_job_status
  end


  @doc """
  Delete multiple tickets specified by id.

  ## Examples

      iex> ZenEx.Model.Ticket.destroy_many([xxx, ...])
      %ZenEx.Entity.JobStatus{id: "xxx"}

  """
  @spec destroy_many(list(integer)) :: %JobStatus{}
  def destroy_many(ids) when is_list(ids) do
    Client.delete("/api/v2/tickets/destroy_many.json?ids=#{Enum.join(ids, ",")}") |> Model.JobStatus._create_job_status
  end


  @doc false
  @spec _desc_to_comment(list(%Ticket{})) :: list(%Ticket{})
  def _desc_to_comment(tickets) when is_list(tickets), do: Enum.map(tickets, &_desc_to_comment(&1))

  @spec _desc_to_comment(%Ticket{}) :: %Ticket{}
  def _desc_to_comment(%Ticket{} = ticket), do: Map.merge(ticket, %{comment: %{body: ticket.description}})


  @doc false
  @spec _create_tickets(%HTTPotion.Response{}) :: list(%Ticket{})
  def _create_tickets(%HTTPotion.Response{} = res) do
    res.body |> Poison.decode!(keys: :atoms, as: %{tickets: [%Ticket{}]}) |> Map.get(:tickets)
  end


  @doc false
  @spec _create_ticket(%HTTPotion.Response{}) :: %Ticket{}
  def _create_ticket(%HTTPotion.Response{} = res) do
    res.body |> Poison.decode!(keys: :atoms, as: %{ticket: %Ticket{}}) |> Map.get(:ticket)
  end
end
