defmodule KomachiHeartbeat.BeamVitalServerTest do
  alias KomachiHeartbeat.BeamVitalServer

  use ExUnit.Case, async: true

  doctest BeamVitalServer

  describe "handle_info/2(:observed)" do
    test "Put a new stats" do
      assert {:noreply, [3, 2]} == BeamVitalServer.handle_info({:observed, 3}, [2, 1])
    end
  end

  describe "observe/0" do
    test "It works" do
      assert %{
               context_switches: _,
               gc: %{count: _, words_reclaimed: _},
               io: %{in: _, out: _},
               reductions: _,
               scheduler_usage: %{}
             } = BeamVitalServer.observe()
    end
  end
end
