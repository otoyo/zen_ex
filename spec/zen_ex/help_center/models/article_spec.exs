defmodule ZenEx.HelpCenter.Model.ArticleSpec do
  use ESpec

  import Tesla.Mock
  alias ZenEx.HelpCenter.Entity.{Category, Article}
  alias ZenEx.HelpCenter.Model

  let :section do
    struct(Category, %{id: 112_233, name: "My printer is on fire!", locale: "en-us"})
  end

  let :json_articles do
    ~s({"count":2,"articles":[{"id":35436,"name":"Help I need somebody!","locale":"en-us","section_id":112233},{"id":20057623,"name":"Not just anybody!","locale":"en-us","section_id":112233}]})
  end

  let :articles do
    [
      struct(Article, %{
        id: 35436,
        name: "Help I need somebody!",
        locale: "en-us",
        section_id: section().id
      }),
      struct(Article, %{
        id: 20_057_623,
        name: "Not just anybody!",
        locale: "en-us",
        section_id: section().id
      })
    ]
  end

  let(:json_article,
    do:
      ~s({"article":{"id":35436,"name":"My printer is on fire!","locale":"en-us","section_id":112233}})
  )

  let(:article,
    do:
      struct(Article, %{
        id: 35436,
        name: "My printer is on fire!",
        locale: "en-us",
        section_id: section().id
      })
  )

  let :json_results do
    ~s({"results":[{"id":35436,"name":"Help I need somebody!","locale":"en-us","section_id":112233},{"id":20057623,"name":"Not just anybody!","locale":"en-us","section_id":112233}]})
  end

  let(:json_error, do: ~s({"error":"RecordNotFound","description":"Not found"}))

  describe "list" do
    before(
      do:
        mock(fn %{method: :get, url: _} ->
          {:ok, %Tesla.Env{status: 200, body: json_articles()}}
        end)
    )

    it(do: expect({:ok, %ZenEx.Collection{}} = Model.Article.list("en-us")))
  end

  describe "show" do
    context "response status: 200" do
      before(
        do:
          mock(fn %{method: :get, url: _} ->
            {:ok, %Tesla.Env{status: 200, body: json_article()}}
          end)
      )

      it(do: expect({:ok, %Article{}} = Model.Article.show("en-us", article().id)))
    end

    context "response status: 404" do
      before(
        do:
          mock(fn %{method: :get, url: _} ->
            {:error, %Tesla.Env{status: 404, body: json_error()}}
          end)
      )

      it(do: expect({:error, _} = Model.Article.show("en-us", article().id)))
    end
  end

  describe "create" do
    context "response status: 201" do
      before(
        do:
          mock(fn %{method: :post, url: _} ->
            {:ok, %Tesla.Env{status: 201, body: json_article()}}
          end)
      )

      it(do: expect({:ok, %Article{}} = Model.Article.create(article())))
    end

    context "response status: 500" do
      before(
        do:
          mock(fn %{method: :post, url: _} ->
            {:error, %Tesla.Env{status: 500, body: ""}}
          end)
      )

      it(do: expect({:error, _} = Model.Article.create(article())))
    end
  end

  describe "update" do
    context "response status: 200" do
      before(
        do:
          mock(fn %{method: :put, url: _} ->
            {:ok, %Tesla.Env{status: 200, body: json_article()}}
          end)
      )

      it(do: expect({:ok, %Article{}} = Model.Article.update(article())))
    end

    context "response status: 500" do
      before(
        do:
          mock(fn %{method: :put, url: _} ->
            {:error, %Tesla.Env{status: 500, body: ""}}
          end)
      )

      it(do: expect({:error, _} = Model.Article.update(article())))
    end
  end

  describe "destroy" do
    context "response status: 204" do
      before(do: mock(fn %{method: :delete, url: _} -> {:ok, %Tesla.Env{status: 204}} end))

      it(do: expect(:ok = Model.Article.destroy(article().id)))
    end

    context "response status: 404" do
      before(
        do:
          mock(fn %{method: :delete, url: _} ->
            {:error, %Tesla.Env{status: 404, body: json_error()}}
          end)
      )

      it(do: expect({:error, _} = Model.Article.destroy(article().id)))
    end
  end

  describe "search" do
    before(
      do:
        mock(fn %{method: :get, url: _} ->
          {:ok, %Tesla.Env{status: 200, body: json_results()}}
        end)
    )

    it(
      do:
        expect(
          {:ok, %ZenEx.Collection{}} = Model.Article.search("query=hoge&updated_after=2017-01-1")
        )
    )
  end
end
