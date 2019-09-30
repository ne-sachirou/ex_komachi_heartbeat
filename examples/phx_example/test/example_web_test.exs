defmodule ExampleWebTest do
  use ExampleWeb.ConnCase

  test "GET /ops/heartbeat" do
    assert %{status: 200, resp_body: "heartbeat:ok"} = get(build_conn(), "/ops/heartbeat")
  end

  test "GET /ops/stats" do
    assert %{status: 200, resp_body: json} = get(build_conn(), "/ops/stats")
    assert {:ok, _} = Poison.decode(json)
  end
end
