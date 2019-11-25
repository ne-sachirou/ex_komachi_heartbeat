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
  def stats, do: {:ok, Map.merge(momentary_stats(), aggregated_stats())}

  @doc "Detect the VM is up, so this is always OK."
  @impl Vital
  def vital, do: :ok

  @spec aggregated_stats :: Vital.stats()
  def aggregated_stats do
    aggregated = GenServer.call(BeamVitalServer, :stats)

    stats = %{
      "context_switches" => aggregated.context_switches,
      "gc" => %{
        "count" => aggregated.gc.count,
        "words_reclaimed" => aggregated.gc.words_reclaimed
      },
      "io" => %{"in" => aggregated.io.in, "out" => aggregated.io.out},
      "reductions" => aggregated.reductions
    }

    stats =
      if %{} == aggregated.scheduler_usage,
        do: stats,
        else: put_in(stats["scheduler_usage"], aggregated.scheduler_usage)

    stats
  end

  @spec momentary_stats :: Vital.stats()
  def momentary_stats do
    memory = :erlang.memory()

    stats = %{
      "memory" => %{
        "atom" => memory[:atom_used],
        "binary" => memory[:binary],
        "code" => memory[:code],
        "ets" => memory[:ets],
        "processes" => memory[:processes_used]
      },
      "port_count" => length(Port.list()),
      "process_count" => :erlang.system_info(:process_count),
      "run_queue" => :erlang.statistics(:run_queue)
    }

    stats =
      case Process.whereis(:error_logger) do
        pid when is_pid(pid) ->
          put_in(stats["error_logger_queue_len"], Process.info(pid, :message_queue_len))

        _ ->
          stats
      end

    stats
  end
end
