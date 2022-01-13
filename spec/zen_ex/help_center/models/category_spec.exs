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

  let(:response_category, do: %Tesla.Env{body: json_category()})
  let(:response_categories, do: %Tesla.Env{body: json_categories()})
  let(:response_204, do: %Tesla.Env{status: 204})
  let(:response_404, do: %Tesla.Env{status: 404})

  describe "list" do
    before(
      do:
        mock(fn %{method: :get, url: _} ->
          %Tesla.Env{status: 200, body: response_categories()}
        end)
    )

    it(do: expect(Model.Category.list("en-us") |> to(be_struct(ZenEx.Collection))))
    it(do: expect(Model.Category.list("en-us").entities |> to(eq(categories()))))
  end

  describe "show" do
    before(
      do:
        mock(fn %{method: :get, url: _} -> %Tesla.Env{status: 200, body: response_category()} end)
    )

    it(do: expect(Model.Category.show("en-us", category().id) |> to(eq(category()))))
  end

  describe "create" do
    before(
      do:
        mock(fn %{method: :post, url: _} -> %Tesla.Env{status: 200, body: response_category()} end)
    )

    it(do: expect(Model.Category.create(category()) |> to(be_struct(Category))))
  end

  describe "update" do
    before(
      do:
        mock(fn %{method: :put, url: _} -> %Tesla.Env{status: 200, body: response_category()} end)
    )

    it(do: expect(Model.Category.update(category()) |> to(be_struct(Category))))
  end

  describe "destroy" do
    context "response status: 204" do
      before(
        do:
          mock(fn %{method: :delete, url: _} -> %Tesla.Env{status: 200, body: response_204()} end)
      )

      it(do: expect(Model.Category.destroy(category().id) |> to(eq(:ok))))
    end

    context "response status: 404" do
      before(
        do:
          mock(fn %{method: :delete, url: _} -> %Tesla.Env{status: 200, body: response_404()} end)
      )

      it(do: expect(Model.Category.destroy(category().id) |> to(eq(:error))))
    end
  end
end
