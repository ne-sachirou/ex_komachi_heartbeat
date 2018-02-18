defmodule KomachiHeartbeat do
  @moduledoc """
  """

  alias __MODULE__.RootVital

  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/heartbeat" do
    case RootVital.vital() do
      :ok -> send_resp(conn, 200, "ok")
      _ -> send_resp(conn, 503, "error")
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
