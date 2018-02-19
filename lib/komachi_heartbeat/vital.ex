defmodule KomachiHeartbeat.Vital do
  @moduledoc """
  Behaviour which vital plugins implement.

  ```elixir
  defmodule ExampleVital do
    @behaviour KomachiHeartbeat.Vital

    def stats, do: {:ok, 42}

    def vital, do: :ok
  end

  Application.put_env(:komachi_heartbeat, :vitals, [ExampleVital])
  ```
  """

  @type stats :: Poison.Encoder.t()

  @doc """
  Statistics. If it's not defined, use `c:vital/0`.
  """
  @callback stats :: :ok | :error | {:ok | :error, stats}

  @doc """
  Vital.
  """
  @callback vital :: :ok | :error
end
