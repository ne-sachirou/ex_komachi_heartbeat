defmodule KomachiHeartbeatTest do
  use ExUnit.Case
  use Plug.Test

  doctest KomachiHeartbeat

  describe "init/1" do
    test ":path has given", do: assert([path: "/ops"] === KomachiHeartbeat.init(path: "/ops"))

    test "Set default :path", do: assert([path: "/"] === KomachiHeartbeat.init([]))
  end

  describe "call/2" do
    test "ok: get,/ops/heartbeat" do
      conn = conn(:get, "/ops/heartbeat")
      assert {200, _, "ok"} = sent_resp(KomachiHeartbeat.call(conn, path: "/ops"))
    end

    for params <- [
          [:post, "/ops/heartbeat", nil],
          [:get, "/ops/heartbeats", nil],
          [:get, "/opss/heartbeat", nil]
        ] do
      @tag params: params
      test "Pass through: #{Enum.join(params, ",")}", %{params: params} do
        conn = apply(&conn/3, params)
        assert(conn === KomachiHeartbeat.call(conn, path: "/ops"))
      end
    end

    test "When :path isn't /ops" do
      conn = conn(:get, "/ops/heartbeat")
      assert conn === KomachiHeartbeat.call(conn, path: "/opss")
    end
  end
end
