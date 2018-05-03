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

  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/heartbeat" do
    case RootVital.vital() do
      :ok -> send_resp(conn, 200, "heartbeat:ok")
      _ -> send_resp(conn, 503, "heartbeat:NG")
    end
  end

  get "/stats" do
    case RootVital.stats() do
      {:ok, stats} -> send_resp(conn, 200, Poison.encode!(stats))
      {:error, stats} -> send_resp(conn, 503, Poison.encode!(stats))
    end
  end

  match(_, do: send_resp(conn, 404, ""))
end
