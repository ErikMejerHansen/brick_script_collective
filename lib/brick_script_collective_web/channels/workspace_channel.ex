defmodule BrickScriptCollectiveWeb.WorkspaceChannel do
  use BrickScriptCollectiveWeb, :channel

  @impl true
  def join("workspace:42", _payload, socket) do
    {:ok, socket}
  end

  def handle_in("workspace_update", payload, socket) do
    broadcast(socket, "workspace_update", payload)
    {:noreply, socket}
  end
end
