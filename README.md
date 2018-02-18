KomachiHeartbeat
==
🚅Vital monitoring Elixir Web application.🚄

This respects Rails's [KomachiHeartbeat](https://rubygems.org/gems/komachi_heartbeat).

Usage
--
In Plug app.

```elixir
defmodule Example.Router do
  use Plug.Router
  plug(:match)
  plug(:dispatch)
  forward("/ops", to: KomachiHeartbeat)
  match(_, do: send_resp(conn, 404, "Not Found"))
end
```

In Phoenix app.

```elixir
defmodule ExampleWeb.Router do
  use ExampleWeb, :router
  forward("/ops", KomachiHeartbeat)
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
