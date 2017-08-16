defmodule ZenEx.QuerySpec do
  use ESpec

  alias ZenEx.Query

  let :ids, do: [1, 2, 3]
  let :per_page, do: 100
  let :role, do: "agent"

  describe "build" do
    describe "with params" do
      subject do: Query.build(ids: ids(), per_page: per_page(), role: role())
      it do: is_expected() |> to(eq "?ids=1,2,3&per_page=100&role=agent")
    end

    describe "without params" do
      subject do: Query.build([])
      it do: is_expected() |> to(eq "")
    end

    describe "with nil params" do
      subject do: Query.build([foo: nil])
      it do: is_expected() |> to(eq "")
    end
  end
end
