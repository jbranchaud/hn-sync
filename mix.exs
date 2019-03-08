defmodule NewsSync.MixProject do
  use Mix.Project

  def project do
    [
      app: :hn_sync,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      applications: [:httpoison],
      extra_applications: [:logger],
      mod: {NewsSync.Application, []}
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.4"},
      {:poison, "~> 3.1"}
    ]
  end
end
