defmodule ZenEx.HelpCenter.Model.CategorySpec do
  use ESpec

  alias ZenEx.HelpCenter.Entity.Category
  alias ZenEx.HelpCenter.Model

  let :json_categories do
    ~s({"count":2,"categories":[{"id":35436,"name":"Help I need somebody!","locale":"en-us"},{"id":20057623,"name":"Not just anybody!","locale":"en-us"}]})
  end
  let :categories do
    [struct(Category, %{id: 35436, name: "Help I need somebody!", locale: "en-us"}),
     struct(Category, %{id: 20057623, name: "Not just anybody!", locale: "en-us"})]
  end

  let :json_category, do: ~s({"category":{"id":35436,"name":"My printer is on fire!","locale":"en-us"}})
  let :category, do: struct(Category, %{id: 35436, name: "My printer is on fire!", locale: "en-us"})

  let :response_category, do: %HTTPotion.Response{body: json_category()}
  let :response_categories, do: %HTTPotion.Response{body: json_categories()}
  let :response_204, do: %HTTPotion.Response{status_code: 204}
  let :response_404, do: %HTTPotion.Response{status_code: 404}

  describe "list" do
    before do: allow HTTPotion |> to(accept :get, fn(_, _) -> response_categories() end)
    it do: expect Model.Category.list("en-us") |> to(be_struct ZenEx.Collection)
    it do: expect Model.Category.list("en-us").entities |> to(eq categories())
  end

  describe "show" do
    before do: allow HTTPotion |> to(accept :get, fn(_, _) -> response_category() end)
    it do: expect Model.Category.show("en-us", category().id) |> to(eq category())
  end

  describe "create" do
    before do: allow HTTPotion |> to(accept :post, fn(_, _) -> response_category() end)
    it do: expect Model.Category.create(category()) |> to(be_struct Category)
  end

  describe "update" do
    before do: allow HTTPotion |> to(accept :put, fn(_, _) -> response_category() end)
    it do: expect Model.Category.update(category()) |> to(be_struct Category)
  end

  describe "destroy" do
    context "response status_code: 204" do
      before do: allow HTTPotion |> to(accept :delete, fn(_, _) -> response_204() end)
      it do: expect Model.Category.destroy(category().id) |> to(eq :ok)
    end
    context "response status_code: 404" do
      before do: allow HTTPotion |> to(accept :delete, fn(_, _) -> response_404() end)
      it do: expect Model.Category.destroy(category().id) |> to(eq :error)
    end
  end
end
