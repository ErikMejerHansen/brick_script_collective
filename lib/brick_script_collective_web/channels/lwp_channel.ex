defmodule BrickScriptCollectiveWeb.LWPChannel do
  @moduledoc """
  Receives LWP messages from robots, parses them and sends them on to the Robot (Robot with capital R is server-side)

  Receives robot commands from Robot and translates them into LWP messages and send them to
  the robot.
  """
  alias BrickScriptCollectiveWeb.Endpoint
  alias BrickScriptCollective.RobotsState
  alias BrickScriptCollective.Lwp.RobotHandler
  alias BrickScriptCollective.Lwp.LwpMessageParser

  use BrickScriptCollectiveWeb, :channel

  @impl true
  def join("lwp", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("robot_connected", payload, socket) do
    # Signals that a robot has been connected in the browser
    # Create RobotStateHandler and save its PID in socket.assigns
    {:ok, pid} = RobotHandler.start_link([socket])
    RobotHandler.robot_connected(pid, payload["robot_id"])

    {:noreply, socket |> assign(:handler, pid)}
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

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
