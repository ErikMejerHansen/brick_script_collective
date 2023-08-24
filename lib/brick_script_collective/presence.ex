defmodule BrickScriptCollective.Presence do
  use Phoenix.Presence, otp_app: :tutorial, pubsub_server: BrickScriptCollective.PubSub
end
