defmodule Zendex.Model.Ticket do
  alias Zendex.Core.Client
  alias Zendex.Entity.Ticket

  @spec list :: list(%Ticket{})
  def list do
    Client.get("/api/v2/tickets.json") |> response_to_tickets
  end

  @spec show(integer) :: %Ticket{}
  def show(id) when is_integer(id) do
    Client.get("/api/v2/tickets/#{id}.json") |> response_to_ticket
  end

  @spec create(%Ticket{}) :: %Ticket{}
  def create(%Ticket{} = ticket) do
    Client.post("/api/v2/tickets.json", %{ticket: desc_to_comment(ticket)}) |> response_to_ticket
  end

  @spec update(%Ticket{}) :: %Ticket{}
  def update(%Ticket{} = ticket) do
    Client.put("/api/v2/tickets/#{ticket.id}.json", %{ticket: desc_to_comment(ticket)}) |> response_to_ticket
  end

  @spec destroy(integer) :: %Ticket{}
  def destroy(id) when is_integer(id) do
    Client.delete("/api/v2/tickets/#{id}.json") |> response_to_ticket
  end

  @spec create_many(list(%Ticket{})) :: %HTTPotion.Response{}
  def create_many(tickets) when is_list(tickets) do
    Client.post "/api/v2/tickets/create_many.json", %{tickets: desc_to_comment(tickets)}
  end

  @spec update_many(list(%Ticket{})) :: %HTTPotion.Response{}
  def update_many(tickets) when is_list(tickets) do
    Client.put "/api/v2/tickets/update_many.json", %{tickets: desc_to_comment(tickets)}
  end

  @spec destroy_many(list(integer)) :: %HTTPotion.Response{}
  def destroy_many(ids) when is_list(ids) do
    Client.delete "/api/v2/tickets/destroy_many.json?ids=#{Enum.join(ids, ",")}"
  end

  @spec desc_to_comment(list(%Ticket{})) :: list(%Ticket{})
  def desc_to_comment(tickets) when is_list(tickets), do: Enum.map(tickets, &desc_to_comment(&1))

  @spec desc_to_comment(%Ticket{}) :: %Ticket{}
  def desc_to_comment(%Ticket{} = ticket), do: Map.merge(ticket, %{comment: %{body: ticket.description}})

  @spec response_to_tickets(%HTTPotion.Response{}) :: list(%Ticket{})
  def response_to_tickets(%HTTPotion.Response{} = res) do
    res.body |> Poison.decode!(keys: :atoms, as: %{tickets: [%Ticket{}]}) |> Map.get(:tickets)
  end

  @spec response_to_ticket(%HTTPotion.Response{}) :: %Ticket{}
  def response_to_ticket(%HTTPotion.Response{} = res) do
    res.body |> Poison.decode!(keys: :atoms, as: %{ticket: %Ticket{}}) |> Map.get(:ticket)
  end
end
