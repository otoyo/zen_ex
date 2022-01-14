defmodule ZenEx.SearchQuerySpec do
  use ESpec

  alias ZenEx.SearchQuery

  let(:email, do: "first.last@example.com")
  let(:role, do: "agent")

  describe "build" do
    describe "with params" do
      subject(do: SearchQuery.build(%{email: email(), role: role()}))
      it(do: is_expected() |> to(eq("email:first.last@example.com role:agent")))
    end

    describe "without params" do
      subject(do: SearchQuery.build(%{}))
      it(do: is_expected() |> to(eq("")))
    end

    describe "with nil params" do
      subject(do: SearchQuery.build(%{foo: nil}))
      it(do: is_expected() |> to(eq("")))
    end
  end
end
