defmodule Mix.Tasks.Test.Examples do
  @moduledoc false

  use Mix.Task

  @shortdoc "Test example applications."

  @impl true
  def run(_) do
    test_plug_example()
    test_phx_example()
  end

  defp test_plug_example do
    File.cd!("examples/plug_example", fn ->
      Mix.Shell.IO.cmd("mix do deps.get, compile")
      Mix.Shell.IO.cmd("mix test --color")

      try do
        {:ok, pid} = Task.start_link(fn -> Mix.Shell.IO.cmd("elixir --no-halt -S mix") end)
        Process.sleep(2000)

        {:ok, {{_, 200, _}, _, 'heartbeat:ok'}} =
          :httpc.request('http://localhost:4000/ops/heartbeat')

        {:ok, {{_, 200, _}, _, '{}'}} = :httpc.request('http://localhost:4000/ops/stats')
        Process.exit(pid, :normal)
      after
        Mix.Shell.IO.cmd("kill $(lsof -i TCP:4000 | tail -n1 | awk '{print$2}')")
        Process.sleep(2000)
      end
    end)
  end

  defp test_phx_example do
    File.cd!("examples/phx_example", fn ->
      Mix.Shell.IO.cmd("mix do deps.get, compile")
      Mix.Shell.IO.cmd("mix test --color")

      try do
        {:ok, pid} = Task.start_link(fn -> Mix.Shell.IO.cmd("mix phx.server") end)
        Process.sleep(2000)

        {:ok, {{_, 200, _}, _, 'heartbeat:ok'}} =
          :httpc.request('http://localhost:4000/ops/heartbeat')

        {:ok, {{_, 200, _}, _, '{}'}} = :httpc.request('http://localhost:4000/ops/stats')
        Process.exit(pid, :normal)
      after
        Mix.Shell.IO.cmd("kill $(lsof -i TCP:4000 | tail -n1 | awk '{print$2}')")
        Process.sleep(2000)
      end
    end)
  end
end
