defmodule ZenEx.Model.UserSpec do
  use ESpec

  import Tesla.Mock
  alias ZenEx.Entity.{User, JobStatus}
  alias ZenEx.Model

  let :json_users do
    ~s({"count":2,"users":[{"id":223443,"name":"Johnny Agent"},{"id":8678530,"name":"James A. Rosen"}]})
  end

  let :users do
    [
      struct(User, %{id: 223_443, name: "Johnny Agent"}),
      struct(User, %{id: 8_678_530, name: "James A. Rosen"})
    ]
  end

  let(:json_user, do: ~s({"user":{"id":223443,"name":"Johnny Agent"}}))
  let(:json_deleted_user, do: ~s({"deleted_user":{"id":223443,"name":"Johnny Agent"}}))
  let(:user, do: struct(User, %{id: 223_443, name: "Johnny Agent"}))

  let :json_job_status do
    ~s({"job_status":{"id":"8b726e606741012ffc2d782bcb7848fe","status":"completed"}})
  end

  let :job_status do
    struct(JobStatus, %{id: "8b726e606741012ffc2d782bcb7848fe", status: "completed"})
  end

  let :json_search_users do
    ~s({"count":2,"users":[{"id":223443,"name":"Johnny Agent"},{"id":8678530,"name":"James A. Rosen"}]})
  end

  let :json_search_external_id_users do
    ~s({"count":1,"users":[{"id":223443,"name":"Johnny Agent","external_id":1234567}]})
  end

  let(:json_error, do: ~s({"error":"RecordNotFound","description":"Not found"}))

  describe "list" do
    before(
      do:
        mock(fn %{method: :get, url: _} -> {:ok, %Tesla.Env{status: 200, body: json_users()}} end)
    )

    it(do: expect({:ok, %ZenEx.Collection{}} = Model.User.list()))
  end

  describe "show" do
    context "response status: 200" do
      before(
        do:
          mock(fn %{method: :get, url: _} -> {:ok, %Tesla.Env{status: 200, body: json_user()}} end)
      )

      it(do: expect({:ok, %User{}} = Model.User.show(user().id)))
    end

    context "response status: 404" do
      before(
        do:
          mock(fn %{method: :get, url: _} ->
            {:error, %Tesla.Env{status: 404, body: json_error()}}
          end)
      )

      it(do: expect({:error, _} = Model.User.show(user().id)))
    end
  end

  describe "create" do
    context "response status: 201" do
      before(
        do:
          mock(fn %{method: :post, url: _} ->
            {:ok, %Tesla.Env{status: 201, body: json_user()}}
          end)
      )

      it(do: expect({:ok, %User{}} = Model.User.create(user())))
    end

    context "response status: 500" do
      before(
        do:
          mock(fn %{method: :post, url: _} ->
            {:error, %Tesla.Env{status: 500, body: ""}}
          end)
      )

      it(do: expect({:error, _} = Model.User.create(user())))
    end
  end

  describe "update" do
    context "response status: 200" do
      before(
        do:
          mock(fn %{method: :put, url: _} -> {:ok, %Tesla.Env{status: 200, body: json_user()}} end)
      )

      it(do: expect({:ok, %User{}} = Model.User.update(user())))
    end

    context "response status: 500" do
      before(
        do: mock(fn %{method: :put, url: _} -> {:error, %Tesla.Env{status: 500, body: ""}} end)
      )

      it(do: expect({:error, _} = Model.User.update(user())))
    end
  end

  describe "create_or_update" do
    context "response status: 200" do
      before(
        do:
          mock(fn %{method: :post, url: _} ->
            {:ok, %Tesla.Env{status: 200, body: json_user()}}
          end)
      )

      it(do: expect({:ok, %User{}} = Model.User.create_or_update(user())))
    end

    context "response status: 201" do
      before(
        do:
          mock(fn %{method: :post, url: _} ->
            {:ok, %Tesla.Env{status: 201, body: json_user()}}
          end)
      )

      it(do: expect({:ok, %User{}} = Model.User.create_or_update(user())))
    end

    context "response status: 500" do
      before(
        do:
          mock(fn %{method: :post, url: _} ->
            {:error, %Tesla.Env{status: 500, body: ""}}
          end)
      )

      it(do: expect({:error, _} = Model.User.create_or_update(user())))
    end
  end

  describe "destroy" do
    context "response status: 200" do
      before(
        do:
          mock(fn %{method: :delete, url: _} ->
            {:ok, %Tesla.Env{status: 200, body: json_user()}}
          end)
      )

      it(do: expect({:ok, %User{}} = Model.User.destroy(user().id)))
    end

    context "response status: 404" do
      before(
        do:
          mock(fn %{method: :delete, url: _} ->
            {:error, %Tesla.Env{status: 404, body: json_error()}}
          end)
      )

      it(do: expect({:error, _} = Model.User.destroy(user().id)))
    end
  end

  describe "permanently_destroy" do
    context "response status: 200" do
      before(
        do:
          mock(fn %{method: :delete, url: _} ->
            {:ok, %Tesla.Env{status: 200, body: json_deleted_user()}}
          end)
      )

      it(do: expect({:ok, %User{}} = Model.User.permanently_destroy(user().id)))
    end

    context "response status: 404" do
      before(
        do:
          mock(fn %{method: :delete, url: _} ->
            {:error, %Tesla.Env{status: 404, body: json_error()}}
          end)
      )

      it(do: expect({:error, _} = Model.User.permanently_destroy(user().id)))
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

      it(do: expect({:ok, %JobStatus{}} = Model.User.create_many(users())))
    end

    context "response status: 500" do
      before(
        do:
          mock(fn %{method: :post, url: _} ->
            {:error, %Tesla.Env{status: 500, body: ""}}
          end)
      )

      it(do: expect({:error, _} = Model.User.create_many(users())))
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

      it(do: expect({:ok, %JobStatus{}} = Model.User.update_many(users())))
    end

    context "response status: 500" do
      before(
        do:
          mock(fn %{method: :put, url: _} ->
            {:error, %Tesla.Env{status: 500, body: ""}}
          end)
      )

      it(do: expect({:error, _} = Model.User.update_many(users())))
    end
  end

  describe "create_or_update_many" do
    context "response status: 200" do
      before(
        do:
          mock(fn %{method: :post, url: _} ->
            {:ok, %Tesla.Env{status: 200, body: json_job_status()}}
          end)
      )

      it(do: expect({:ok, %JobStatus{}} = Model.User.create_or_update_many(users())))
    end

    context "response status: 500" do
      before(
        do:
          mock(fn %{method: :post, url: _} ->
            {:error, %Tesla.Env{status: 500, body: ""}}
          end)
      )

      it(do: expect({:error, _} = Model.User.create_or_update_many(users())))
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

      it(do: expect({:ok, %JobStatus{}} = Model.User.destroy_many(Enum.map(users(), & &1.id))))
    end

    context "response status: 500" do
      before(
        do:
          mock(fn %{method: :delete, url: _} ->
            {:error, %Tesla.Env{status: 500, body: ""}}
          end)
      )

      it(do: expect({:error, _} = Model.User.destroy_many(Enum.map(users(), & &1.id))))
    end
  end

  describe "search" do
    context "response status: 200" do
      before(
        do:
          mock(fn %{method: :get, url: _} ->
            {:ok, %Tesla.Env{status: 200, body: json_search_users()}}
          end)
      )

      context "when argument is a map" do
        it(
          do:
            expect(
              {:ok, %ZenEx.Collection{}} = Model.User.search(%{email: "first.last@example.com"})
            )
        )
      end

      context "when argument is a string" do
        it(do: expect({:ok, %ZenEx.Collection{}} = Model.User.search("my_string")))
      end
    end

    context "response status: 200 and external_id" do
      before(
        do:
          mock(fn %{method: :get, url: _} ->
            {:ok, %Tesla.Env{status: 200, body: json_search_external_id_users()}}
          end)
      )

      context "when argument is a map" do
        it(
          do:
            expect(
              {:ok, %ZenEx.Collection{count: 1, entities: [%{external_id: 1234567}]}} = Model.User.search(%{external_id: 1234567})
            )
        )
      end
    end
  end
end
