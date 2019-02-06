KomachiHeartbeat
==
🚅Vital monitoring Elixir Web application.🚄

[![Hex.pm](https://img.shields.io/hexpm/v/komachi_heartbeat.svg)](https://hex.pm/packages/komachi_heartbeat)
[![Build Status](https://travis-ci.org/ne-sachirou/ex_komachi_heartbeat.svg?branch=master)](https://travis-ci.org/ne-sachirou/ex_komachi_heartbeat)
[![Coverage Status](https://coveralls.io/repos/github/ne-sachirou/ex_komachi_heartbeat/badge.svg)](https://coveralls.io/github/ne-sachirou/ex_komachi_heartbeat)

This respects Rails's [KomachiHeartbeat](https://rubygems.org/gems/komachi_heartbeat).

Usage
--
Mount KomachiHeartbeat at any path. We mount it for example at `/ops` below.

In Plug app. [example][Plug example]

```elixir
defmodule Example.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  forward("/ops", to: KomachiHeartbeat)
end
```

In Phoenix app. [example][Phoenix example]

```elixir
defmodule ExampleWeb.Router do
  use ExampleWeb, :router

  forward("/ops", KomachiHeartbeat)
end
```

KomachiHeartbeat provides 2 endpoints.

* `GET /MOUNT_PATH/heartbeat` : Monitor the server is OK. Response `200 "ok"` or `503 "error"`.
* `GET /MOUNT_PATH/stats` : Monitor the server statistics. Response `200 JSON` or `503 JSON`.

## Extend KomachiHeartbeat
You can extend KomachiHeartbeat to write vital plugins. Vital plugins should implement `KomachiHeartbeat.Vital`.

```elixir
defmodule ExampleVital do
  @behaviour KomachiHeartbeat.Vital

  def stats, do: {:ok, 42}

  def vital, do: :ok
end
```

Add this at config. In Plug app :

```elixir
forward("/ops", to: KomachiHeartbeat, init_opts: [vitals: []])
```

In Phoenix app :

```elixir
forward("/ops", KomachiHeartbeat, vitals: [])
```

Now `GET /MOUNT_PATH/heartbeat` calls `ExampleVital.vital/0` & response `ok`.
`GET /MOUNT_PATH/stats` calls `ExampleVital.stats/0` & response `{"Elixir.ExampleVital": 42}`.

Installation
--
Add `:komachi_heartbeat` at `mix.exs`.

```elixir
def deps do
  [
    {:komachi_heartbeat, "~> 0.3"}
  ]
end
```

[Plug example]: https://github.com/ne-sachirou/ex_komachi_heartbeat/tree/master/examples/plug_example
[Phoenix example]: https://github.com/ne-sachirou/ex_komachi_heartbeat/tree/master/examples/phx_example
