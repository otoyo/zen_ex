defmodule ZenEx.HelpCenter.Model.CategorySpec do
  use ESpec

  import Tesla.Mock
  alias ZenEx.HelpCenter.Entity.Category
  alias ZenEx.HelpCenter.Model

  let :json_categories do
    ~s({"count":2,"categories":[{"id":35436,"name":"Help I need somebody!","locale":"en-us"},{"id":20057623,"name":"Not just anybody!","locale":"en-us"}]})
  end

  let :categories do
    [
      struct(Category, %{id: 35436, name: "Help I need somebody!", locale: "en-us"}),
      struct(Category, %{id: 20_057_623, name: "Not just anybody!", locale: "en-us"})
    ]
  end

  let(:json_category,
    do: ~s({"category":{"id":35436,"name":"My printer is on fire!","locale":"en-us"}})
  )

  let(:category,
    do: struct(Category, %{id: 35436, name: "My printer is on fire!", locale: "en-us"})
  )

  let(:json_error, do: ~s({"error":"RecordNotFound","description":"Not found"}))

  describe "list" do
    before(
      do:
        mock(fn %{method: :get, url: _} ->
          %Tesla.Env{status: 200, body: json_categories()}
        end)
    )

    it(do: expect({:ok, %ZenEx.Collection{}} = Model.Category.list("en-us")))
  end

  describe "show" do
    context "response status: 200" do
      before(
        do:
          mock(fn %{method: :get, url: _} ->
            {:ok, %Tesla.Env{status: 200, body: json_category()}}
          end)
      )

      it(do: expect({:ok, %Category{}} = Model.Category.show("en-us", category().id)))
    end

    context "response status: 404" do
      before(
        do:
          mock(fn %{method: :get, url: _} ->
            {:error, %Tesla.Env{status: 404, body: json_error()}}
          end)
      )

      it(do: expect({:error, _} = Model.Category.show("en-us", category().id)))
    end
  end

  describe "create" do
    context "response status: 201" do
      before(
        do:
          mock(fn %{method: :post, url: _} ->
            {:ok, %Tesla.Env{status: 201, body: json_category()}}
          end)
      )

      it(do: expect({:ok, %Category{}} = Model.Category.create(category())))
    end

    context "response status: 500" do
      before(
        do:
          mock(fn %{method: :post, url: _} ->
            {:error, %Tesla.Env{status: 500, body: ""}}
          end)
      )

      it(do: expect({:error, _} = Model.Category.create(category())))
    end
  end

  describe "update" do
    context "response status: 200" do
      before(
        do:
          mock(fn %{method: :put, url: _} ->
            {:ok, %Tesla.Env{status: 200, body: json_category()}}
          end)
      )

      it(do: expect({:ok, %Category{}} = Model.Category.update(category())))
    end

    context "response status: 500" do
      before(
        do:
          mock(fn %{method: :put, url: _} ->
            {:error, %Tesla.Env{status: 500, body: ""}}
          end)
      )

      it(do: expect({:error, _} = Model.Category.update(category())))
    end
  end

  describe "destroy" do
    context "response status: 204" do
      before(do: mock(fn %{method: :delete, url: _} -> {:ok, %Tesla.Env{status: 204}} end))

      it(do: expect(:ok = Model.Category.destroy(category().id)))
    end

    context "response status: 404" do
      before(
        do:
          mock(fn %{method: :delete, url: _} ->
            {:error, %Tesla.Env{status: 404, body: json_error()}}
          end)
      )

      it(do: expect({:error, _} = Model.Category.destroy(category().id)))
    end
  end
end
