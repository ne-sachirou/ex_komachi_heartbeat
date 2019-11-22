defmodule KomachiHeartbeat.Vital do
  @moduledoc """
  Behaviour which vital plugins implement.

  ```elixir
  defmodule ExampleVital do
    import KomachiHeartbeat.Vital

    @behaviour Vital

    @impl Vital
    def init, do: nil

    @impl Vital
    def stats, do: {:ok, 42}

    @impl Vital
    def vital, do: :ok
  end

  Application.put_env(:komachi_heartbeat, :vitals, [ExampleVital])
  ```
  """

  @type stats :: term

  @doc """
  Initialize the vital.
  """
  @callback init :: any

  @doc """
  Statistics. If it's not defined, use `c:vital/0`.
  """
  @callback stats :: :ok | :error | {:ok | :error, stats}

  @doc """
  Vital.
  """
  @callback vital :: :ok | :error
end
