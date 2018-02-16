KomachiHeartbeat
==

Usage
--
In Plug app.

```elixir
defmodule Example.Router do
  use Plug.Router
  plug(KomachiHeartbeat, path: "/ops")
  plug(:match)
  plug(:dispatch)
  match(_, do: send_resp(conn, 404, "Not Found"))
end
```

In Phoenix app.

```elixir
defmodule ExampleWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :example
  plug(KomachiHeartbeat, path: "/ops")
  plug(ExampleWeb.Router)
end
```

For mode detail, see [examples/](examples/) projects.

Installation
--

```elixir
def deps do
  [
    {:komachi_heartbeat, "~> 0.1"}
  ]
end
```
