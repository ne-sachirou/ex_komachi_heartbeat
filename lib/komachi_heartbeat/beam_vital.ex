defmodule KomachiHeartbeat.BeamVital do
  @moduledoc """
  Watch the BEAM VM statistics.
  """

  alias KomachiHeartbeat.{BeamVitalServer, Vital}

  @behaviour Vital

  @doc "Start a server to collect BEAM stats."
  @impl Vital
  def init do
    case GenServer.start_link(BeamVitalServer, [], name: BeamVitalServer) do
      {:ok, _} -> nil
      {:error, {:already_started, _}} -> nil
      error -> raise "Can't start KomachiHeartbeat.BeamVitalServer by #{inspect(error)}"
    end
  end

  @doc "Return the BEAM stats."
  @impl Vital
  def stats do
    memory = :erlang.memory()
    aggregated = GenServer.call(BeamVitalServer, :stats)

    stats = %{
      "context_switches" => aggregated.context_switches,
      "gc" => %{
        "count" => aggregated.gc.count,
        "words_reclaimed" => aggregated.gc.words_reclaimed
      },
      "io" => %{"in" => aggregated.io.in, "out" => aggregated.io.out},
      "memory" => %{
        "atom" => memory[:atom_used],
        "binary" => memory[:binary],
        "code" => memory[:code],
        "ets" => memory[:ets],
        "processes" => memory[:processes_used]
      },
      "port_count" => length(Port.list()),
      "process_count" => :erlang.system_info(:process_count),
      "reductions" => aggregated.reductions,
      "run_queue" => :erlang.statistics(:run_queue)
    }

    stats =
      case Process.whereis(:error_logger) do
        pid when is_pid(pid) ->
          put_in(stats["error_logger_queue_len"], Process.info(pid, :message_queue_len))

        _ ->
          stats
      end

    stats =
      case aggregated.scheduler_usage do
        [] -> stats
        scheduler_usage -> put_in(stats["scheduler_usage"], scheduler_usage)
      end

    {:ok, stats}
  end

  @doc "Detect the VM is up, so this is always OK."
  @impl Vital
  def vital, do: :ok
end
