defmodule ZenEx.Model.DynamicContentSpec do
  use ESpec

  import Tesla.Mock
  alias ZenEx.Entity.DynamicContent
  import Tesla.Mock
  alias ZenEx.Entity.DynamicContent.Variant
  alias ZenEx.Model

  let :json_dynamic_contents do
    ~s({"count":2,"items":[{"id":112233,"name":"mail-address","default_locale_id":1,"variants":[{"id":223443,"content":"Mail address","locale_id":1},{"id":8678530,"content":"メールアドレス","locale_id":67}]},{"id":223344,"name":"subject","default_locale_id":1,"variants":[]}]})
  end

  let :variants do
    [
      struct(Variant, %{id: 223_443, content: "Mail address", locale_id: 1}),
      struct(Variant, %{id: 8_678_530, content: "メールアドレス", locale_id: 67})
    ]
  end

  let :dynamic_contents do
    [
      struct(DynamicContent, %{
        id: 112_233,
        name: "mail-address",
        default_locale_id: 1,
        variants: variants()
      }),
      struct(DynamicContent, %{id: 223_344, name: "subject", default_locale_id: 1, variants: []})
    ]
  end

  let :json_dynamic_content do
    ~s({"item":{"id":112233,"name":"mail-address","default_locale_id":1,"variants":[{"id":223443,"content":"Mail address","locale_id":1},{"id":8678530,"content":"メールアドレス","locale_id":67}]}})
  end

  let :dynamic_content do
    struct(DynamicContent, %{
      id: 112_233,
      name: "mail-address",
      default_locale_id: 1,
      variants: variants()
    })
  end

  let(:json_error, do: ~s({"error":"RecordNotFound","description":"Not found"}))

  describe "list" do
    before(
      do:
        mock(fn %{method: :get, url: _} ->
          {:ok, %Tesla.Env{status: 200, body: json_dynamic_contents()}}
        end)
    )

    it(do: expect({:ok, %ZenEx.Collection{}} = Model.DynamicContent.list()))
  end

  describe "show" do
    context "response status: 200" do
      before(
        do:
          mock(fn %{method: :get, url: _} ->
            {:ok, %Tesla.Env{status: 200, body: json_dynamic_content()}}
          end)
      )

      it(do: expect({:ok, %DynamicContent{}} = Model.DynamicContent.show(dynamic_content().id)))
    end

    context "response status: 404" do
      before(
        do:
          mock(fn %{method: :get, url: _} ->
            {:error, %Tesla.Env{status: 404, body: json_error()}}
          end)
      )

      it(do: expect({:error, _} = Model.DynamicContent.show(dynamic_content().id)))
    end
  end

  describe "create" do
    context "response status: 201" do
      before(
        do:
          mock(fn %{method: :post, url: _} ->
            {:ok, %Tesla.Env{status: 201, body: json_dynamic_content()}}
          end)
      )

      it(do: expect({:ok, %DynamicContent{}} = Model.DynamicContent.create(dynamic_content())))
    end

    context "response status: 500" do
      before(
        do:
          mock(fn %{method: :post, url: _} ->
            {:error, %Tesla.Env{status: 500, body: ""}}
          end)
      )

      it(do: expect({:error, _} = Model.DynamicContent.create(dynamic_content())))
    end
  end

  describe "update" do
    context "response status: 200" do
      before(
        do:
          mock(fn %{method: :put, url: _} ->
            {:ok, %Tesla.Env{status: 200, body: json_dynamic_content()}}
          end)
      )

      it(do: expect({:ok, %DynamicContent{}} = Model.DynamicContent.update(dynamic_content())))
    end

    context "response status: 500" do
      before(
        do:
          mock(fn %{method: :put, url: _} ->
            {:error, %Tesla.Env{status: 500, body: ""}}
          end)
      )

      it(do: expect({:error, _} = Model.DynamicContent.update(dynamic_content())))
    end
  end

  describe "destroy" do
    context "response status: 204" do
      before(do: mock(fn %{method: :delete, url: _} -> {:ok, %Tesla.Env{status: 204}} end))

      it(do: expect(:ok = Model.DynamicContent.destroy(dynamic_content().id)))
    end

    context "response status: 404" do
      before(
        do:
          mock(fn %{method: :delete, url: _} ->
            {:error, %Tesla.Env{status: 404, body: json_error()}}
          end)
      )

      it(do: expect({:error, _} = Model.DynamicContent.destroy(dynamic_content().id)))
    end
  end

  describe "_build_variants" do
    subject do
      dynamic_content()
      |> Map.update(:variants, [], fn variants -> Enum.map(variants, &Map.from_struct/1) end)
      |> Model.DynamicContent._build_variants()
    end

    it(do: expect(subject().variants) |> to(have_all(fn v -> v |> to(be_struct(Variant)) end)))
  end
end
