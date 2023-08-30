defmodule BrickScriptCollectiveWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :brick_script_collective

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_brick_script_collective_key",
    signing_salt: "bGsTaI73",
    same_site: "Lax"
  ]

  socket("/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]])

  socket("/workspace_sync", BrickScriptCollectiveWeb.WorkspaceSocket,
    websocket: true,
    longpoll: false
  )

  socket("/lwp", BrickScriptCollectiveWeb.LWPSocket,
    websocket: true,
    longpoll: false
  )

  socket("/robots_state", BrickScriptCollectiveWeb.RobotsStateSocket,
    websocket: true,
    longpoll: false
  )

  socket("/vm_commands", BrickScriptCollectiveWeb.VMCommandsSocket,
    websocket: true,
    longpoll: false
  )

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug(Plug.Static,
    at: "/",
    from: :brick_script_collective,
    gzip: false,
    only: BrickScriptCollectiveWeb.static_paths()
  )

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket("/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket)
    plug(Phoenix.LiveReloader)
    plug(Phoenix.CodeReloader)
  end

  plug(Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"
  )

  plug(Plug.RequestId)
  plug(Plug.Telemetry, event_prefix: [:phoenix, :endpoint])

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()
  )

  plug(Plug.MethodOverride)
  plug(Plug.Head)
  plug(Plug.Session, @session_options)
  plug(BrickScriptCollectiveWeb.Router)
end
