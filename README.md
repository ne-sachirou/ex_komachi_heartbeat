# KomachiHeartbeat

🚅Vital monitoring Elixir Web application.🚄

[![Hex.pm](https://img.shields.io/hexpm/v/komachi_heartbeat.svg)](https://hex.pm/packages/komachi_heartbeat)
[![Build Status](https://travis-ci.org/ne-sachirou/ex_komachi_heartbeat.svg?branch=master)](https://travis-ci.org/ne-sachirou/ex_komachi_heartbeat)
[![Coverage Status](https://coveralls.io/repos/github/ne-sachirou/ex_komachi_heartbeat/badge.svg)](https://coveralls.io/github/ne-sachirou/ex_komachi_heartbeat)

This respects Rails's [KomachiHeartbeat](https://rubygems.org/gems/komachi_heartbeat).

## Usage

Mount KomachiHeartbeat at any path. We mount it for example at `/ops` below.

In Plug app. [example][plug example]

```elixir
defmodule Example.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  forward("/ops", to: KomachiHeartbeat)
end
```

In Phoenix app. [example][phoenix example]

```elixir
defmodule ExampleWeb.Router do
  use ExampleWeb, :router

  forward("/ops", KomachiHeartbeat)
end
```

KomachiHeartbeat provides 2 endpoints.

- `GET /MOUNT_PATH/heartbeat` : Monitor the server is OK. Response `200 "heartbeat:ok"` or `503 "heartbeat:NG"`.
- `GET /MOUNT_PATH/stats` : Monitor the server statistics. Response `200 JSON` or `503 JSON`.

## Extend KomachiHeartbeat

You can extend KomachiHeartbeat to write vital plugins. Vital plugins should implement `KomachiHeartbeat.Vital`.

```elixir
defmodule ExampleVital do
  import  KomachiHeartbeat.Vital

  @behaviour Vital

  @impl Vital
  def init, do: nil

  @impl Vital
  def stats, do: {:ok, %{example: 42}}

  @impl Vital
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

Now `GET /MOUNT_PATH/heartbeat` calls `ExampleVital.vital/0` & response `heartbeat:ok`.
`GET /MOUNT_PATH/stats` calls `ExampleVital.stats/0` & response `{"example": 42}`.

## BeamVital

We have a vital to observe BEAM VM. It's `BeamVital`.

To config this, in Plug app :

```elixir
forward("/ops", to: KomachiHeartbeat, init_opts: [vitals: [KomachiHeartbeat.BeamVital]])
```

In Phoenix app :

```elixir
forward("/ops", KomachiHeartbeat, vitals: [KomachiHeartbeat.BeamVital])
```

Then `GET /MOUNT_PATH/stats` responses JSON like this.

```json
{
  "context_switches": 118,
  "gc": {
    "count": 28,
    "words_reclaimed": 10385
  },
  "io": {
    "in": 204,
    "out": 228
  },
  "memory": {
    "atom": 804813,
    "binary": 587056,
    "code": 14787824,
    "ets": 8421128,
    "processes": 13062992
  },
  "port_count": 7,
  "process_count": 272,
  "reductions": 6719,
  "run_queue": 1,
  "scheduler_usage": {
    "1": 1.5975716910296348e-5,
    "2": 1.4977518744364708e-5,
    "3": 6.3936000063936e-5,
    "4": 1.7984155958600475e-5,
    "5": 0.0011898428149764476,
    "6": 1.6977538716278364e-5,
    "7": 2.197613391856444e-5,
    "8": 2.1967882955119614e-5,
    "9": 3.09616385298615e-5,
    "10": 1.9971879593532307e-5,
    "11": 1.8977985536777338e-5,
    "12": 1.797169458103487e-5,
    "13": 1.697179288023305e-5,
    "14": 2.49564759060199e-5,
    "15": 1.6969421103172084e-5,
    "16": 1.3974343106057279e-5
  }
}
```

## Installation

Add `:komachi_heartbeat` at `mix.exs`.

```elixir
def deps do
  [
    {:komachi_heartbeat, "~> 0.5"}
  ]
end
```

[plug example]: https://github.com/ne-sachirou/ex_komachi_heartbeat/tree/master/examples/plug_example
[phoenix example]: https://github.com/ne-sachirou/ex_komachi_heartbeat/tree/master/examples/phx_example
