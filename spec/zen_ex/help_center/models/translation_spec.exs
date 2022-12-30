defmodule ZenEx.HelpCenter.Model.TranslationSpec do
  use ESpec

  import Tesla.Mock
  alias ZenEx.HelpCenter.Entity.Translation
  alias ZenEx.HelpCenter.Model

  let :json_translations do
    ~s({"count":2,"translations":[{"id":35436,"title":"Help I need somebody!","locale":"en-us","source_id":112233,"source_type":"Article"},{"id":20057623,"title":"Not just anybody!","locale":"en-us","source_id":112233,"source_type":"Article"}]})
  end

  let :translations do
    [
      struct(Translation, %{
        id: 35436,
        title: "Help I need somebody!",
        locale: "en-us",
        source_id: 112_233,
        source_type: "Article"
      }),
      struct(Translation, %{
        id: 20_057_623,
        title: "Not just anybody!",
        locale: "en-us",
        source_id: 112_233,
        source_type: "Article"
      })
    ]
  end

  let(:json_translation,
    do:
      ~s({"translation":{"id":35436,"title":"My printer is on fire!","locale":"en-us","source_id":112233,"source_type":"Article"}})
  )

  let(:translation,
    do:
      struct(Translation, %{
        id: 35436,
        title: "My printer is on fire!",
        locale: "en-us",
        source_id: 112_233,
        source_type: "Article"
      })
  )

  let :json_locales do
    ~s({"locales":["en-us","ja"]})
  end

  let(:json_error, do: ~s({"error":"RecordNotFound","description":"Not found"}))

  describe "list" do
    before(
      do:
        mock(fn %{method: :get, url: _} ->
          {:ok, %Tesla.Env{status: 200, body: json_translations()}}
        end)
    )

    it(do: expect({:ok, %ZenEx.Collection{}} = Model.Translation.list(category_id: 1)))
    it(do: expect({:ok, %ZenEx.Collection{}} = Model.Translation.list(section_id: 1)))
    it(do: expect({:ok, %ZenEx.Collection{}} = Model.Translation.list(article_id: 1)))
  end

  describe "list_missing" do
    before(
      do:
        mock(fn %{method: :get, url: _} ->
          {:ok, %Tesla.Env{status: 200, body: json_locales()}}
        end)
    )

    it(do: expect({:ok, ["en-us", "ja"]} = Model.Translation.list_missing(category_id: 1)))
    it(do: expect({:ok, ["en-us", "ja"]} = Model.Translation.list_missing(section_id: 1)))
    it(do: expect({:ok, ["en-us", "ja"]} = Model.Translation.list_missing(article_id: 1)))
  end

  describe "show" do
    context "response status: 200" do
      before(
        do:
          mock(fn %{method: :get, url: _} ->
            {:ok, %Tesla.Env{status: 200, body: json_translation()}}
          end)
      )

      it(do: expect({:ok, %Translation{}} = Model.Translation.show("en-us", 1)))
    end

    context "response status: 404" do
      before(
        do:
          mock(fn %{method: :get, url: _} ->
            {:error, %Tesla.Env{status: 404, body: json_error()}}
          end)
      )

      it(do: expect({:error, _} = Model.Translation.show("en-us", 1)))
    end
  end

  describe "create" do
    context "response status: 201" do
      before(
        do:
          mock(fn %{method: :post, url: _} ->
            {:ok, %Tesla.Env{status: 201, body: json_translation()}}
          end)
      )

      it(
        do:
          expect(
            {:ok, %Translation{}} = Model.Translation.create([category_id: 1], translation())
          )
      )

      it(
        do:
          expect({:ok, %Translation{}} = Model.Translation.create([section_id: 1], translation()))
      )

      it(
        do:
          expect({:ok, %Translation{}} = Model.Translation.create([article_id: 1], translation()))
      )
    end

    context "response status: 500" do
      before(
        do:
          mock(fn %{method: :post, url: _} ->
            {:error, %Tesla.Env{status: 500, body: ""}}
          end)
      )

      it(do: expect({:error, _} = Model.Translation.create([category_id: 1], translation())))
    end
  end

  describe "update" do
    context "response status: 200" do
      before(
        do:
          mock(fn %{method: :put, url: _} ->
            {:ok, %Tesla.Env{status: 200, body: json_translation()}}
          end)
      )

      it(
        do:
          expect(
            {:ok, %Translation{}} = Model.Translation.update([category_id: 1], translation())
          )
      )

      it(
        do:
          expect({:ok, %Translation{}} = Model.Translation.update([section_id: 1], translation()))
      )

      it(
        do:
          expect({:ok, %Translation{}} = Model.Translation.update([article_id: 1], translation()))
      )
    end

    context "response status: 500" do
      before(
        do:
          mock(fn %{method: :put, url: _} ->
            {:error, %Tesla.Env{status: 500, body: ""}}
          end)
      )

      it(do: expect({:error, _} = Model.Translation.update([category_id: 1], translation())))
    end
  end

  describe "destroy" do
    context "response status: 204" do
      before(do: mock(fn %{method: :delete, url: _} -> {:ok, %Tesla.Env{status: 204}} end))

      it(do: expect(:ok = Model.Translation.destroy(translation().id)))
    end

    context "response status: 404" do
      before(
        do:
          mock(fn %{method: :delete, url: _} ->
            {:error, %Tesla.Env{status: 404, body: json_error()}}
          end)
      )

      it(do: expect({:error, _} = Model.Translation.destroy(translation().id)))
    end
  end
end
