defmodule ExampleWebTest do
  use ExampleWeb.ConnCase

  test "GET /ops/heartbeat" do
    assert %{status: 200, resp_body: "ok"} = get(build_conn(), "/ops/heartbeat")
  end

  test "GET /ops/stats" do
    assert %{status: 200, resp_body: "{}"} = get(build_conn(), "/ops/stats")
  end
end
