defmodule Zendex.Model.LocaleSpec do
  use ESpec

  alias Zendex.Core.Client
  alias Zendex.Entity.Locale
  alias Zendex.Model

  let :json_locale, do: ~s({"locale":{"id":8,"locale":"de","name":"Deutsch"}})
  let :locale, do: struct(Locale, %{id: 8, locale: "de", name: "Deutsch"})

  let :response_locale, do: %HTTPotion.Response{body: json_locale()}

  describe "show" do
    before do: allow Client |> to(accept :get, fn(_) -> response_locale() end)
    it do: expect Model.Locale.show(locale().id) |> to(eq locale())
  end

  describe "__create_locale__" do
    subject do: Model.Locale.__create_locale__ response_locale()
    it do: is_expected() |> to(eq locale())
  end
end
