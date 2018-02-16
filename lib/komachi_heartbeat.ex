defmodule KomachiHeartbeat do
  @moduledoc """
  """

  # defmacro __using__(opts) do
  #   path = opts[:path] || "/"
  #   quote do
  #     get(path <> "/heartbeat", do: send_resp(var!(conn), 200, "ok"))
  #   end
  # end

  alias Plug.Conn

  import Conn

  @doc """
  """
  @spec init(Plug.opts()) :: Plug.opts()
  def init(opts), do: update_in(opts[:path], &(&1 || "/"))

  @doc """
  """
  @spec call(Conn.t(), Plug.opts()) :: Conn.t()
  def call(conn, opts) do
    if "GET" === conn.method and opts[:path] <> "/heartbeat" === conn.request_path do
      conn |> send_resp(200, "ok") |> halt
    else
      conn
    end
  end
end
