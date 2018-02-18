defmodule KomachiHeartbeat.Vital do
  @moduledoc """
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
