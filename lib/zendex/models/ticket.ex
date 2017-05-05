defmodule Zendex.Model.Ticket do
  alias Zendex.Core.Client
  alias Zendex.Model
  alias Zendex.Entity.{Ticket,JobStatus}

  @moduledoc """
  Provides functions to operate Zendesk Ticket.
  """

  @doc """
  List tickets.

  ## Examples

      iex> Zendex.Model.Ticket.list
      [%Zendex.Entity.Ticket{id: xxx, requester_id: xxx, subject: "Ticket Subject", description: "Ticket desc", ...}, ...]

  """
  @spec list :: list(%Ticket{})
  def list do
    Client.get("/api/v2/tickets.json") |> __create_tickets__
  end


  @doc """
  Show ticket specified by id.

  ## Examples

      iex> Zendex.Model.Ticket.show(1)
      %Zendex.Entity.Ticket{id: 1, requester_id: xxx, subject: "Ticket Subject", description: "Ticket desc", ...}

  """
  @spec show(integer) :: %Ticket{}
  def show(id) when is_integer(id) do
    Client.get("/api/v2/tickets/#{id}.json") |> __create_ticket__
  end


  @doc """
  Create ticket.

  ## Examples

      iex> Zendex.Model.Ticket.create(%Zendex.Entity.Ticket{requester_id: xxx, subject: "Ticket Subject", description: "Ticket desc", ...})
      %Zendex.Entity.Ticket{requester_id: xxx, ...}

  """
  @spec create(%Ticket{}) :: %Ticket{}
  def create(%Ticket{} = ticket) do
    Client.post("/api/v2/tickets.json", %{ticket: __desc_to_comment__(ticket)}) |> __create_ticket__
  end


  @doc """
  Update ticket specified by id.

  ## Examples

      iex> Zendex.Model.Ticket.update(%Zendex.Entity.Ticket{id: 1, requester_id: xxx, subject: "Ticket Subject", description: "Ticket desc", ...})
      %Zendex.Entity.Ticket{id: 1, requester_id: xxx, ...}

  """
  @spec update(%Ticket{}) :: %Ticket{}
  def update(%Ticket{} = ticket) do
    Client.put("/api/v2/tickets/#{ticket.id}.json", %{ticket: __desc_to_comment__(ticket)}) |> __create_ticket__
  end


  @doc """
  Delete ticket specified by id.

  ## Examples

      iex> Zendex.Model.Ticket.destroy(1)
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

      iex> Zendex.Model.Ticket.create_many([%Zendex.Entity.Ticket{requester_id: xxx, subject: "Ticket Subject", description: "Ticket desc", ...}, ...])
      %Zendex.Entity.JobStatus{id: "xxx"}

  """
  @spec create_many(list(%Ticket{})) :: %JobStatus{}
  def create_many(tickets) when is_list(tickets) do
    Client.post("/api/v2/tickets/create_many.json", %{tickets: __desc_to_comment__(tickets)}) |> Model.JobStatus.__create_job_status__
  end


  @doc """
  Update multiple tickets specified by id.

  ## Examples

      iex> Zendex.Model.Ticket.update_many([%Zendex.Entity.Ticket{id: xxx, requester_id: xxx, subject: "Ticket Subject", description: "Ticket desc", ...}, ...])
      %Zendex.Entity.JobStatus{id: "xxx"}

  """
  @spec update_many(list(%Ticket{})) :: %JobStatus{}
  def update_many(tickets) when is_list(tickets) do
    Client.put("/api/v2/tickets/update_many.json", %{tickets: __desc_to_comment__(tickets)}) |> Model.JobStatus.__create_job_status__
  end


  @doc """
  Delete multiple tickets specified by id.

  ## Examples

      iex> Zendex.Model.Ticket.destroy_many([xxx, ...])
      %Zendex.Entity.JobStatus{id: "xxx"}

  """
  @spec destroy_many(list(integer)) :: %JobStatus{}
  def destroy_many(ids) when is_list(ids) do
    Client.delete("/api/v2/tickets/destroy_many.json?ids=#{Enum.join(ids, ",")}") |> Model.JobStatus.__create_job_status__
  end


  @doc false
  @spec __desc_to_comment__(list(%Ticket{})) :: list(%Ticket{})
  def __desc_to_comment__(tickets) when is_list(tickets), do: Enum.map(tickets, &__desc_to_comment__(&1))

  @spec __desc_to_comment__(%Ticket{}) :: %Ticket{}
  def __desc_to_comment__(%Ticket{} = ticket), do: Map.merge(ticket, %{comment: %{body: ticket.description}})


  @doc false
  @spec __create_tickets__(%HTTPotion.Response{}) :: list(%Ticket{})
  def __create_tickets__(%HTTPotion.Response{} = res) do
    res.body |> Poison.decode!(keys: :atoms, as: %{tickets: [%Ticket{}]}) |> Map.get(:tickets)
  end


  @doc false
  @spec __create_ticket__(%HTTPotion.Response{}) :: %Ticket{}
  def __create_ticket__(%HTTPotion.Response{} = res) do
    res.body |> Poison.decode!(keys: :atoms, as: %{ticket: %Ticket{}}) |> Map.get(:ticket)
  end
end
