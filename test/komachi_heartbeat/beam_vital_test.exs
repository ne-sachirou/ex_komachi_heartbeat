defmodule KomachiHeartbeat.BeamVitalTest do
  alias KomachiHeartbeat.BeamVital

  use ExUnit.Case, async: true

  doctest BeamVital

  describe "init/0" do
    test "already_started", do: assert(is_nil(BeamVital.init()))
  end

  describe "stats/0" do
    test "ok", do: assert({:ok, %{}} = BeamVital.stats())
  end

  describe "vital/0" do
    test "ok", do: assert(:ok == BeamVital.vital())
  end

  describe "aggregated_stats/0" do
    test "It works" do
      assert %{
               "context_switches" => _,
               "gc" => %{
                 "count" => _,
                 "words_reclaimed" => _
               },
               "io" => %{"in" => _, "out" => _},
               "reductions" => _
             } = BeamVital.aggregated_stats()
    end
  end

  describe "momentary_stats/0" do
    test "It works" do
      assert %{
               "memory" => %{
                 "atom" => _,
                 "binary" => _,
                 "code" => _,
                 "ets" => _,
                 "processes" => _
               },
               "port_count" => _,
               "process_count" => _,
               "run_queue" => _
             } = BeamVital.momentary_stats()
    end
  end
end
