defmodule ZenEx.Model.LocaleSpec do
  use ESpec

  alias ZenEx.Entity.Locale
  alias ZenEx.Model

  let :json_locale, do: ~s({"locale":{"id":8,"locale":"de","name":"Deutsch"}})
  let :locale, do: struct(Locale, %{id: 8, locale: "de", name: "Deutsch"})

  let :response_locale, do: %HTTPotion.Response{body: json_locale()}

  describe "show" do
    before do: allow HTTPotion |> to(accept :get, fn(_, _) -> response_locale() end)
    it do: expect Model.Locale.show(locale().id) |> to(eq locale())
  end
end
