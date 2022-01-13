defmodule ZenEx.Model.TicketSpec do
  use ESpec

  import Tesla.Mock
alias ZenEx.Entity.{Ticket,JobStatus}
  alias ZenEx.Model

  let :json_tickets do
    ~s({"count":2,"tickets":[{"id":35436,"subject":"Help I need somebody!"},{"id":20057623,"subject":"Not just anybody!"}]})
  end
  let :tickets do
    [struct(Ticket, %{id: 35436, subject: "Help I need somebody!"}),
     struct(Ticket, %{id: 20057623, subject: "Not just anybody!"})]
  end

  let :json_ticket, do: ~s({"ticket":{"id":35436,"subject":"My printer is on fire!"}})
  let :ticket, do: struct(Ticket, %{id: 35436, subject: "My printer is on fire!"})

  let :json_job_status do
    ~s({"job_status":{"id":"8b726e606741012ffc2d782bcb7848fe","status":"completed"}})
  end
  let :job_status do
    struct(JobStatus, %{id: "8b726e606741012ffc2d782bcb7848fe", status: "completed"})
  end

  let :json_search_tickets do
    ~s({"count":2,"results":[{"id":35436,"subject":"Help I need somebody!"},{"id":20057623,"subject":"Not just anybody!"}]})
  end

  let :response_ticket, do: %Tesla.Env{body: json_ticket()}
  let :response_tickets, do: %Tesla.Env{body: json_tickets()}
  let :response_search_tickets, do: %Tesla.Env{body: json_search_tickets()}
  let :response_job_status, do: %Tesla.Env{body: json_job_status()}
  let :response_204, do: %Tesla.Env{status: 204}
  let :response_404, do: %Tesla.Env{status: 404}

  describe "list" do
    before do: mock(fn %{method: :get, url: _} -> %Tesla.Env{status: 200, body: response_tickets()} end)
    it do: expect Model.Ticket.list |> to(be_struct ZenEx.Collection)
    it do: expect Model.Ticket.list.entities |> to(eq tickets())
  end

  describe "show" do
    before do: mock(fn %{method: :get, url: _} -> %Tesla.Env{status: 200, body: response_ticket()} end)
    it do: expect Model.Ticket.show(ticket().id) |> to(eq ticket())
  end

  describe "create" do
    before do: mock(fn %{method: :post, url: _} -> %Tesla.Env{status: 200, body: response_ticket()} end)
    it do: expect Model.Ticket.create(ticket()) |> to(be_struct Ticket)
  end

  describe "update" do
    before do: mock(fn %{method: :put, url: _} -> %Tesla.Env{status: 200, body: response_ticket()} end)
    it do: expect Model.Ticket.update(ticket()) |> to(be_struct Ticket)
  end

  describe "destroy" do
    context "response status: 204" do
      before do: mock(fn %{method: :delete, url: _} -> %Tesla.Env{status: 200, body: response_204()} end)
      it do: expect Model.Ticket.destroy(ticket().id) |> to(eq :ok)
    end
    context "response status: 404" do
      before do: mock(fn %{method: :delete, url: _} -> %Tesla.Env{status: 200, body: response_404()} end)
      it do: expect Model.Ticket.destroy(ticket().id) |> to(eq :error)
    end
  end

  describe "create_many" do
    before do: mock(fn %{method: :post, url: _} -> %Tesla.Env{status: 200, body: response_job_status()} end)
    it do: expect Model.Ticket.create_many(tickets()) |> to(be_struct JobStatus)
  end

  describe "update_many" do
    before do: mock(fn %{method: :put, url: _} -> %Tesla.Env{status: 200, body: response_job_status()} end)
    it do: expect Model.Ticket.update_many(tickets()) |> to(be_struct JobStatus)
  end

  describe "destroy_many" do
    before do: mock(fn %{method: :delete, url: _} -> %Tesla.Env{status: 200, body: response_job_status()} end)
    it do: expect Model.Ticket.destroy_many(Enum.map(tickets(), &(&1.id))) |> to(be_struct JobStatus)
  end

  describe "search" do
    before do: mock(fn %{method: :get, url: _} -> %Tesla.Env{status: 200, body: response_search_tickets()} end)

    context "when argument is a map" do
      it do: expect Model.Ticket.search(%{status: "open"}) |> to(be_struct ZenEx.Collection)
      it do: expect Model.Ticket.search(%{status: "open"}).entities |> to(eq tickets())
    end

    context "when argument is a string" do
      it do: expect Model.Ticket.search("my_string") |> to(be_struct ZenEx.Collection)
      it do: expect Model.Ticket.search("my_string").entities |> to(eq tickets())
    end
  end

  describe "_desc_to_comment" do
    context "arg is list of tickets" do
      subject do: Model.Ticket._desc_to_comment tickets()
      it do: is_expected() |> to(eq Enum.map(tickets(), &(Map.merge(&1, %{comment: %{body: &1.description}}))))
    end
    context "arg is a ticket" do
      subject do: Model.Ticket._desc_to_comment ticket()
      it do: is_expected() |> to(eq Map.merge(ticket(), %{comment: %{body: ticket().description}}))
    end
  end
end
