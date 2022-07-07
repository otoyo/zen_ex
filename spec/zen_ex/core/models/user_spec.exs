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

  describe "list" do
    before(
      do: mock(fn %{method: :get, url: _} -> %Tesla.Env{status: 200, body: json_users()} end)
    )

    it(do: expect(Model.User.list() |> to(be_struct(ZenEx.Collection))))
    it(do: expect(Model.User.list().entities |> to(eq(users()))))
  end

  describe "show" do
    before(do: mock(fn %{method: :get, url: _} -> %Tesla.Env{status: 200, body: json_user()} end))

    it(do: expect(Model.User.show(user().id) |> to(eq(user()))))
  end

  describe "create" do
    before(
      do: mock(fn %{method: :post, url: _} -> %Tesla.Env{status: 200, body: json_user()} end)
    )

    it(do: expect(Model.User.create(user()) |> to(be_struct(User))))
  end

  describe "update" do
    before(do: mock(fn %{method: :put, url: _} -> %Tesla.Env{status: 200, body: json_user()} end))

    it(do: expect(Model.User.update(user()) |> to(be_struct(User))))
  end

  describe "create_or_update" do
    before(
      do: mock(fn %{method: :post, url: _} -> %Tesla.Env{status: 200, body: json_user()} end)
    )

    it(do: expect(Model.User.create_or_update(user()) |> to(be_struct(User))))
  end

  describe "destroy" do
    before(
      do: mock(fn %{method: :delete, url: _} -> %Tesla.Env{status: 200, body: json_user()} end)
    )

    it(do: expect(Model.User.destroy(user().id) |> to(be_struct(User))))
  end

  describe "permanently_destroy" do
    before(
      do:
        mock(fn %{method: :delete, url: _} ->
          %Tesla.Env{status: 200, body: json_deleted_user()}
        end)
    )

    it(do: expect(Model.User.permanently_destroy(user().id) |> to(be_struct(User))))
  end

  describe "create_many" do
    before(
      do:
        mock(fn %{method: :post, url: _} ->
          %Tesla.Env{status: 200, body: json_job_status()}
        end)
    )

    it(do: expect(Model.User.create_many(users()) |> to(be_struct(JobStatus))))
  end

  describe "update_many" do
    before(
      do:
        mock(fn %{method: :put, url: _} ->
          %Tesla.Env{status: 200, body: json_job_status()}
        end)
    )

    it(do: expect(Model.User.update_many(users()) |> to(be_struct(JobStatus))))
  end

  describe "create_or_update_many" do
    before(
      do:
        mock(fn %{method: :post, url: _} ->
          %Tesla.Env{status: 200, body: json_job_status()}
        end)
    )

    it(do: expect(Model.User.create_or_update_many(users()) |> to(be_struct(JobStatus))))
  end

  describe "destroy_many" do
    before(
      do:
        mock(fn %{method: :delete, url: _} ->
          %Tesla.Env{status: 200, body: json_job_status()}
        end)
    )

    it(
      do: expect(Model.User.destroy_many(Enum.map(users(), & &1.id)) |> to(be_struct(JobStatus)))
    )
  end

  describe "search" do
    before(
      do:
        mock(fn %{method: :get, url: _} ->
          %Tesla.Env{status: 200, body: json_search_users()}
        end)
    )

    context "when argument is a map" do
      it(
        do:
          expect(
            Model.User.search(%{email: "first.last@example.com"})
            |> to(be_struct(ZenEx.Collection))
          )
      )

      it(
        do:
          expect(
            Model.User.search(%{email: "first.last@example.com"}).entities
            |> to(eq(users()))
          )
      )
    end

    context "when argument is a string" do
      it(do: expect(Model.User.search("my_string") |> to(be_struct(ZenEx.Collection))))
      it(do: expect(Model.User.search("my_string").entities |> to(eq(users()))))
    end
  end
end
