defmodule KomachiHeartbeat.MixProject do
  use Mix.Project

  def project do
    [
      app: :komachi_heartbeat,
      deps: deps(),
      dialyzer: [
        plt_add_apps: [:inets, :mix]
      ],
      elixir: "~> 1.5",
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      version: "0.1.0"
    ]
  end

  def application, do: [extra_applications: [:logger]]

  defp deps do
    [
      {:inner_cotton, github: "ne-sachirou/inner_cotton", only: [:dev, :test]},
      {:mock, "~> 0.3", only: :test},
      {:plug, "~> 1.4"},
      {:poison, "~> 3.1"}
    ]
  end
end
