defmodule Conway.Endpoint do
  use Phoenix.Endpoint, otp_app: :conway

  # Serve at "/" the given assets from "priv/static" directory
  plug Plug.Static,
    at: "/", from: :conway,
    only: ~w(css images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_conway_key",
    signing_salt: "f74UcEYK",
    encryption_salt: "dawlFQyG"

  plug :router, Conway.Router
end
