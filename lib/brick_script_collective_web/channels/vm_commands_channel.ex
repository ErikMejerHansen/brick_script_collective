defmodule BrickScriptCollectiveWeb.VMCommandsChannel do
  alias Phoenix.PubSub
  use BrickScriptCollectiveWeb, :channel

  @impl true
  def join("vm_commands", _payload, socket) do
    {:ok, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("vm_command", payload, socket) do
    PubSub.broadcast(BrickScriptCollective.PubSub, "vm_command", {:vm_command, payload})
    {:noreply, socket}
  end
end
