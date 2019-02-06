defmodule KomachiHeartbeat.MixProject do
  use Mix.Project

  @github "https://github.com/ne-sachirou/ex_komachi_heartbeat"

  def project do
    [
      app: :komachi_heartbeat,
      deps: deps(),
      description: "Vital monitoring Elixir Web application.",
      dialyzer: [
        plt_add_apps: [:inets, :mix],
        flags: [:no_undefined_callbacks],
        remove_defaults: [:unknown]
      ],
      elixir: "~> 1.7",
      package: package(),
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.travis": :test,
        "coveralls.html": :test
      ],
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      version: "0.3.0",

      # Docs
      docs: [
        main: "readme",
        extras: ["README.md"]
      ],
      homepage_url: @github,
      name: "KomachiHeartbeat",
      source_url: @github
    ]
  end

  def application, do: [extra_applications: [:logger]]

  defp deps do
    [
      {:ex_doc, "~> 0.18", only: :dev, runtime: false},
      {:inner_cotton, github: "ne-sachirou/inner_cotton", only: [:dev, :test]},
      {:mock, "~> 0.3", only: :test},
      {:plug, "~> 1.5"},
      {:poison, "~> 4.0"}
    ]
  end

  def package do
    [
      files: ["LICENSE", "README.md", "mix.exs", "lib/*.ex", "lib/komachi_heartbeat"],
      licenses: ["GPL-3.0-or-later"],
      links: %{GitHub: @github},
      maintainers: ["ne_Sachirou <utakata.c4se@gmail.com>"],
      name: :komachi_heartbeat
    ]
  end
end
