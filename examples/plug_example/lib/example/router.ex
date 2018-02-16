defmodule Example.Router do
  @moduledoc """
  """

  use Plug.Router

  plug(KomachiHeartbeat, path: "/ops")
  plug(:match)
  plug(:dispatch)
  match(_, do: send_resp(conn, 404, "Not Found"))
end
