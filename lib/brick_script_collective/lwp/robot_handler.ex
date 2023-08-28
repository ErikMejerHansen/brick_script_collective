defmodule BrickScriptCollective.Lwp.RobotHandler do
  alias BrickScriptCollectiveWeb.Endpoint
  alias BrickScriptCollective.Lwp.Robot
  use GenServer

  def start_link(default) when is_list(default) do
    GenServer.start_link(__MODULE__, default)
  end

  def init([owning_socket]) do
    {:ok, {owning_socket, %Robot{}}}
  end

  # Public API
  def robot_connected(pid, robot_id) do
    Endpoint.broadcast("robots_state", "robots_state_update", %Phoenix.Socket.Broadcast{
      event: "robots_state_update",
      payload: %{
        :event => "robots_state_update",
        "my-robot" => %{}
      },
      topic: "robots_state"
    })
  end

  def robot_disconnected(pid, robot_id) do
  end

  def lwp_message_received(%{header: header, payload: payload}) do
  end
end
