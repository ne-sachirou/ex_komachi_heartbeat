defmodule KomachiHeartbeatTest do
  alias KomachiHeartbeat.Vital

  use ExUnit.Case
  use Plug.Test

  doctest KomachiHeartbeat

  describe "get /heartbeat" do
    test "GET /heartbeat" do
      conn = conn(:get, "/heartbeat")
      assert {200, _, "ok"} = sent_resp(KomachiHeartbeat.call(conn, []))
    end
  end

  describe "get /stats" do
    test "GET /stats" do
      conn = conn(:get, "/stats")
      assert {200, _, "{}"} = sent_resp(KomachiHeartbeat.call(conn, []))
    end
  end

  test "GET /not_found" do
    conn = conn(:get, "/not_found")
    assert {404, _, ""} = sent_resp(KomachiHeartbeat.call(conn, []))
  end

  describe "stats/0" do
    test "Default is {:ok, %{}}", do: assert({:ok, %{}} === KomachiHeartbeat.stats([]))

    test ":ok when all vitals are :ok" do
      defmodule Example.StatsOk1 do
        @behaviour Vital

        def stats, do: :ok
      end

      assert {:ok, %{Example.StatsOk1 => :ok}} === KomachiHeartbeat.stats([Example.StatsOk1])
    end

    test ":ok & collect stats when all vitals are :ok" do
      defmodule Example.StatsOk2 do
        @behaviour Vital

        def stats, do: {:ok, 42}
      end

      assert {:ok, %{Example.StatsOk2 => 42}} === KomachiHeartbeat.stats([Example.StatsOk2])
    end

    test ":error when some vital is :error" do
      defmodule Example.StatsError1 do
        @behaviour Vital

        def stats, do: :error
      end

      assert {:error, %{Example.StatsError1 => :error}} ===
               KomachiHeartbeat.stats([Example.StatsError1])
    end

    test ":error & collect stats when some vital is :error" do
      defmodule Example.StatsError2 do
        @behaviour Vital

        def stats, do: {:error, 42}
      end

      assert {:error, %{Example.StatsError2 => 42}} ===
               KomachiHeartbeat.stats([Example.StatsError2])
    end
  end

  describe "vital/0" do
    test "Default is :ok", do: assert(:ok === KomachiHeartbeat.vital([]))

    test ":ok when all vitals are :ok" do
      defmodule Example.VitalOk do
        @behaviour Vital

        def vital, do: :ok
      end

      assert :ok === KomachiHeartbeat.vital([Example.VitalOk])
    end

    test ":error when some vital is :error" do
      defmodule Example.VitalError do
        @behaviour Vital

        def vital, do: :error
      end

      assert :error === KomachiHeartbeat.vital([Example.VitalError])
    end
  end
end
