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
      start_permanent: Mix.env() == :prod,
      version: "0.1.0"
    ]
  end

  def application, do: [extra_applications: [:logger]]

  defp deps do
    [
      {:inner_cotton, github: "ne-sachirou/inner_cotton", only: [:dev, :test]},
      {:plug, "~> 1.4"},
      {:poison, "~> 3.1"}
    ]
  end
end
