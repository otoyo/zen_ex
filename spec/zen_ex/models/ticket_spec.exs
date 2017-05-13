defmodule ZenEx.Model.TicketSpec do
  use ESpec

  alias ZenEx.Core.Client
  alias ZenEx.Entity.{Ticket,JobStatus}
  alias ZenEx.Model

  let :json_tickets do
    ~s({"tickets":[{"id":35436,"subject":"Help I need somebody!"},{"id":20057623,"subject":"Not just anybody!"}]})
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

  let :response_ticket, do: %HTTPotion.Response{body: json_ticket()}
  let :response_tickets, do: %HTTPotion.Response{body: json_tickets()}
  let :response_job_status, do: %HTTPotion.Response{body: json_job_status()}
  let :response_204, do: %HTTPotion.Response{status_code: 204}
  let :response_404, do: %HTTPotion.Response{status_code: 404}

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
    it do: expect Model.Ticket.create(ticket()) |> to(be_struct Ticket)
  end

  describe "update" do
    before do: allow Client |> to(accept :put, fn(_, _) -> response_ticket() end)
    it do: expect Model.Ticket.update(ticket()) |> to(be_struct Ticket)
  end

  describe "destroy" do
    context "response status_code: 204" do
      before do: allow Client |> to(accept :delete, fn(_) -> response_204() end)
      it do: expect Model.Ticket.destroy(ticket().id) |> to(eq :ok)
    end
    context "response status_code: 404" do
      before do: allow Client |> to(accept :delete, fn(_) -> response_404() end)
      it do: expect Model.Ticket.destroy(ticket().id) |> to(eq :error)
    end
  end

  describe "create_many" do
    before do: allow Client |> to(accept :post, fn(_, _) -> response_job_status() end)
    it do: expect Model.Ticket.create_many(tickets()) |> to(be_struct JobStatus)
  end

  describe "update_many" do
    before do: allow Client |> to(accept :put, fn(_, _) -> response_job_status() end)
    it do: expect Model.Ticket.update_many(tickets()) |> to(be_struct JobStatus)
  end

  describe "destroy_many" do
    before do: allow Client |> to(accept :delete, fn(_) -> response_job_status() end)
    it do: expect Model.Ticket.destroy_many(Enum.map(tickets(), &(&1.id))) |> to(be_struct JobStatus)
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

  describe "_create_tickets" do
    subject do: Model.Ticket._create_tickets response_tickets()
    it do: is_expected() |> to(eq tickets())
  end

  describe "_create_ticket" do
    subject do: Model.Ticket._create_ticket response_ticket()
    it do: is_expected() |> to(eq ticket())
  end
end