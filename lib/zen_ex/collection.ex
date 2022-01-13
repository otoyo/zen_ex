defmodule ZenEx.Collection do

  @moduledoc """
  Colletion for multiple entities and pagination
  """

  alias ZenEx.{HTTPClient, Collection}

  @derive Jason.Encoder
defstruct [:entities, :count, :next_page, :previous_page, :decode_as]

  @doc """
  Get next page.

  ## Examples

      iex> collection = ZenEx.Model.User.list
      iex> ZenEx.Collection.next(collection)
      %ZenEx.Collection{entities: [%ZenEx.Entity.User{}, ...], count: xxx}

  """
  @spec next(%Collection{}) :: %ZenEx.Collection{}
  def next(%Collection{next_page: url, decode_as: as}), do: HTTPClient.get(url, as)


  @doc """
  Get previous page.

  ## Examples

      iex> ZenEx.Collection.prev(collection)
      %ZenEx.Collection{entities: [%ZenEx.Entity.User{}, ...], count: xxx}

  """
  @spec prev(%Collection{}) :: %ZenEx.Collection{}
  def prev(%Collection{previous_page: url, decode_as: as}), do: HTTPClient.get(url, as)
end
