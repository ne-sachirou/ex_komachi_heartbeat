defmodule ExampleWebTest do
  use ExampleWeb.ConnCase

  test "GET /ops/heartbeat" do
    assert %{status: 200, resp_body: "ok"} = get(build_conn(), "/ops/heartbeat")
  end
end
