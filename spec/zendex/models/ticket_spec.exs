defmodule Zendex.Model.TicketSpec do
  use ESpec

  alias Zendex.Core.Client
  alias Zendex.Entity.Ticket
  alias Zendex.Model

  let :json_tickets do
    ~s({"tickets":[{"id":35436,"subject":"Help I need somebody!"},{"id":20057623,"subject":"Not just anybody!"}]})
  end
  let :tickets do
    [struct(Ticket, %{id: 35436, subject: "Help I need somebody!"}),
     struct(Ticket, %{id: 20057623, subject: "Not just anybody!"})]
  end

  let :json_ticket, do: ~s({"ticket":{"id":35436,"subject":"My printer is on fire!"}})
  let :ticket, do: struct(Ticket, %{id: 35436, subject: "My printer is on fire!"})

  let :response_ticket, do: %HTTPotion.Response{body: json_ticket()}
  let :response_tickets, do: %HTTPotion.Response{body: json_tickets()}

  describe "list" do
    before do: allow Client |> to(accept :get, fn(_) -> response_tickets() end)
    it do: expect Model.Ticket.list |> to(eq tickets())
  end

  describe "show" do
    before do: allow Client |> to(accept :get, fn(_) -> response_ticket() end)
    it do: expect Model.Ticket.show(ticket().id) |> to(eq ticket())
  end

  describe "create" do
    before do: allow Client |> to(accept :post, fn(_, _) -> response_ticket() end)

    it "calls Client.post" do
      Model.Ticket.create(ticket())
      expect Client |> to(accepted :post)
    end
  end

  describe "update" do
    before do: allow Client |> to(accept :put, fn(_, _) -> response_ticket() end)

    it "calls Client.put" do
      Model.Ticket.update(ticket())
      expect Client |> to(accepted :put)
    end
  end

  describe "destroy" do
    before do: allow Client |> to(accept :delete, fn(_) -> response_ticket() end)

    it "calls Client.delete" do
      Model.Ticket.destroy(ticket().id)
      expect Client |> to(accepted :delete)
    end
  end

  describe "create_many" do
    before do: allow Client |> to(accept :post, fn(_, _) -> nil end)

    it "calls Client.post" do
      Model.Ticket.create_many(tickets())
      expect Client |> to(accepted :post)
    end
  end

  describe "update_many" do
    before do: allow Client |> to(accept :put, fn(_, _) -> nil end)

    it "calls Client.put" do
      Model.Ticket.update_many(tickets())
      expect Client |> to(accepted :put)
    end
  end

  describe "destroy_many" do
    before do: allow Client |> to(accept :delete)

    it "calls Client.delete" do
      Model.Ticket.destroy_many(Enum.map(tickets(), &(&1.id)))
      expect Client |> to(accepted :delete)
    end
  end

  describe "desc_to_comment" do
    context "arg is list of tickets" do
      subject do: Model.Ticket.desc_to_comment tickets()
      it do: is_expected() |> to(eq Enum.map(tickets(), &(Map.merge(&1, %{comment: %{body: &1.description}}))))
    end
    context "arg is a ticket" do
      subject do: Model.Ticket.desc_to_comment ticket()
      it do: is_expected() |> to(eq Map.merge(ticket(), %{comment: %{body: ticket().description}}))
    end
  end

  describe "response_to_tickets" do
    subject do: Model.Ticket.response_to_tickets response_tickets()
    it do: is_expected() |> to(eq tickets())
  end

  describe "response_to_ticket" do
    subject do: Model.Ticket.response_to_ticket response_ticket()
    it do: is_expected() |> to(eq ticket())
  end
end
