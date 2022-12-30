defmodule ZenEx.Model.UserIdentitySpec do
  use ESpec

  import Tesla.Mock
  alias ZenEx.Entity.{UserIdentity, User}
  alias ZenEx.Model

  let :json_user_identities do
    ~s({"count":2,"identities":[{"id":35436,"primary":true,"type":"email","user_id":135,"value":"someone@example.com"},{"id":77136,"primary":false,"type":"twitter","user_id":135,"value":"didgeridooboy"}]})
  end

  let :user_identities do
    [
      struct(UserIdentity, %{
        id: 35436,
        user_id: 135,
        type: "email",
        value: "someone@example.com",
        primary: true
      }),
      struct(UserIdentity, %{
        id: 77136,
        user_id: 135,
        type: "twitter",
        value: "didgeridooboy",
        primary: false
      })
    ]
  end

  let(:json_user_identity,
    do:
      ~s({"identity":{"id":35436,"primary":true,"type":"email","user_id":135,"value":"someone@example.com"}})
  )

  let(:user_identity,
    do:
      struct(UserIdentity, %{
        id: 35436,
        user_id: 135,
        type: "email",
        value: "someone@example.com",
        primary: true
      })
  )

  let(:user, do: struct(User, id: 135))

  let(:json_error, do: ~s({"error":"RecordNotFound","description":"Not found"}))

  describe "list" do
    before(
      do:
        mock(fn %{method: :get, url: _} ->
          {:ok, %Tesla.Env{status: 200, body: json_user_identities()}}
        end)
    )

    it(do: expect({:ok, %ZenEx.Collection{}} = Model.UserIdentity.list(user())))
  end

  describe "show" do
    context "response status: 200" do
      before(
        do:
          mock(fn %{method: :get, url: _} ->
            {:ok, %Tesla.Env{status: 200, body: json_user_identity()}}
          end)
      )

      it(do: expect({:ok, %UserIdentity{}} = Model.UserIdentity.show(user(), user_identity().id)))
    end

    context "response status: 404" do
      before(
        do:
          mock(fn %{method: :get, url: _} ->
            {:error, %Tesla.Env{status: 404, body: json_error()}}
          end)
      )

      it(do: expect({:error, _} = Model.UserIdentity.show(user(), user_identity().id)))
    end
  end

  describe "create" do
    context "response status: 201" do
      before(
        do:
          mock(fn %{method: :post, url: _} ->
            {:ok, %Tesla.Env{status: 200, body: json_user_identity()}}
          end)
      )

      it(do: expect({:ok, %UserIdentity{}} = Model.UserIdentity.create(user(), user_identity())))
    end

    context "response status: 500" do
      before(
        do:
          mock(fn %{method: :post, url: _} ->
            {:error, %Tesla.Env{status: 500, body: ""}}
          end)
      )

      it(do: expect({:error, _} = Model.UserIdentity.create(user(), user_identity())))
    end
  end

  describe "update" do
    context "response status: 200" do
      before(
        do:
          mock(fn %{method: :put, url: _} ->
            {:ok, %Tesla.Env{status: 200, body: json_user_identity()}}
          end)
      )

      it(do: expect({:ok, %UserIdentity{}} = Model.UserIdentity.update(user(), user_identity())))
    end

    context "response status: 500" do
      before(
        do:
          mock(fn %{method: :put, url: _} ->
            {:error, %Tesla.Env{status: 500, body: ""}}
          end)
      )

      it(do: expect({:error, _} = Model.UserIdentity.update(user(), user_identity())))
    end
  end

  describe "make_primary" do
    context "response status: 200" do
      before(
        do:
          mock(fn %{method: :put, url: _} ->
            {:ok, %Tesla.Env{status: 200, body: json_user_identities()}}
          end)
      )

      it(
        do:
          expect(
            {:ok, %ZenEx.Collection{}} =
              Model.UserIdentity.make_primary(user(), user_identity().id)
          )
      )
    end

    context "response status: 500" do
      before(
        do:
          mock(fn %{method: :put, url: _} ->
            {:error, %Tesla.Env{status: 500, body: ""}}
          end)
      )

      it(do: expect({:error, _} = Model.UserIdentity.make_primary(user(), user_identity().id)))
    end
  end

  describe "verify" do
    context "response status: 200" do
      before(
        do:
          mock(fn %{method: :put, url: _} ->
            {:ok, %Tesla.Env{status: 200, body: %{}}}
          end)
      )

      it(do: expect(:ok = Model.UserIdentity.verify(user(), user_identity().id)))
    end

    context "response status: 404" do
      before(
        do:
          mock(fn %{method: :put, url: _} ->
            {:error, %Tesla.Env{status: 404, body: json_error()}}
          end)
      )

      it(do: expect({:error, _} = Model.UserIdentity.verify(user(), user_identity().id)))
    end
  end

  describe "request_user_verification" do
    context "response status: 200" do
      before(
        do:
          mock(fn %{method: :put, url: _} ->
            {:ok, %Tesla.Env{status: 200, body: %{}}}
          end)
      )

      it(
        do: expect(:ok = Model.UserIdentity.request_user_verification(user(), user_identity().id))
      )
    end

    context "response status: 404" do
      before(
        do:
          mock(fn %{method: :put, url: _} ->
            {:error, %Tesla.Env{status: 404, body: json_error()}}
          end)
      )

      it(
        do:
          expect(
            {:error, _} = Model.UserIdentity.request_user_verification(user(), user_identity().id)
          )
      )
    end
  end

  describe "destroy" do
    context "response status: 204" do
      before(
        do:
          mock(fn %{method: :delete, url: _} ->
            {:ok, %Tesla.Env{status: 204, body: json_user_identity()}}
          end)
      )

      it(do: expect(:ok = Model.UserIdentity.destroy(user(), user_identity().id)))
    end

    context "response status: 404" do
      before(
        do:
          mock(fn %{method: :delete, url: _} ->
            {:error, %Tesla.Env{status: 404, body: json_error()}}
          end)
      )

      it(do: expect({:error, _} = Model.UserIdentity.destroy(user(), user_identity().id)))
    end
  end
end
