defmodule PastelliPhoenix.Mixfile do
  use Mix.Project
  @version "0.1.1"

  def project do
    [app: :pastelli_phoenix,
     version: @version,
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      # {:pastelli, "0.2.3", path: "../pastelli" }, #
      {:pastelli, "0.2.3", github: "zampino/pastelli"},
    ]
  end
end
