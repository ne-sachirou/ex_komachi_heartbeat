defmodule ExampleTest do
  use ExUnit.Case
  use Plug.Test

  doctest Example

  test "GET /ops/heartbeat" do
    conn = conn(:get, "/ops/heartbeat")
    assert {200, _, "ok"} = sent_resp(Example.Router.call(conn, []))
  end
end
