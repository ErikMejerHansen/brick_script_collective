defmodule BrickScriptCollectiveWeb.LWPChannel do
  @moduledoc """
  Receives LWP messages from robots, parses them and sends them on to the Robot (Robot with capital R is server-side)

  Receives robot commands from Robot and translates them into LWP messages and send them to
  the robot.
  """
  alias BrickScriptCollective.Lwp.RobotHandler

  use BrickScriptCollectiveWeb, :channel

  @impl true
  def join("lwp", _payload, socket) do
    {:ok, socket}
  end

  def handle_in("robot_connected", payload, socket) do
    # Signals that a robot has been connected in the browser
    # Create RobotStateHandler and save its PID in socket.assigns
    {:ok, pid} = RobotHandler.start_link([socket])
    RobotHandler.robot_connected(pid, payload["robot_id"])

    {:noreply, socket |> assign(:handler, pid)}
  end

  def handle_in("robot_disconnected", payload, socket) do
    # Signals that a robot has been connected in the browser
    # Create RobotStateHandler and save its PID in socket.assigns
    handler = socket.assigns.handler
    RobotHandler.robot_disconnected(handler, payload["robot_id"])

    {:noreply, socket}
  end

  @impl true
  def handle_in("lwp_message", {:binary, message}, socket) do
    handler = socket.assigns.handler
    RobotHandler.lwp_message_received(handler, message)

    {:noreply, socket}
  end

  @doc """
  Allows sending lwp message to a specific robot.
  """
  def push_command(socket, message) do
    push(socket, "to_robot", {:binary, message})
  end
end
