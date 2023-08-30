defmodule BrickScriptCollectiveWeb.VMCommandsSocket do
  use Phoenix.Socket

  channel("vm_commands", BrickScriptCollectiveWeb.VMCommandsChannel)

  @impl true
  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  @impl true
  def id(_socket), do: nil
end
