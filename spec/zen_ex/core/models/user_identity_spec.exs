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

  describe "list" do
    before(
      do:
        mock(fn %{method: :get, url: _} ->
          %Tesla.Env{status: 200, body: json_user_identities()}
        end)
    )

    it(do: expect(Model.UserIdentity.list(user) |> to(be_struct(ZenEx.Collection))))
    it(do: expect(Model.UserIdentity.list(user).entities |> to(eq(user_identities()))))
  end

  describe "show" do
    before(
      do:
        mock(fn %{method: :get, url: _} -> %Tesla.Env{status: 200, body: json_user_identity()} end)
    )

    it(do: expect(Model.UserIdentity.show(user, user_identity().id) |> to(eq(user_identity()))))
  end

  describe "create" do
    before(
      do:
        mock(fn %{method: :post, url: _} ->
          %Tesla.Env{status: 200, body: json_user_identity()}
        end)
    )

    it(
      do: expect(Model.UserIdentity.create(user, user_identity()) |> to(be_struct(UserIdentity)))
    )
  end

  describe "update" do
    before(
      do:
        mock(fn %{method: :put, url: _} -> %Tesla.Env{status: 200, body: json_user_identity()} end)
    )

    it(
      do: expect(Model.UserIdentity.update(user, user_identity()) |> to(be_struct(UserIdentity)))
    )
  end

  describe "make_primary" do
    before(
      do:
        mock(fn %{method: :put, url: _} ->
          %Tesla.Env{status: 200, body: json_user_identities()}
        end)
    )

    it(
      do:
        expect(
          Model.UserIdentity.make_primary(user, user_identity().id)
          |> to(be_struct(ZenEx.Collection))
        )
    )

    it(
      do:
        expect(
          Model.UserIdentity.make_primary(user, user_identity().id).entities
          |> to(eq(user_identities()))
        )
    )
  end

  describe "verify" do
    context "response status: 200" do
      before(
        do:
          mock(fn %{method: :put, url: _} ->
            %Tesla.Env{status: 200, body: %{}}
          end)
      )

      it(do: expect(Model.UserIdentity.verify(user, user_identity().id) |> to(eq(:ok))))
    end

    context "response status: 404" do
      before(
        do:
          mock(fn %{method: :put, url: _} ->
            %Tesla.Env{status: 404, body: json_user_identity()}
          end)
      )

      it(do: expect(Model.UserIdentity.verify(user, user_identity().id) |> to(eq(:error))))
    end
  end

  describe "request_user_verification" do
    context "response status: 200" do
      before(
        do:
          mock(fn %{method: :put, url: _} ->
            %Tesla.Env{status: 200, body: %{}}
          end)
      )

      it(
        do:
          expect(
            Model.UserIdentity.request_user_verification(user, user_identity().id)
            |> to(eq(:ok))
          )
      )
    end

    context "response status: 404" do
      before(
        do:
          mock(fn %{method: :put, url: _} ->
            %Tesla.Env{status: 404, body: %{}}
          end)
      )

      it(
        do:
          expect(
            Model.UserIdentity.request_user_verification(user, user_identity().id)
            |> to(eq(:error))
          )
      )
    end
  end

  describe "destroy" do
    context "response status: 204" do
      before(
        do:
          mock(fn %{method: :delete, url: _} ->
            %Tesla.Env{status: 204, body: json_user_identity()}
          end)
      )

      it(do: expect(Model.UserIdentity.destroy(user, user_identity().id) |> to(eq(:ok))))
    end

    context "response status: 404" do
      before(
        do:
          mock(fn %{method: :delete, url: _} ->
            %Tesla.Env{status: 404, body: json_user_identity()}
          end)
      )

      it(do: expect(Model.UserIdentity.destroy(user, user_identity().id) |> to(eq(:error))))
    end
  end
end
