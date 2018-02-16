defmodule Example.MixProject do
  use Mix.Project

  def project do
    [
      app: :example,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Example.Application, []}
    ]
  end

  defp deps do
    [
      {:cowboy, "~> 1.1"},
      {:komachi_heartbeat, path: "../.."},
      {:plug, "~> 1.4"}
    ]
  end
end
