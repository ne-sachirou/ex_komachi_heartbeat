defmodule Example.Router do
  @moduledoc """
  """

  use Plug.Router

  plug(:match)
  plug(:dispatch)
  forward("/ops", to: KomachiHeartbeat)
  match(_, do: send_resp(conn, 404, "Not Found"))
end
