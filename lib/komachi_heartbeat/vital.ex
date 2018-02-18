defmodule KomachiHeartbeat.Vital do
  @moduledoc """
      iex> defmodule ExampleVital do
      iex>   @behaviour KomachiHeartbeat.Stats
      iex>
      iex>   def stats, do: {:ok, 1}
      iex>
      iex>   def vital, do: :ok
      iex> end
      iex>
      iex> Application.put_env(:komachi_heartbeat, :vitals, [ExampleVital])
      iex>
      iex> KomachiHeartbeat.vital
      {:ok, %{ExampleVital => :ok}}

      iex> KomachiHeartbeat.stats
      {:ok, %{ExampleVital => 1}}
  """

  @type stats :: Poison.Encoder.t()

  @doc """
  If it's not defined, use `c:vital/0`.
  """
  @callback stats :: :ok | :error | {:ok | :error, stats}

  @doc """
  """
  @callback vital :: :ok | :error
end
