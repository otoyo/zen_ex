defmodule ZenEx.Model.Locale do
  alias ZenEx.Core.Client
  alias ZenEx.Entity.Locale

  @moduledoc """
  Provides functions to operate Zendesk Locale.
  """

  @doc """
  Show locale specified by Either id or bcp-47 code of locale (es-419, en-us, pr-br).

  ## Examples

      iex> ZenEx.Model.Locale.show("ja")
      %ZenEx.Entity.Locale{id: 67, locale: "ja", ...}

  """
  @spec show(integer | String.t) :: %Locale{}
  def show(id) do
    Client.get("/api/v2/locales/#{id}.json") |> __create_locale__
  end


  @doc false
  @spec __create_locale__(%HTTPotion.Response{}) :: %Locale{}
  def __create_locale__(%HTTPotion.Response{} = res) do
    res.body |> Poison.decode!(keys: :atoms, as: %{locale: %Locale{}}) |> Map.get(:locale)
  end
end
