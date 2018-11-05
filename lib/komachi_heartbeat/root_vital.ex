defmodule KomachiHeartbeat.RootVital do
  @moduledoc """
  Call & aggregate vital plugins.
  """

  alias KomachiHeartbeat.Vital

  @behaviour Vital

  @doc """
  Call & aggregate vital plugins `stats/0`.
  """
  @impl Vital
  def stats, do: stats(Application.get_env(:komachi_heartbeat, :vitals, []))

  @spec stats([module]) :: {:ok | :error, %{module => Vital.stats()}}
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
  Call & aggregate vital plugins `vital/0`.
  """
  @impl Vital
  def vital, do: vital(Application.get_env(:komachi_heartbeat, :vitals, []))

  @spec vital([module]) :: :ok | :error
  def vital(vitals) do
    error_vitals = for vital <- vitals, :ok !== vital.vital(), do: vital
    if [] === error_vitals, do: :ok, else: :error
  end
end
