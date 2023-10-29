defmodule BrickScriptCollectiveWeb.WorkspaceSocket do
  use Phoenix.Socket

  channel "workspace:*", BrickScriptCollectiveWeb.WorkspaceChannel

  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
