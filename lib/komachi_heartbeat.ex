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

  def init(opts) do
    apps = Enum.map(Application.loaded_applications(), &elem(&1, 0))

    json_adapter =
      cond do
        :jason in apps -> Jason
        :poison in apps -> Poison
        true -> Jason
      end

    opts =
      opts
      |> put_in([:json_adapter], json_adapter)
      |> update_in([:timeout], &(&1 || 5000))
      |> update_in([:vitals], &(&1 || []))

    RootVital.init(opts[:vitals])
    opts
  end

  def call(conn, opts) do
    opts = init(opts)

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
    json_adapter = conn.private.komachi_heartbeat[:json_adapter]

    case RootVital.stats(vitals(conn), timeout: conn.private.komachi_heartbeat[:timeout]) do
      {:ok, stats} -> send_resp(conn, 200, json_adapter.encode!(stats))
      {:error, stats} -> send_resp(conn, 503, json_adapter.encode!(stats))
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
