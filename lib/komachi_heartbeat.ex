defmodule KomachiHeartbeat do
  @moduledoc """
  Mount this using `c:Plug.Router.forward/2` or `Phoenix.Router.forward/4`.

  In Plug app.

  ```elixir
  defmodule Example.Router do
    use Plug.Router

    plug(:match)
    plug(:dispatch)

    forward("/ops", to: KomachiHeartbeat)
  end
  ```

  In Phoenix app.

  ```elixir
  defmodule ExampleWeb.Router do
    use ExampleWeb, :router

    forward("/ops", KomachiHeartbeat)
  end
  ```

  We can use `GET /MOUNT_PATH/heartbeat` & `GET /MOUNT_PATH/stats`.
  """

  alias __MODULE__.RootVital
  alias Plug.Conn

  require Logger

  use Plug.Router

  plug(:match)
  plug(:dispatch)

  def call(conn, opts) do
    opts =
      opts
      |> update_in([:timeout], &(&1 || 5000))
      |> update_in([:vitals], &(&1 || []))

    conn
    |> put_private(:komachi_heartbeat, opts)
    |> super(opts)
  end

  get "/heartbeat" do
    case RootVital.vital(vitals(conn)) do
      :ok -> send_resp(conn, 200, "heartbeat:ok")
      _ -> send_resp(conn, 503, "heartbeat:NG")
    end
  end

  get "/stats" do
    case RootVital.stats(vitals(conn), timeout: conn.private.komachi_heartbeat[:timeout]) do
      {:ok, stats} -> send_resp(conn, 200, Poison.encode!(stats))
      {:error, stats} -> send_resp(conn, 503, Poison.encode!(stats))
    end
  end

  match(_, do: send_resp(conn, 404, ""))

  @spec vitals(Conn.t()) :: [module]
  defp vitals(conn) do
    case conn.private.komachi_heartbeat[:vitals] do
      [] ->
        vitals = Application.get_env(:komachi_heartbeat, :vitals, [])

        unless Enum.empty?(vitals),
          do:
            Logger.warn("`config :komachi_heartbeat, vitals: #{inspect(vitals)}` is deprecated.")

        vitals

      vitals ->
        vitals
    end
  end
end
