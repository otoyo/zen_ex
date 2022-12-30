defmodule ZenEx.Model.TicketSpec do
  use ESpec

  import Tesla.Mock
  alias ZenEx.Entity.{Ticket, JobStatus}
  alias ZenEx.Model

  let :json_tickets do
    ~s({"count":2,"tickets":[{"id":35436,"subject":"Help I need somebody!"},{"id":20057623,"subject":"Not just anybody!"}]})
  end

  let :tickets do
    [
      struct(Ticket, %{id: 35436, subject: "Help I need somebody!"}),
      struct(Ticket, %{id: 20_057_623, subject: "Not just anybody!"})
    ]
  end

  let(:json_ticket, do: ~s({"ticket":{"id":35436,"subject":"My printer is on fire!"}}))
  let(:ticket, do: struct(Ticket, %{id: 35436, subject: "My printer is on fire!"}))

  let :json_job_status do
    ~s({"job_status":{"id":"8b726e606741012ffc2d782bcb7848fe","status":"completed"}})
  end

  let :job_status do
    struct(JobStatus, %{id: "8b726e606741012ffc2d782bcb7848fe", status: "completed"})
  end

  let :json_search_tickets do
    ~s({"count":2,"results":[{"id":35436,"subject":"Help I need somebody!"},{"id":20057623,"subject":"Not just anybody!"}]})
  end

  let(:json_error, do: ~s({"error":"RecordNotFound","description":"Not found"}))

  describe "list" do
    before(
      do:
        mock(fn %{method: :get, url: _} ->
          {:ok, %Tesla.Env{status: 200, body: json_tickets()}}
        end)
    )

    it(do: expect({:ok, %ZenEx.Collection{}} = Model.Ticket.list()))
  end

  describe "show" do
    context "response status: 200" do
      before(
        do:
          mock(fn %{method: :get, url: _} ->
            {:ok, %Tesla.Env{status: 200, body: json_ticket()}}
          end)
      )

      it(do: expect({:ok, %Ticket{}} = Model.Ticket.show(ticket().id)))
    end

    context "response status: 404" do
      before(
        do:
          mock(fn %{method: :get, url: _} ->
            {:error, %Tesla.Env{status: 404, body: json_error()}}
          end)
      )

      it(do: expect({:error, _} = Model.Ticket.show(ticket().id)))
    end
  end

  describe "create" do
    context "response status: 201" do
      before(
        do:
          mock(fn %{method: :post, url: _} ->
            {:ok, %Tesla.Env{status: 201, body: json_ticket()}}
          end)
      )

      it(do: expect({:ok, %Ticket{}} = Model.Ticket.create(ticket())))
    end

    context "response status: 500" do
      before(
        do:
          mock(fn %{method: :post, url: _} ->
            {:error, %Tesla.Env{status: 500, body: ""}}
          end)
      )

      it(do: expect({:error, _} = Model.Ticket.create(ticket())))
    end
  end

  describe "update" do
    context "response status: 200" do
      before(
        do:
          mock(fn %{method: :put, url: _} ->
            {:ok, %Tesla.Env{status: 200, body: json_ticket()}}
          end)
      )

      it(do: expect({:ok, %Ticket{}} = Model.Ticket.update(ticket())))
    end

    context "response status: 500" do
      before(
        do:
          mock(fn %{method: :put, url: _} ->
            {:error, %Tesla.Env{status: 500, body: ""}}
          end)
      )

      it(do: expect({:error, _} = Model.Ticket.update(ticket())))
    end
  end

  describe "destroy" do
    context "response status: 204" do
      before(do: mock(fn %{method: :delete, url: _} -> {:ok, %Tesla.Env{status: 204}} end))

      it(do: expect(:ok = Model.Ticket.destroy(ticket().id)))
    end

    context "response status: 404" do
      before(do: mock(fn %{method: :delete, url: _} -> {:error, %Tesla.Env{status: 404}} end))

      it(do: expect({:error, _} = Model.Ticket.destroy(ticket().id)))
    end
  end

  describe "create_many" do
    context "response status: 200" do
      before(
        do:
          mock(fn %{method: :post, url: _} ->
            {:ok, %Tesla.Env{status: 200, body: json_job_status()}}
          end)
      )

      it(do: expect({:ok, %JobStatus{}} = Model.Ticket.create_many(tickets())))
    end

    context "response status: 500" do
      before(
        do:
          mock(fn %{method: :post, url: _} ->
            {:error, %Tesla.Env{status: 500, body: ""}}
          end)
      )

      it(do: expect({:error, _} = Model.Ticket.create_many(tickets())))
    end
  end

  describe "update_many" do
    context "response status: 200" do
      before(
        do:
          mock(fn %{method: :put, url: _} ->
            {:ok, %Tesla.Env{status: 200, body: json_job_status()}}
          end)
      )

      it(do: expect({:ok, %JobStatus{}} = Model.Ticket.update_many(tickets())))
    end

    context "response status: 500" do
      before(
        do:
          mock(fn %{method: :put, url: _} ->
            {:error, %Tesla.Env{status: 500, body: ""}}
          end)
      )

      it(do: expect({:error, _} = Model.Ticket.update_many(tickets())))
    end
  end

  describe "destroy_many" do
    context "response status: 200" do
      before(
        do:
          mock(fn %{method: :delete, url: _} ->
            {:ok, %Tesla.Env{status: 200, body: json_job_status()}}
          end)
      )

      it(
        do: expect({:ok, %JobStatus{}} = Model.Ticket.destroy_many(Enum.map(tickets(), & &1.id)))
      )
    end

    context "response status: 500" do
      before(
        do:
          mock(fn %{method: :delete, url: _} ->
            {:error, %Tesla.Env{status: 500, body: ""}}
          end)
      )

      it(do: expect({:error, _} = Model.Ticket.destroy_many(Enum.map(tickets(), & &1.id))))
    end
  end

  describe "search" do
    context "response status: 200" do
      before(
        do:
          mock(fn %{method: :get, url: _} ->
            {:ok, %Tesla.Env{status: 200, body: json_search_tickets()}}
          end)
      )

      context "when argument is a map" do
        it(do: expect({:ok, %ZenEx.Collection{}} = Model.Ticket.search(%{status: "open"})))
      end

      context "when argument is a string" do
        it(do: expect({:ok, %ZenEx.Collection{}} = Model.Ticket.search(%{status: "open"})))
      end
    end

    context "response status: 500" do
      before(
        do:
          mock(fn %{method: :get, url: _} ->
            {:error, %Tesla.Env{status: 500, body: ""}}
          end)
      )

      it(do: expect({:error, _} = Model.Ticket.search(%{status: "open"})))
    end
  end

  describe "_desc_to_comment" do
    context "arg is list of tickets" do
      subject(do: Model.Ticket._desc_to_comment(tickets()))

      it(
        do:
          is_expected()
          |> to(eq(Enum.map(tickets(), &Map.merge(&1, %{comment: %{body: &1.description}}))))
      )
    end

    context "arg is a ticket" do
      subject(do: Model.Ticket._desc_to_comment(ticket()))

      it(
        do:
          is_expected() |> to(eq(Map.merge(ticket(), %{comment: %{body: ticket().description}})))
      )
    end
  end
end
