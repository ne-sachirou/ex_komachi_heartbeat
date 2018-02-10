defmodule KomachiHeartbeatTest do
  use ExUnit.Case
  doctest KomachiHeartbeat

  test "greets the world" do
    assert KomachiHeartbeat.hello() == :world
  end
end
