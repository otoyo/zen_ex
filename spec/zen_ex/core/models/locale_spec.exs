defmodule ZenEx.Model.LocaleSpec do
  use ESpec

  import Tesla.Mock
  alias ZenEx.Entity.Locale
  alias ZenEx.Model

  let(:json_locale, do: ~s({"locale":{"id":8,"locale":"de","name":"Deutsch"}}))
  let(:locale, do: struct(Locale, %{id: 8, locale: "de", name: "Deutsch"}))

  describe "show" do
    before(
      do: mock(fn %{method: :get, url: _} -> %Tesla.Env{status: 200, body: json_locale()} end)
    )

    it(do: expect(Model.Locale.show(locale().id) |> to(eq(locale()))))
  end
end
