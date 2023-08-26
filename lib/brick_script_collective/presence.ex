defmodule BrickScriptCollective.Presence do
  use Phoenix.Presence,
    otp_app: :brick_script_collective,
    pubsub_server: BrickScriptCollective.PubSub
end
