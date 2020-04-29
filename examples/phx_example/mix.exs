defmodule Example.Mixfile do
  use Mix.Project

  def project do
    [
      app: :example,
      version: "0.0.1",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Example.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  defp deps do
    [
      {:cowboy, "~> 2.0"},
      {:gettext, "~> 0.15"},
      {:komachi_heartbeat, path: "../.."},
      {:plug_cowboy, "~> 2.0"},
      {:phoenix, "~> 1.5.0"},
      {:phoenix_pubsub, "~> 2.0"},
      {:poison, "~> 4.0"}
    ]
  end
end
