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

  let(:json_error, do: ~s({"error":"RecordNotFound","description":"Not found"}))

  describe "list" do
    before(
      do:
        mock(fn %{method: :get, url: _} ->
          {:ok, %Tesla.Env{status: 200, body: json_variants()}}
        end)
    )

    it(
      do:
        expect(
          {:ok, %ZenEx.Collection{}} = Model.DynamicContent.Variant.list(dynamic_content().id)
        )
    )
  end

  describe "show" do
    context "response status: 200" do
      before(
        do:
          mock(fn %{method: :get, url: _} ->
            {:ok, %Tesla.Env{status: 200, body: json_variant()}}
          end)
      )

      it(
        do:
          expect(
            {:ok, %Variant{}} =
              Model.DynamicContent.Variant.show(dynamic_content().id, variant().id)
          )
      )
    end

    context "response status: 404" do
      before(
        do:
          mock(fn %{method: :get, url: _} ->
            {:error, %Tesla.Env{status: 404, body: json_error()}}
          end)
      )

      it(
        do:
          expect(
            {:error, _} = Model.DynamicContent.Variant.show(dynamic_content().id, variant().id)
          )
      )
    end
  end

  describe "create" do
    context "response status: 201" do
      before(
        do:
          mock(fn %{method: :post, url: _} ->
            {:ok, %Tesla.Env{status: 201, body: json_variant()}}
          end)
      )

      it(
        do:
          expect(
            {:ok, %Variant{}} =
              Model.DynamicContent.Variant.create(dynamic_content().id, variant())
          )
      )
    end

    context "response status: 500" do
      before(
        do:
          mock(fn %{method: :post, url: _} ->
            {:error, %Tesla.Env{status: 500, body: ""}}
          end)
      )

      it(
        do:
          expect(
            {:error, _} = Model.DynamicContent.Variant.create(dynamic_content().id, variant())
          )
      )
    end
  end

  describe "create_many" do
    context "response status: 201" do
      before(
        do:
          mock(fn %{method: :post, url: _} ->
            %Tesla.Env{status: 201, body: json_job_status()}
          end)
      )

      it(
        do:
          expect(
            {:ok, %JobStatus{}} =
              Model.DynamicContent.Variant.create_many(dynamic_content().id, variants())
          )
      )
    end

    context "response status: 500" do
      before(
        do:
          mock(fn %{method: :post, url: _} ->
            {:error, %Tesla.Env{status: 500, body: ""}}
          end)
      )

      it(
        do:
          expect(
            {:error, _} =
              Model.DynamicContent.Variant.create_many(dynamic_content().id, variants())
          )
      )
    end
  end

  describe "update" do
    context "response status: 200" do
      before(
        do:
          mock(fn %{method: :put, url: _} ->
            {:ok, %Tesla.Env{status: 200, body: json_variant()}}
          end)
      )

      it(
        do:
          expect(
            {:ok, %Variant{}} =
              Model.DynamicContent.Variant.update(dynamic_content().id, variant())
          )
      )
    end

    context "response status: 500" do
      before(
        do:
          mock(fn %{method: :put, url: _} ->
            {:error, %Tesla.Env{status: 500, body: ""}}
          end)
      )

      it(
        do:
          expect(
            {:error, _} = Model.DynamicContent.Variant.update(dynamic_content().id, variant())
          )
      )
    end
  end

  describe "update_many" do
    context "response status: 200" do
      before(
        do:
          mock(fn %{method: :put, url: _} ->
            {:ok, %Tesla.Env{status: 200, body: json_job_status()}}
          end)
      )

      it(
        do:
          expect(
            {:ok, %JobStatus{}} =
              Model.DynamicContent.Variant.update_many(dynamic_content().id, variants())
          )
      )
    end

    context "response status: 500" do
      before(
        do:
          mock(fn %{method: :put, url: _} ->
            {:error, %Tesla.Env{status: 500, body: ""}}
          end)
      )

      it(
        do:
          expect(
            {:error, _} =
              Model.DynamicContent.Variant.update_many(dynamic_content().id, variants())
          )
      )
    end
  end

  describe "destroy" do
    context "response status: 204" do
      before(do: mock(fn %{method: :delete, url: _} -> {:ok, %Tesla.Env{status: 204}} end))

      it(
        do: expect(:ok = Model.DynamicContent.Variant.destroy(dynamic_content().id, variant().id))
      )
    end

    context "response status: 404" do
      before(
        do:
          mock(fn %{method: :delete, url: _} ->
            {:error, %Tesla.Env{status: 404, body: json_error()}}
          end)
      )

      it(
        do:
          expect(
            {:error, _} = Model.DynamicContent.Variant.destroy(dynamic_content().id, variant().id)
          )
      )
    end
  end
end
