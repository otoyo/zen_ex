defmodule Zendex.Model.Ticket do
  alias Zendex.Core.Client
  alias Zendex.Model
  alias Zendex.Entity.{Ticket,JobStatus}

  @spec list :: list(%Ticket{})
  def list do
    Client.get("/api/v2/tickets.json") |> __create_tickets__
  end

  @spec show(integer) :: %Ticket{}
  def show(id) when is_integer(id) do
    Client.get("/api/v2/tickets/#{id}.json") |> __create_ticket__
  end

  @spec create(%Ticket{}) :: %Ticket{}
  def create(%Ticket{} = ticket) do
    Client.post("/api/v2/tickets.json", %{ticket: __desc_to_comment__(ticket)}) |> __create_ticket__
  end

  @spec update(%Ticket{}) :: %Ticket{}
  def update(%Ticket{} = ticket) do
    Client.put("/api/v2/tickets/#{ticket.id}.json", %{ticket: __desc_to_comment__(ticket)}) |> __create_ticket__
  end

  @spec destroy(integer) :: %Ticket{}
  def destroy(id) when is_integer(id) do
    Client.delete("/api/v2/tickets/#{id}.json") |> __create_ticket__
  end

  @spec create_many(list(%Ticket{})) :: %JobStatus{}
  def create_many(tickets) when is_list(tickets) do
    Client.post("/api/v2/tickets/create_many.json", %{tickets: __desc_to_comment__(tickets)}) |> Model.JobStatus.__create_job_status__
  end

  @spec update_many(list(%Ticket{})) :: %JobStatus{}
  def update_many(tickets) when is_list(tickets) do
    Client.put("/api/v2/tickets/update_many.json", %{tickets: __desc_to_comment__(tickets)}) |> Model.JobStatus.__create_job_status__
  end

  @spec destroy_many(list(integer)) :: %JobStatus{}
  def destroy_many(ids) when is_list(ids) do
    Client.delete("/api/v2/tickets/destroy_many.json?ids=#{Enum.join(ids, ",")}") |> Model.JobStatus.__create_job_status__
  end

  @spec __desc_to_comment__(list(%Ticket{})) :: list(%Ticket{})
  def __desc_to_comment__(tickets) when is_list(tickets), do: Enum.map(tickets, &__desc_to_comment__(&1))

  @spec __desc_to_comment__(%Ticket{}) :: %Ticket{}
  def __desc_to_comment__(%Ticket{} = ticket), do: Map.merge(ticket, %{comment: %{body: ticket.description}})

  @spec __create_tickets__(%HTTPotion.Response{}) :: list(%Ticket{})
  def __create_tickets__(%HTTPotion.Response{} = res) do
    res.body |> Poison.decode!(keys: :atoms, as: %{tickets: [%Ticket{}]}) |> Map.get(:tickets)
  end

  @spec __create_ticket__(%HTTPotion.Response{}) :: %Ticket{}
  def __create_ticket__(%HTTPotion.Response{} = res) do
    res.body |> Poison.decode!(keys: :atoms, as: %{ticket: %Ticket{}}) |> Map.get(:ticket)
  end
end
