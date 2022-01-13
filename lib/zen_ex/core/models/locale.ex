defmodule ZenEx.Model.Locale do
  alias ZenEx.HTTPClient
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
  @spec show(integer | String.t()) :: %Locale{} | {:error, String.t()}
  def show(id) do
    HTTPClient.get("/api/v2/locales/#{id}.json", locale: Locale)
  end
end
