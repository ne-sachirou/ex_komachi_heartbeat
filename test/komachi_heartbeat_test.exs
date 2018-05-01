defmodule KomachiHeartbeatTest do
  alias KomachiHeartbeat.RootVital

  import Mock

  use ExUnit.Case, async: false
  use Plug.Test

  doctest KomachiHeartbeat

  describe "get /heartbeat" do
    test "GET /heartbeat" do
      conn = conn(:get, "/heartbeat")
      assert {200, _, "heartbeat:ok"} = sent_resp(KomachiHeartbeat.call(conn, []))
    end

    test_with_mock "GET /heartbeat when :error", RootVital, [:passthrough],
      vital: fn -> :error end do
      conn = conn(:get, "/heartbeat")
      assert {503, _, "heartbeat:NG"} = sent_resp(KomachiHeartbeat.call(conn, []))
      assert called(RootVital.vital())
    end
  end

  describe "get /stats" do
    test "GET /stats" do
      conn = conn(:get, "/stats")
      assert {200, _, "{}"} = sent_resp(KomachiHeartbeat.call(conn, []))
    end

    test_with_mock "GET /stats when :error", RootVital, [:passthrough],
      stats: fn -> {:error, %{}} end do
      conn = conn(:get, "/stats")
      assert {503, _, "{}"} = sent_resp(KomachiHeartbeat.call(conn, []))
      assert called(RootVital.stats())
    end
  end

  test "GET /not_found" do
    conn = conn(:get, "/not_found")
    assert {404, _, ""} = sent_resp(KomachiHeartbeat.call(conn, []))
  end
end
