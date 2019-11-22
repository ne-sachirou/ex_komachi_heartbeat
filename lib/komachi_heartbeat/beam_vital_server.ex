defmodule KomachiHeartbeat.BeamVitalServer do
  @moduledoc """
  Collect BEAM stats which depend on time.
  """

  use GenServer

  @impl GenServer
  def init(_) do
    send(self(), :observe)
    {:ok, _} = :timer.send_interval(1_000 * 60, :observe)

    state = [
      %{
        context_switches: 0,
        gc: %{count: 0, words_reclaimed: 0},
        io: %{in: 0, out: 0},
        reductions: 0,
        scheduler_usage: []
      },
      %{
        context_switches: 0,
        gc: %{count: 0, words_reclaimed: 0},
        io: %{in: 0, out: 0},
        reductions: 0,
        scheduler_usage: []
      }
    ]

    {:ok, state}
  end

  @impl GenServer
  def handle_call(:stats, _, [state_item_new, state_item_old] = state) do
    stats = %{
      context_switches: state_item_new.context_switches - state_item_old.context_switches,
      gc: %{
        count: state_item_new.gc.count - state_item_old.gc.count,
        words_reclaimed: state_item_new.gc.words_reclaimed - state_item_old.gc.words_reclaimed
      },
      io: %{
        in: state_item_new.io.in - state_item_old.io.in,
        out: state_item_new.io.out - state_item_old.io.out
      },
      reductions: state_item_new.reductions - state_item_old.reductions,
      scheduler_usage: state_item_new.scheduler_usage
    }

    {:reply, stats, state}
  end

  @impl GenServer
  def handle_info(:observe, state) do
    me = self()

    Task.start_link(fn ->
      {context_switches, 0} = :erlang.statistics(:context_switches)
      {number_of_gcs, words_reclaimed, 0} = :erlang.statistics(:garbage_collection)
      {{:input, input}, {:output, output}} = :erlang.statistics(:io)
      {total_reductions, _} = :erlang.statistics(:reductions)

      former_flag = :erlang.system_flag(:scheduler_wall_time, true)
      scheduler_wall_time_1 = :erlang.statistics(:scheduler_wall_time)
      Process.sleep(1_000)
      scheduler_wall_time_2 = :erlang.statistics(:scheduler_wall_time)
      :erlang.system_flag(:scheduler_wall_time, former_flag)

      scheduler_usage =
        scheduler_wall_time_1
        |> Enum.sort_by(&elem(&1, 0))
        |> Enum.zip(Enum.sort_by(scheduler_wall_time_2, &elem(&1, 0)))
        |> Enum.reject(&match?({{_, active_time, _}, {_, active_time, _}}, &1))
        |> Enum.map(fn {{scheduler_id, active_time_1, total_time_1},
                        {scheduler_id, active_time_2, total_time_2}} ->
          {scheduler_id, (active_time_2 - active_time_1) / (total_time_2 - total_time_1)}
        end)
        |> Map.new()

      state_item = %{
        context_switches: context_switches,
        gc: %{count: number_of_gcs, words_reclaimed: words_reclaimed},
        io: %{in: input, out: output},
        reductions: total_reductions,
        scheduler_usage: scheduler_usage
      }

      send(me, {:observed, state_item})
    end)

    {:noreply, state}
  end

  def handle_info({:observed, state_item_new}, [state_item_old, _]),
    do: {:noreply, [state_item_new, state_item_old]}
end
