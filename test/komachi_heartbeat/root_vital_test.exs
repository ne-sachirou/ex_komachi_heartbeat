defmodule KomachiHeartbeat.RootVitalTest do
  alias KomachiHeartbeat.RootVital

  use ExUnit.Case, async: true

  doctest RootVital

  describe "stats/0" do
    test "Default is {:ok, %{}}", do: assert({:ok, %{}} === RootVital.stats([]))

    test ":ok when all vitals are :ok" do
      defmodule Example.StatsOk1 do
        @behaviour KomachiHeartbeat.Vital

        @impl KomachiHeartbeat.Vital
        def stats, do: :ok
      end

      assert {:ok, %{Example.StatsOk1 => :ok}} === RootVital.stats([Example.StatsOk1])
    end

    test ":ok & collect stats when all vitals are :ok" do
      defmodule Example.StatsOk2 do
        @behaviour KomachiHeartbeat.Vital

        @impl KomachiHeartbeat.Vital
        def stats, do: {:ok, 42}
      end

      assert {:ok, %{Example.StatsOk2 => 42}} === RootVital.stats([Example.StatsOk2])
    end

    test ":error when some vital is :error" do
      defmodule Example.StatsError1 do
        @behaviour KomachiHeartbeat.Vital

        @impl KomachiHeartbeat.Vital
        def stats, do: :error
      end

      assert {:error, %{Example.StatsError1 => :error}} === RootVital.stats([Example.StatsError1])
    end

    test ":error & collect stats when some vital is :error" do
      defmodule Example.StatsError2 do
        @behaviour KomachiHeartbeat.Vital

        @impl KomachiHeartbeat.Vital
        def stats, do: {:error, 42}
      end

      assert {:error, %{Example.StatsError2 => 42}} === RootVital.stats([Example.StatsError2])
    end
  end

  describe "vital/0" do
    test "Default is :ok", do: assert(:ok === RootVital.vital([]))

    test ":ok when all vitals are :ok" do
      defmodule Example.VitalOk do
        @behaviour KomachiHeartbeat.Vital

        @impl KomachiHeartbeat.Vital
        def vital, do: :ok
      end

      assert :ok === RootVital.vital([Example.VitalOk])
    end

    test ":error when some vital is :error" do
      defmodule Example.VitalError do
        @behaviour KomachiHeartbeat.Vital

        @impl KomachiHeartbeat.Vital
        def vital, do: :error
      end

      assert :error === RootVital.vital([Example.VitalError])
    end
  end
end
