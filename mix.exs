defmodule ZenEx.Mixfile do
  use Mix.Project

  @description """
  Zendesk REST API client for Elixir
  """

  def project do
    [
      app: :zen_ex,
      version: "0.6.0",
      elixir: "~> 1.7",
      description: @description,
      package: package(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      preferred_cli_env: [espec: :test],
      deps: deps()
    ]
  end

  defp package do
    [
      maintainers: ["otoyo"],
      licenses: ["CC0-1.0"],
      links: %{"Github" => "https://github.com/otoyo/zen_ex"}
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.2", only: [:dev, :test], runtime: false},
      {:earmark, "~> 1.4.3", only: :dev, runtime: false},
      {:espec, "~> 1.9", only: :test},
      {:ex_doc, "~> 0.29.1", only: :dev, runtime: false},
      {:poison, "~> 5.0"},
      {:tesla, "~> 1.5"},
      {:hackney, "~> 1.18"},
      {:jason, "~> 1.4"}
    ]
  end
end
