defmodule ZenEx.QuerySpec do
  use ESpec

  alias ZenEx.Query

  let :ids, do: [1, 2, 3]
  let :per_page, do: 100

  describe "build" do
    describe "with params" do
      subject do: Query.build(ids: ids(), per_page: per_page())
      it do: is_expected() |> to(eq "?ids=1,2,3&per_page=100")
    end

    describe "without params" do
      subject do: Query.build([])
      it do: is_expected() |> to(eq "")
    end
  end
end
