defmodule ZenEx.SearchQuery do
  @moduledoc """
  Query for Search API
  """

  @doc """
  Build query from opts.

  ## Examples

      iex> ZenEx.SearchQuery.build(email: "first.last@email.com", foo: "bar")
      "email:first.last@email.com foo:bar"

  """
  @spec build(map()) :: String.t()
  def build(opts) when is_map(opts) do
    fragments =
      opts
      |> Enum.map(fn {k, v} ->
        case v do
          nil -> nil
          values when is_list(values) -> "#{Atom.to_string(k)}:#{Enum.join(values, ",")}"
          _ -> "#{Atom.to_string(k)}:#{v}"
        end
      end)
      |> Enum.reject(&is_nil/1)

    case fragments do
      [] -> ""
      _ -> Enum.join(fragments, " ")
    end
  end
end
