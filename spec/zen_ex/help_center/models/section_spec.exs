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

  let(:json_error, do: ~s({"error":"RecordNotFound","description":"Not found"}))

  describe "list" do
    before(
      do:
        mock(fn %{method: :get, url: _} ->
          {:ok, %Tesla.Env{status: 200, body: json_sections()}}
        end)
    )

    it(do: expect({:ok, %ZenEx.Collection{}} = Model.Section.list("en-us")))
  end

  describe "show" do
    context "response status: 200" do
      before(
        do:
          mock(fn %{method: :get, url: _} ->
            {:ok, %Tesla.Env{status: 200, body: json_section()}}
          end)
      )

      it(do: expect({:ok, %Section{}} = Model.Section.show("en-us", section().id)))
    end

    context "response status: 404" do
      before(
        do:
          mock(fn %{method: :get, url: _} ->
            {:error, %Tesla.Env{status: 404, body: json_error()}}
          end)
      )

      it(do: expect({:error, _} = Model.Section.show("en-us", section().id)))
    end
  end

  describe "create" do
    context "response status: 201" do
      before(
        do:
          mock(fn %{method: :post, url: _} ->
            {:ok, %Tesla.Env{status: 201, body: json_section()}}
          end)
      )

      it(do: expect({:ok, %Section{}} = Model.Section.create(section())))
    end

    context "response status: 500" do
      before(
        do:
          mock(fn %{method: :post, url: _} ->
            {:error, %Tesla.Env{status: 500, body: ""}}
          end)
      )

      it(do: expect({:error, _} = Model.Section.create(section())))
    end
  end

  describe "update" do
    context "response status: 200" do
      before(
        do:
          mock(fn %{method: :put, url: _} ->
            {:ok, %Tesla.Env{status: 200, body: json_section()}}
          end)
      )

      it(do: expect({:ok, %Section{}} = Model.Section.update(section())))
    end

    context "response status: 500" do
      before(
        do:
          mock(fn %{method: :put, url: _} ->
            {:error, %Tesla.Env{status: 500, body: ""}}
          end)
      )

      it(do: expect({:error, _} = Model.Section.update(section())))
    end
  end

  describe "destroy" do
    context "response status: 204" do
      before(do: mock(fn %{method: :delete, url: _} -> {:ok, %Tesla.Env{status: 204}} end))

      it(do: expect(:ok = Model.Section.destroy(section().id)))
    end

    context "response status: 404" do
      before(
        do:
          mock(fn %{method: :delete, url: _} ->
            {:error, %Tesla.Env{status: 404, body: json_error()}}
          end)
      )

      it(do: expect({:error, _} = Model.Section.destroy(section().id)))
    end
  end
end
