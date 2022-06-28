defmodule ZenEx.Model.DynamicContent.VariantSpec do
  use ESpec

  import Tesla.Mock
  alias ZenEx.Entity.DynamicContent.Variant
  import Tesla.Mock
  alias ZenEx.Entity.{DynamicContent, JobStatus}
  alias ZenEx.Model

  let :json_variants do
    ~s({"count":2,"variants":[{"id":223443,"content":"Mail address","locale_id":1},{"id":8678530,"content":"メールアドレス","locale_id":67}]})
  end

  let :variants do
    [
      struct(Variant, %{id: 223_443, content: "Mail address", locale_id: 1}),
      struct(Variant, %{id: 8_678_530, content: "メールアドレス", locale_id: 67})
    ]
  end

  let(:json_variant, do: ~s({"variant":{"id":223443,"content":"Mail address","locale_id":1}}))
  let(:variant, do: struct(Variant, %{id: 223_443, content: "Mail address", locale_id: 1}))

  let :json_job_status do
    ~s({"job_status":{"id":"8b726e606741012ffc2d782bcb7848fe","status":"completed"}})
  end

  let :job_status do
    struct(JobStatus, %{id: "8b726e606741012ffc2d782bcb7848fe", status: "completed"})
  end

  let :dynamic_content do
    struct(DynamicContent, %{id: 112_233, name: "mail-address", default_locale_id: 1})
  end

  describe "list" do
    before(
      do:
        mock(fn %{method: :get, url: _} -> %Tesla.Env{status: 200, body: json_variants()} end)
    )

    it(
      do:
        expect(
          Model.DynamicContent.Variant.list(dynamic_content().id)
          |> to(be_struct(ZenEx.Collection))
        )
    )

    it(
      do:
        expect(
          Model.DynamicContent.Variant.list(dynamic_content().id).entities
          |> to(eq(variants()))
        )
    )
  end

  describe "show" do
    before(
      do:
        mock(fn %{method: :get, url: _} -> %Tesla.Env{status: 200, body: json_variant()} end)
    )

    it(
      do:
        expect(
          Model.DynamicContent.Variant.show(dynamic_content().id, variant().id)
          |> to(eq(variant()))
        )
    )
  end

  describe "create" do
    before(
      do:
        mock(fn %{method: :post, url: _} -> %Tesla.Env{status: 200, body: json_variant()} end)
    )

    it(
      do:
        expect(
          Model.DynamicContent.Variant.create(dynamic_content().id, variant())
          |> to(be_struct(Variant))
        )
    )
  end

  describe "create_many" do
    before(
      do:
        mock(fn %{method: :post, url: _} ->
          %Tesla.Env{status: 200, body: json_job_status()}
        end)
    )

    it(
      do:
        expect(
          Model.DynamicContent.Variant.create_many(dynamic_content().id, variants())
          |> to(be_struct(JobStatus))
        )
    )
  end

  describe "update" do
    before(
      do:
        mock(fn %{method: :put, url: _} -> %Tesla.Env{status: 200, body: json_variant()} end)
    )

    it(
      do:
        expect(
          Model.DynamicContent.Variant.update(dynamic_content().id, variant())
          |> to(be_struct(Variant))
        )
    )
  end

  describe "update_many" do
    before(
      do:
        mock(fn %{method: :put, url: _} ->
          %Tesla.Env{status: 200, body: json_job_status()}
        end)
    )

    it(
      do:
        expect(
          Model.DynamicContent.Variant.update_many(dynamic_content().id, variants())
          |> to(be_struct(JobStatus))
        )
    )
  end

  describe "destroy" do
    context "response status: 204" do
      before(
        do:
          mock(fn %{method: :delete, url: _} -> %Tesla.Env{status: 204} end)
      )

      it(
        do:
          expect(
            Model.DynamicContent.Variant.destroy(dynamic_content().id, variant().id)
            |> to(eq(:ok))
          )
      )
    end

    context "response status: 404" do
      before(
        do:
          mock(fn %{method: :delete, url: _} -> %Tesla.Env{status: 404} end)
      )

      it(
        do:
          expect(
            Model.DynamicContent.Variant.destroy(dynamic_content().id, variant().id)
            |> to(eq(:error))
          )
      )
    end
  end
end
