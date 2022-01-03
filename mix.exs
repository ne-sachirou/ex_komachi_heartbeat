defmodule KomachiHeartbeat.MixProject do
  use Mix.Project

  @source_url "https://github.com/ne-sachirou/ex_komachi_heartbeat"
  @version "0.5.1"

  def project do
    [
      app: :komachi_heartbeat,
      version: @version,
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      package: package(),
      test_coverage: [tool: ExCoveralls],
      dialyzer: [
        plt_add_apps: [:inets, :mix],
        flags: [:no_undefined_callbacks],
        remove_defaults: [:unknown]
      ],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.github": :test,
        "coveralls.html": :test
      ]
    ]
  end

  def application, do: [extra_applications: [:logger]]

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:inner_cotton, github: "ne-sachirou/inner_cotton", only: [:dev, :test]},
      {:jason, "~> 1.0", optional: true},
      {:mock, "~> 0.3", only: :test},
      {:plug, "~> 1.5"},
      {:poison, ">= 3.0.0", optional: true}
    ]
  end

  def package do
    [
      name: :komachi_heartbeat,
      description: "Vital monitoring Elixir Web application.",
      licenses: ["GPL-3.0-or-later"],
      maintainers: ["ne_Sachirou <utakata.c4se@gmail.com>"],
      files: [
        "LICENSE",
        "README.md",
        "mix.exs",
        "lib/*.ex",
        "lib/komachi_heartbeat"
      ],
      links: %{GitHub: @source_url}
    ]
  end

  defp docs do
    [
      extras: [
        "CONTRIBUTING.md": [title: "Contributing"],
        "LICENSE": [title: "License"],
        "README.md": [title: "Overview"]
      ],
      main: "readme",
      homepage_url: @source_url,
      source_url: @source_url,
      source_ref: "v#{@version}",
      formatters: ["html"]
    ]
  end
end
