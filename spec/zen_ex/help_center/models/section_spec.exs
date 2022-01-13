defmodule ZenEx.HelpCenter.Model.SectionSpec do
  use ESpec

  import Tesla.Mock
  alias ZenEx.HelpCenter.Entity.{Category, Section}
  alias ZenEx.HelpCenter.Model

  let :category do
    struct(Category, %{id: 112_233, name: "My printer is on fire!", locale: "en-us"})
  end

  let :json_sections do
    ~s({"count":2,"sections":[{"id":35436,"name":"Help I need somebody!","locale":"en-us","category_id":112233},{"id":20057623,"name":"Not just anybody!","locale":"en-us","category_id":112233}]})
  end

  let :sections do
    [
      struct(Section, %{
        id: 35436,
        name: "Help I need somebody!",
        locale: "en-us",
        category_id: category().id
      }),
      struct(Section, %{
        id: 20_057_623,
        name: "Not just anybody!",
        locale: "en-us",
        category_id: category().id
      })
    ]
  end

  let(:json_section,
    do:
      ~s({"section":{"id":35436,"name":"My printer is on fire!","locale":"en-us","category_id":112233}})
  )

  let(:section,
    do:
      struct(Section, %{
        id: 35436,
        name: "My printer is on fire!",
        locale: "en-us",
        category_id: category().id
      })
  )

  let(:response_section, do: %Tesla.Env{body: json_section()})
  let(:response_sections, do: %Tesla.Env{body: json_sections()})
  let(:response_204, do: %Tesla.Env{status: 204})
  let(:response_404, do: %Tesla.Env{status: 404})

  describe "list" do
    before(
      do:
        mock(fn %{method: :get, url: _} -> %Tesla.Env{status: 200, body: response_sections()} end)
    )

    it(do: expect(Model.Section.list("en-us") |> to(be_struct(ZenEx.Collection))))
    it(do: expect(Model.Section.list("en-us").entities |> to(eq(sections()))))
    it(do: expect(Model.Section.list("en-us", category().id).entities |> to(eq(sections()))))
  end

  describe "show" do
    before(
      do:
        mock(fn %{method: :get, url: _} -> %Tesla.Env{status: 200, body: response_section()} end)
    )

    it(do: expect(Model.Section.show("en-us", section().id) |> to(eq(section()))))
  end

  describe "create" do
    before(
      do:
        mock(fn %{method: :post, url: _} -> %Tesla.Env{status: 200, body: response_section()} end)
    )

    it(do: expect(Model.Section.create(section()) |> to(be_struct(Section))))
  end

  describe "update" do
    before(
      do:
        mock(fn %{method: :put, url: _} -> %Tesla.Env{status: 200, body: response_section()} end)
    )

    it(do: expect(Model.Section.update(section()) |> to(be_struct(Section))))
  end

  describe "destroy" do
    context "response status: 204" do
      before(
        do:
          mock(fn %{method: :delete, url: _} -> %Tesla.Env{status: 200, body: response_204()} end)
      )

      it(do: expect(Model.Section.destroy(section().id) |> to(eq(:ok))))
    end

    context "response status: 404" do
      before(
        do:
          mock(fn %{method: :delete, url: _} -> %Tesla.Env{status: 200, body: response_404()} end)
      )

      it(do: expect(Model.Section.destroy(section().id) |> to(eq(:error))))
    end
  end
end
