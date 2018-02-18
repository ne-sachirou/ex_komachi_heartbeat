defmodule KomachiHeartbeat.RootVital do
  @moduledoc """
  """

  alias KomachiHeartbeat.Vital

  @behaviour Vital

  @doc """
  """
  @impl true
  @spec stats :: {:ok | :error, %{module => Vital.stats()}}
  def stats, do: stats(Application.get_env(:komachi_heartbeat, :vitals, []))

  @doc false
  def stats(vitals) do
    Enum.reduce(vitals, {:ok, %{}}, fn vital, {status, results} ->
      stats = if function_exported?(vital, :stats, 0), do: vital.stats(), else: vital.vital()

      case stats do
        {:ok, stats} -> {status, put_in(results[vital], stats)}
        :ok -> {status, put_in(results[vital], :ok)}
        {:error, stats} -> {:error, put_in(results[vital], stats)}
        _ -> {:error, put_in(results[vital], :error)}
      end
    end)
  end

  @doc """
  """
  @impl true
  def vital, do: vital(Application.get_env(:komachi_heartbeat, :vitals, []))

  @doc false
  def vital(vitals) do
    error_vitals = for vital <- vitals, :ok !== vital.vital(), do: vital
    if [] === error_vitals, do: :ok, else: :error
  end
end
