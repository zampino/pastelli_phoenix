defmodule PastelliPhoenix.Mixfile do
  use Mix.Project
  @version "0.1.3"

  def project do
    [app: :pastelli_phoenix,
     version: @version,
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:pastelli, "0.2.4", github: "zampino/pastelli"},
      # {:pastelli, "0.2.4", path: "../pastelli"}
    ]
  end
end
