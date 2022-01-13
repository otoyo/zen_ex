defmodule ZenEx.HelpCenter.Model.ArticleSpec do
  use ESpec

  import Tesla.Mock
  alias ZenEx.HelpCenter.Entity.{Category, Article}
  alias ZenEx.HelpCenter.Model

  let :section do
    struct(Category, %{id: 112233, name: "My printer is on fire!", locale: "en-us"})
  end

  let :json_articles do
    ~s({"count":2,"articles":[{"id":35436,"name":"Help I need somebody!","locale":"en-us","section_id":112233},{"id":20057623,"name":"Not just anybody!","locale":"en-us","section_id":112233}]})
  end
  let :articles do
    [struct(Article, %{id: 35436, name: "Help I need somebody!", locale: "en-us", section_id: section().id}),
     struct(Article, %{id: 20057623, name: "Not just anybody!", locale: "en-us", section_id: section().id})]
  end

  let :json_article, do: ~s({"article":{"id":35436,"name":"My printer is on fire!","locale":"en-us","section_id":112233}})
  let :article, do: struct(Article, %{id: 35436, name: "My printer is on fire!", locale: "en-us", section_id: section().id})

  let :json_results do
    ~s({"results":[{"id":35436,"name":"Help I need somebody!","locale":"en-us","section_id":112233},{"id":20057623,"name":"Not just anybody!","locale":"en-us","section_id":112233}]})
  end

  let :response_article, do: %Tesla.Env{body: json_article()}
  let :response_articles, do: %Tesla.Env{body: json_articles()}
  let :response_results, do: %Tesla.Env{body: json_results()}
  let :response_204, do: %Tesla.Env{status: 204}
  let :response_404, do: %Tesla.Env{status: 404}

  describe "list" do
    before do: mock(fn %{method: :get, url: _} -> %Tesla.Env{status: 200, body: response_articles()} end)
    it do: expect Model.Article.list("en-us") |> to(be_struct ZenEx.Collection)
    it do: expect Model.Article.list("en-us").entities |> to(eq articles())
    it do: expect Model.Article.list("en-us", section().id).entities |> to(eq articles())
  end

  describe "show" do
    before do: mock(fn %{method: :get, url: _} -> %Tesla.Env{status: 200, body: response_article()} end)
    it do: expect Model.Article.show("en-us", article().id) |> to(eq article())
  end

  describe "create" do
    before do: mock(fn %{method: :post, url: _} -> %Tesla.Env{status: 200, body: response_article()} end)
    it do: expect Model.Article.create(article()) |> to(be_struct Article)
  end

  describe "update" do
    before do: mock(fn %{method: :put, url: _} -> %Tesla.Env{status: 200, body: response_article()} end)
    it do: expect Model.Article.update(article()) |> to(be_struct Article)
  end

  describe "destroy" do
    context "response status: 204" do
      before do: mock(fn %{method: :delete, url: _} -> %Tesla.Env{status: 200, body: response_204()} end)
      it do: expect Model.Article.destroy(article().id) |> to(eq :ok)
    end
    context "response status: 404" do
      before do: mock(fn %{method: :delete, url: _} -> %Tesla.Env{status: 200, body: response_404()} end)
      it do: expect Model.Article.destroy(article().id) |> to(eq :error)
    end
  end

  describe "search" do
    before do: mock(fn %{method: :get, url: _} -> %Tesla.Env{status: 200, body: response_results()} end)
    it do: expect Model.Article.search("query=hoge&updated_after=2017-01-1") |> to(be_struct ZenEx.Collection)
    it do: expect Model.Article.search("query=hoge&updated_after=2017-01-1").entities |> to(eq articles())
  end
end
