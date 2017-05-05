defmodule ZenEx.Model.DynamicContent.VariantSpec do
  use ESpec

  alias ZenEx.Core.Client
  alias ZenEx.Entity.DynamicContent.Variant
  alias ZenEx.Entity.{DynamicContent,JobStatus}
  alias ZenEx.Model

  let :json_variants do
    ~s({"variants":[{"id":223443,"content":"Mail address","locale_id":1},{"id":8678530,"content":"メールアドレス","locale_id":67}]})
  end
  let :variants do
    [struct(Variant, %{id: 223443, content: "Mail address", locale_id: 1}), struct(Variant, %{id: 8678530, content: "メールアドレス", locale_id: 67})]
  end

  let :json_variant, do: ~s({"variant":{"id":223443,"content":"Mail address","locale_id":1}})
  let :variant, do: struct(Variant, %{id: 223443, content: "Mail address", locale_id: 1})

  let :json_job_status do
    ~s({"job_status":{"id":"8b726e606741012ffc2d782bcb7848fe","status":"completed"}})
  end
  let :job_status do
    struct(JobStatus, %{id: "8b726e606741012ffc2d782bcb7848fe", status: "completed"})
  end

  let :dynamic_content do
    struct(DynamicContent, %{id: 112233, name: "mail-address", default_locale_id: 1})
  end

  let :response_variant, do: %HTTPotion.Response{body: json_variant()}
  let :response_variants, do: %HTTPotion.Response{body: json_variants()}
  let :response_job_status, do: %HTTPotion.Response{body: json_job_status()}
  let :response_204, do: %HTTPotion.Response{status_code: 204}
  let :response_404, do: %HTTPotion.Response{status_code: 404}

  describe "list" do
    before do: allow Client |> to(accept :get, fn(_) -> response_variants() end)
    it do: expect Model.DynamicContent.Variant.list(dynamic_content().id) |> to(eq variants())
  end

  describe "show" do
    before do: allow Client |> to(accept :get, fn(_) -> response_variant() end)
    it do: expect Model.DynamicContent.Variant.show(dynamic_content().id, variant().id) |> to(eq variant())
  end

  describe "create" do
    before do: allow Client |> to(accept :post, fn(_, _) -> response_variant() end)
    it do: expect Model.DynamicContent.Variant.create(dynamic_content().id, variant()) |> to(be_struct Variant)
  end

  describe "create_many" do
    before do: allow Client |> to(accept :post, fn(_, _) -> response_job_status() end)
    it do: expect Model.DynamicContent.Variant.create_many(dynamic_content().id, variants()) |> to(be_struct JobStatus)
  end

  describe "update" do
    before do: allow Client |> to(accept :put, fn(_, _) -> response_variant() end)
    it do: expect Model.DynamicContent.Variant.update(dynamic_content().id, variant()) |> to(be_struct Variant)
  end

  describe "update_many" do
    before do: allow Client |> to(accept :put, fn(_, _) -> response_job_status() end)
    it do: expect Model.DynamicContent.Variant.update_many(dynamic_content().id, variants()) |> to(be_struct JobStatus)
  end

  describe "destroy" do
    context "response status_code: 204" do
      before do: allow Client |> to(accept :delete, fn(_) -> response_204() end)
      it do: expect Model.DynamicContent.Variant.destroy(dynamic_content().id, variant().id) |> to(eq :ok)
    end
    context "response status_code: 404" do
      before do: allow Client |> to(accept :delete, fn(_) -> response_404() end)
      it do: expect Model.DynamicContent.Variant.destroy(dynamic_content().id, variant().id) |> to(eq :error)
    end
  end

  describe "__create_variants__" do
    context "args as response" do
      subject do: Model.DynamicContent.Variant.__create_variants__ response_variants()
      it do: is_expected() |> to(eq variants())
    end
    context "args as map" do
      subject do: Model.DynamicContent.Variant.__create_variants__ Enum.map(variants(), &Map.from_struct/1)
      it do: is_expected() |> to(eq variants())
    end
  end

  describe "__create_variant__" do
    context "args as response" do
      subject do: Model.DynamicContent.Variant.__create_variant__ response_variant()
      it do: is_expected() |> to(eq variant())
    end
    context "args as map" do
      subject do: Model.DynamicContent.Variant.__create_variant__ Map.from_struct(variant())
      it do: is_expected() |> to(eq variant())
    end
  end
end
