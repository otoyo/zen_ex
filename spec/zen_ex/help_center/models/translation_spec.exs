defmodule ZenEx.HelpCenter.Model.TranslationSpec do
  use ESpec

  alias ZenEx.HelpCenter.Entity.Translation
  alias ZenEx.HelpCenter.Model

  let :json_translations do
    ~s({"count":2,"translations":[{"id":35436,"title":"Help I need somebody!","locale":"en-us","source_id":112233,"source_type":"Article"},{"id":20057623,"title":"Not just anybody!","locale":"en-us","source_id":112233,"source_type":"Article"}]})
  end
  let :translations do
    [struct(Translation, %{id: 35436, title: "Help I need somebody!", locale: "en-us", source_id: 112233, source_type: "Article"}),
     struct(Translation, %{id: 20057623, title: "Not just anybody!", locale: "en-us", source_id: 112233, source_type: "Article"})]
  end

  let :json_translation, do: ~s({"translation":{"id":35436,"title":"My printer is on fire!","locale":"en-us","source_id":112233,"source_type":"Article"}})
  let :translation, do: struct(Translation, %{id: 35436, title: "My printer is on fire!", locale: "en-us", source_id: 112233, source_type: "Article"})

  let :json_locales do
    ~s({"locales":["en-us","ja"]})
  end

  let :response_translation, do: %HTTPotion.Response{body: json_translation()}
  let :response_translations, do: %HTTPotion.Response{body: json_translations()}
  let :response_locales, do: %HTTPotion.Response{body: json_locales()}
  let :response_204, do: %HTTPotion.Response{status_code: 204}
  let :response_404, do: %HTTPotion.Response{status_code: 404}

  describe "list" do
    before do: allow HTTPotion |> to(accept :get, fn(_, _) -> response_translations() end)
    it do: expect Model.Translation.list(category_id: 1) |> to(be_struct ZenEx.Collection)
    it do: expect Model.Translation.list(category_id: 1).entities |> to(eq translations())
    it do: expect Model.Translation.list(section_id: 1).entities |> to(eq translations())
    it do: expect Model.Translation.list(article_id: 1).entities |> to(eq translations())
  end

  describe "list_missing" do
    before do: allow HTTPotion |> to(accept :get, fn(_, _) -> response_locales() end)
    it do: expect Model.Translation.list_missing(category_id: 1) |> to(eq ["en-us", "ja"])
    it do: expect Model.Translation.list_missing(section_id: 1) |> to(eq ["en-us", "ja"])
    it do: expect Model.Translation.list_missing(article_id: 1) |> to(eq ["en-us", "ja"])
  end

  describe "show" do
    before do: allow HTTPotion |> to(accept :get, fn(_, _) -> response_translation() end)
    it do: expect Model.Translation.show("en-us", 1) |> to(eq translation())
  end

  describe "create" do
    before do: allow HTTPotion |> to(accept :post, fn(_, _) -> response_translation() end)
    it do: expect Model.Translation.create([category_id: 1], translation()) |> to(be_struct Translation)
    it do: expect Model.Translation.create([section_id: 1], translation()) |> to(be_struct Translation)
    it do: expect Model.Translation.create([article_id: 1], translation()) |> to(be_struct Translation)
  end

  describe "update" do
    before do: allow HTTPotion |> to(accept :put, fn(_, _) -> response_translation() end)
    it do: expect Model.Translation.update([category_id: 1], translation()) |> to(be_struct Translation)
    it do: expect Model.Translation.update([section_id: 1], translation()) |> to(be_struct Translation)
    it do: expect Model.Translation.update([article_id: 1], translation()) |> to(be_struct Translation)
  end

  describe "destroy" do
    context "response status_code: 204" do
      before do: allow HTTPotion |> to(accept :delete, fn(_, _) -> response_204() end)
      it do: expect Model.Translation.destroy(translation().id) |> to(eq :ok)
    end
    context "response status_code: 404" do
      before do: allow HTTPotion |> to(accept :delete, fn(_, _) -> response_404() end)
      it do: expect Model.Translation.destroy(translation().id) |> to(eq :error)
    end
  end
end
