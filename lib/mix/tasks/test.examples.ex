defmodule Mix.Tasks.Test.Examples do
  @moduledoc """
  Test example applications.
  """

  use Mix.Task

  @shortdoc "Test example applications."

  def run(_) do
    test_plug__example()
    test_phx_example()
  end

  defp test_plug__example do
    File.cd!("examples/plug_example", fn ->
      Mix.Shell.IO.cmd("mix do deps.get, compile")
      Mix.Shell.IO.cmd("mix test --color")

      try do
        {:ok, pid} = Task.start_link(fn -> Mix.Shell.IO.cmd("elixir --no-halt -S mix") end)
        Process.sleep(1000)
        {:ok, {{_, 200, _}, _, 'ok'}} = :httpc.request('http://localhost:4000/ops/heartbeat')
        {:ok, {{_, 200, _}, _, '{}'}} = :httpc.request('http://localhost:4000/ops/stats')
        Process.exit(pid, :normal)
      after
        Mix.Shell.IO.cmd("kill $(lsof -i TCP:4000 | tail -n1 | awk '{print$2}')")
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
        {:ok, {{_, 200, _}, _, 'ok'}} = :httpc.request('http://localhost:4000/ops/heartbeat')
        {:ok, {{_, 200, _}, _, '{}'}} = :httpc.request('http://localhost:4000/ops/stats')
        Process.exit(pid, :normal)
      after
        Mix.Shell.IO.cmd("kill $(lsof -i TCP:4000 | tail -n1 | awk '{print$2}')")
      end
    end)
  end
end
