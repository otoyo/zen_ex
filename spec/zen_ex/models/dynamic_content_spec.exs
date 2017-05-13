defmodule ZenEx.Model.DynamicContentSpec do
  use ESpec

  alias ZenEx.Core.Client
  alias ZenEx.Entity.DynamicContent
  alias ZenEx.Entity.DynamicContent.Variant
  alias ZenEx.Model

  let :json_dynamic_contents do
    ~s({"items":[{"id":112233,"name":"mail-address","default_locale_id":1,"variants":[{"id":223443,"content":"Mail address","locale_id":1},{"id":8678530,"content":"メールアドレス","locale_id":67}]},{"id":223344,"name":"subject","default_locale_id":1,"variants":[]}]})
  end
  let :variants do
    [struct(Variant, %{id: 223443, content: "Mail address", locale_id: 1}), struct(Variant, %{id: 8678530, content: "メールアドレス", locale_id: 67})]
  end
  let :dynamic_contents do
    [struct(DynamicContent, %{id: 112233, name: "mail-address", default_locale_id: 1, variants: variants()}), struct(DynamicContent, %{id: 223344, name: "subject", default_locale_id: 1, variants: []})]
  end

  let :json_dynamic_content do
    ~s({"item":{"id":112233,"name":"mail-address","default_locale_id":1,"variants":[{"id":223443,"content":"Mail address","locale_id":1},{"id":8678530,"content":"メールアドレス","locale_id":67}]}})
  end
  let :dynamic_content do
    struct(DynamicContent, %{id: 112233, name: "mail-address", default_locale_id: 1, variants: variants()})
  end

  let :response_dynamic_content, do: %HTTPotion.Response{body: json_dynamic_content()}
  let :response_dynamic_contents, do: %HTTPotion.Response{body: json_dynamic_contents()}
  let :response_204, do: %HTTPotion.Response{status_code: 204}
  let :response_404, do: %HTTPotion.Response{status_code: 404}

  describe "list" do
    before do: allow Client |> to(accept :get, fn(_) -> response_dynamic_contents() end)
    it do: expect Model.DynamicContent.list |> to(eq dynamic_contents())
  end

  describe "show" do
    before do: allow Client |> to(accept :get, fn(_) -> response_dynamic_content() end)
    it do: expect Model.DynamicContent.show(dynamic_content().id) |> to(eq dynamic_content())
  end

  describe "create" do
    before do: allow Client |> to(accept :post, fn(_, _) -> response_dynamic_content() end)
    it do: expect Model.DynamicContent.create(dynamic_content()) |> to(be_struct DynamicContent)
  end

  describe "update" do
    before do: allow Client |> to(accept :put, fn(_, _) -> response_dynamic_content() end)
    it do: expect Model.DynamicContent.update(dynamic_content()) |> to(be_struct DynamicContent)
  end

  describe "destroy" do
    context "response status_code: 204" do
      before do: allow Client |> to(accept :delete, fn(_) -> response_204() end)
      it do: expect Model.DynamicContent.destroy(dynamic_content().id) |> to(eq :ok)
    end
    context "response status_code: 404" do
      before do: allow Client |> to(accept :delete, fn(_) -> response_404() end)
      it do: expect Model.DynamicContent.destroy(dynamic_content().id) |> to(eq :error)
    end
  end

  describe "_create_dynamic_contents" do
    describe "list of dynamic_content" do
      subject do: Model.DynamicContent._create_dynamic_contents response_dynamic_contents()
      it do: is_expected() |> to(eq dynamic_contents())
    end
    describe "with variants" do
      subject do: Model.DynamicContent._create_dynamic_contents(response_dynamic_contents()) |> List.first |> Map.get(:variants)
      it do: is_expected() |> to(have_all(fn v -> v |> to(be_struct Variant) end))
    end
  end

  describe "_create_dynamic_content" do
    describe "the dynamic_content" do
      subject do: Model.DynamicContent._create_dynamic_content response_dynamic_content()
      it do: is_expected() |> to(eq dynamic_content())
    end
    describe "with variants" do
      subject do: Model.DynamicContent._create_dynamic_content(response_dynamic_content()) |> Map.get(:variants)
      it do: is_expected() |> to(have_all(fn v -> v |> to(be_struct Variant) end))
    end
  end
end
