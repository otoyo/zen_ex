defmodule ZenEx.HelpCenter.Model.ArticleSpec do
  use ESpec

  alias ZenEx.HTTPClient
  alias ZenEx.HelpCenter.Entity.{Category, Article}
  alias ZenEx.HelpCenter.Model

  let :section do
    struct(Category, %{id: 112233, name: "My printer is on fire!", locale: "en-us"})
  end

  let :json_articles do
    ~s({"articles":[{"id":35436,"name":"Help I need somebody!","locale":"en-us","section_id":112233},{"id":20057623,"name":"Not just anybody!","locale":"en-us","section_id":112233}]})
  end
  let :articles do
    [struct(Article, %{id: 35436, name: "Help I need somebody!", locale: "en-us", section_id: section().id}),
     struct(Article, %{id: 20057623, name: "Not just anybody!", locale: "en-us", section_id: section().id})]
  end

  let :json_article, do: ~s({"article":{"id":35436,"name":"My printer is on fire!","locale":"en-us","section_id":112233}})
  let :article, do: struct(Article, %{id: 35436, name: "My printer is on fire!", locale: "en-us", section_id: section().id})

  let :response_article, do: %HTTPotion.Response{body: json_article()}
  let :response_articles, do: %HTTPotion.Response{body: json_articles()}
  let :response_204, do: %HTTPotion.Response{status_code: 204}
  let :response_404, do: %HTTPotion.Response{status_code: 404}

  describe "list" do
    before do: allow HTTPClient |> to(accept :get, fn(_) -> response_articles() end)
    it do: expect Model.Article.list("en-us") |> to(eq articles())
    it do: expect Model.Article.list("en-us", section().id) |> to(eq articles())
  end

  describe "show" do
    before do: allow HTTPClient |> to(accept :get, fn(_) -> response_article() end)
    it do: expect Model.Article.show("en-us", article().id) |> to(eq article())
  end

  describe "create" do
    before do: allow HTTPClient |> to(accept :post, fn(_, _) -> response_article() end)
    it do: expect Model.Article.create(article()) |> to(be_struct Article)
  end

  describe "update" do
    before do: allow HTTPClient |> to(accept :put, fn(_, _) -> response_article() end)
    it do: expect Model.Article.update(article()) |> to(be_struct Article)
  end

  describe "destroy" do
    context "response status_code: 204" do
      before do: allow HTTPClient |> to(accept :delete, fn(_) -> response_204() end)
      it do: expect Model.Article.destroy(article().id) |> to(eq :ok)
    end
    context "response status_code: 404" do
      before do: allow HTTPClient |> to(accept :delete, fn(_) -> response_404() end)
      it do: expect Model.Article.destroy(article().id) |> to(eq :error)
    end
  end

  describe "_create_articles" do
    subject do: Model.Article._create_articles response_articles()
    it do: is_expected() |> to(eq articles())
  end

  describe "_create_article" do
    subject do: Model.Article._create_article response_article()
    it do: is_expected() |> to(eq article())
  end
end
