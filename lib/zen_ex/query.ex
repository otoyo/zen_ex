defmodule ZenEx.Query do

  @moduledoc """
  Query for URL
  """

  @params [:ids, :per_page]

  @doc """
  Build query from opts.

  ## Examples

      iex> ZenEx.Query.build(per_page: 100)
      "?per_page=100"

  """
  @spec build(list()) :: String.t
  def build(opts) when is_list(opts) do
    fragments =
      @params
      |> Enum.map(fn(param)->
        case opts[param] do
          nil                         -> nil
          values when is_list(values) -> "#{Atom.to_string(param)}=#{Enum.join(values, ",")}"
          _                           -> "#{Atom.to_string(param)}=#{opts[param]}"
        end
      end)
      |> Enum.reject(&is_nil/1)

    case fragments do
      []  -> ""
      _   -> "?" <> Enum.join(fragments, "&")
    end
  end
end
