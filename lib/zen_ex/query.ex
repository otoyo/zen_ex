defmodule ZenEx.Query do
  @moduledoc """
  Query for URL
  """

  @doc """
  Build query from opts.

  ## Examples

      iex> ZenEx.Query.build(per_page: 100)
      "?per_page=100"

  """
  @spec build(list()) :: String.t()
  def build(opts) when is_list(opts) do
    fragments =
      opts
      |> Enum.map(fn {k, v} ->
        case v do
          nil -> nil
          values when is_list(values) -> "#{Atom.to_string(k)}=#{Enum.join(values, ",")}"
          _ -> "#{Atom.to_string(k)}=#{v}"
        end
      end)
      |> Enum.reject(&is_nil/1)

    case fragments do
      [] -> ""
      _ -> "?" <> Enum.join(fragments, "&")
    end
  end
end
