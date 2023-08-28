defmodule BrickScriptCollectiveWeb.WorkspaceChannel do
  use BrickScriptCollectiveWeb, :channel

  @impl true
  def join("workspace:42", _payload, socket) do
    {:ok, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (workspace:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  def handle_in("workspace_update", payload, socket) do
    broadcast(socket, "workspace_update", payload)
    {:noreply, socket}
  end
end
