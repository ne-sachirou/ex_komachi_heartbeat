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
    stats =
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

    stats = Map.take(stats, ~w[
      erlang_vm_atom_count
      erlang_vm_memory_ets_tables
      erlang_vm_memory_system_bytes_total{usage="atom"}
      erlang_vm_memory_system_bytes_total{usage="binary"}
      erlang_vm_memory_system_bytes_total{usage="code"}
      erlang_vm_memory_system_bytes_total{usage="ets"}
      erlang_vm_memory_system_bytes_total{usage="other"}
      erlang_vm_port_count
      erlang_vm_process_count
    ])

    {:ok, stats}
  end

  @doc "Detect the VM is up, do this is always OK."
  @impl Vital
  def vital, do: :ok
end
