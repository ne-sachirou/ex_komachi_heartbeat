defmodule KomachiHeartbeat.BeamVital do
  @moduledoc """
  """

  alias KomachiHeartbeat.{BeamVitalExporter, Vital}

  @behaviour Vital

  @doc ""
  @impl Vital
  def init do
    {:ok, _} = Application.ensure_all_started(:prometheus_plugs)
    BeamVitalExporter.setup()
  end

  @doc ""
  @impl Vital
  def stats do
    original_stats =
      BeamVitalExporter.call(Plug.Test.conn(:get, "/metrics"), []).resp_body
      |> String.split("\n", trim: true)
      |> Enum.reduce(%{}, fn
        "#" <> _, stats ->
          stats

        "erlang_vm_allocators{" <> _, stats ->
          stats

        line, stats ->
          [k, v] = Regex.split(~r{[\d.]+$}, line, include_captures: true, trim: true)

          v =
            case Integer.parse(v) do
              {v_as_integer, ""} ->
                v_as_integer

              _ ->
                case Float.parse(v) do
                  {v_as_float, ""} -> v_as_float
                  _ -> nil
                end
            end

          if is_nil(v), do: stats, else: put_in(stats[String.trim(k)], v)
      end)

    stats = %{
      "atom_count" => original_stats["erlang_vm_atom_count"],
      "port_count" => original_stats["erlang_vm_port_count"],
      "process_count" => original_stats["erlang_vm_process_count"],
      "memory" => %{
        "atom" => original_stats[~s(erlang_vm_memory_system_bytes_total{usage="atom"})],
        "binary" => original_stats[~s(erlang_vm_memory_system_bytes_total{usage="binary"})],
        "code" => original_stats[~s(erlang_vm_memory_system_bytes_total{usage="code"})],
        "ets" => original_stats[~s(erlang_vm_memory_system_bytes_total{usage="ets"})],
        "other" => original_stats[~s(erlang_vm_memory_system_bytes_total{usage="other"})]
      }
    }

    {:ok, stats}
  end

  @doc "Detect the VM is up, do this is always OK."
  @impl Vital
  def vital, do: :ok
end
