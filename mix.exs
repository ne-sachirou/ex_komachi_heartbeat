defmodule KomachiHeartbeat.MixProject do
  use Mix.Project

  def project do
    [
      app: :komachi_heartbeat,
      deps: deps(),
      description: "Vital monitoring Elixir Web application.",
      dialyzer: [
        plt_add_apps: [:inets, :mix]
      ],
      elixir: "~> 1.5",
      package: package(),
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      version: "0.2.0",

      # Docs
      docs: [
        main: "readme",
        extras: ["README.md"]
      ],
      homepage_url: "https://github.com/ne-sachirou/ex_komachi_heartbeat",
      name: "KomachiHeartbeat",
      source_url: "https://github.com/ne-sachirou/ex_komachi_heartbeat"
    ]
  end

  def application, do: [extra_applications: [:logger]]

  defp deps do
    [
      {:ex_doc, "~> 0.18", only: :dev, runtime: false},
      {:inner_cotton, github: "ne-sachirou/inner_cotton", only: [:dev, :test]},
      {:mock, "~> 0.3", only: :test},
      {:plug, "~> 1.5"},
      {:poison, "~> 3.1"}
    ]
  end

  def package do
    [
      files: ["LICENSE", "README.md", "mix.exs", "lib/*.ex", "lib/komachi_heartbeat"],
      licenses: ["GPL-3.0-or-later"],
      links: %{
        GitHub: "https://github.com/ne-sachirou/ex_komachi_heartbeat"
      },
      maintainers: ["ne_Sachirou <utakata.c4se@gmail.com>"],
      name: :komachi_heartbeat
    ]
  end
end
