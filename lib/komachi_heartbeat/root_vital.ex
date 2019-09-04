defmodule KomachiHeartbeat.RootVital do
  @moduledoc """
  Call & aggregate vital plugins.
  """

  alias KomachiHeartbeat.Vital

  @behaviour Vital

  @impl Vital
  def init, do: nil

  @spec init([module]) :: any
  def init(vitals) do
    Enum.each(vitals, fn vital -> if function_exported?(vital, :init, 0), do: vital.init() end)
  end

  @doc """
  Call & aggregate vital plugins `stats/0`.
  """
  @impl Vital
  def stats, do: stats(Application.get_env(:komachi_heartbeat, :vitals, []))

  @spec stats([module]) :: {:ok | :error, %{(atom | binary) => Vital.stats()}}
  def stats(vitals), do: stats(vitals, timeout: 5000)

  @spec stats([module], timeout: pos_integer) ::
          {:ok | :error, %{(atom | binary) => Vital.stats()}}
  def stats(vitals, timeout: timeout) do
    vitals
    |> Task.async_stream(
      fn vital ->
        stats = if function_exported?(vital, :stats, 0), do: vital.stats(), else: vital.vital()

        case stats do
          {status, stats} when status in [:ok, :error] and is_map(stats) ->
            {status, stats}

          {status, stats} when status in [:ok, :error] ->
            {status, if(Keyword.keyword?(stats), do: Map.new(stats), else: %{vital => stats})}

          :ok ->
            {:ok, %{vital => :ok}}

          _ ->
            {:error, %{vital => :error}}
        end
      end,
      timeout: timeout,
      on_timeout: :kill_task
    )
    |> Enum.zip(vitals)
    |> Enum.map(fn
      {{:ok, {status, stats}}, _} -> {status, stats}
      {{:exit, reason}, vital} -> {:error, %{vital => reason}}
    end)
    |> Enum.reduce({:ok, %{}}, fn
      {:ok, stats}, {:ok, results} -> {:ok, Map.merge(results, stats)}
      {_, stats}, {:error, results} -> {:error, Map.merge(results, stats)}
      {:error, stats}, {:ok, results} -> {:error, Map.merge(results, stats)}
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
