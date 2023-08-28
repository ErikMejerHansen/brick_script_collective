defmodule BrickScriptCollective.Lwp.RobotHandler do
  alias BrickScriptCollective.Lwp.LwpMessageParser
  alias BrickScriptCollective.Lwp.LwpMessageBuilder
  alias BrickScriptCollectiveWeb.LWPChannel
  alias BrickScriptCollectiveWeb.Endpoint
  alias BrickScriptCollective.Lwp.Robot
  use GenServer

  def start_link(default) when is_list(default) do
    GenServer.start_link(__MODULE__, default)
  end

  def init([owning_socket]) do
    {:ok, {owning_socket, %Robot{}}}
  end

  def robot_connected(pid, robot_id) do
    GenServer.cast(pid, {:connected, robot_id})
  end

  def lwp_message_received(pid, message) do
    GenServer.cast(pid, {:from_robot, message})
  end

  def handle_cast({:connected, robot_id}, state) do
    Endpoint.broadcast("robots_state", "robots_state_update", %Phoenix.Socket.Broadcast{
      event: "robots_state_update",
      payload: %{
        :event => "robots_state_update",
        robot_id => %{}
      },
      topic: "robots_state"
    })

    {:noreply, state}
  end

  def handle_cast({:from_robot, raw_message}, state = {owning_socket, _robot}) do
    message = LwpMessageParser.parse(raw_message)

    if message.header.type == :hub_attached_io do
      reaction = do_lwp_message_received(message)

      unless byte_size(reaction) == 0 do
        LWPChannel.push_command(owning_socket, reaction)
      end
    end

    {:noreply, state}
  end

  defp do_lwp_message_received(%{
         header: %{type: :hub_attached_io},
         payload: %{event: :attached, port: port, io_type: io_type}
       }) do
    case io_type do
      :force_sensor -> LwpMessageBuilder.port_input_format_setup(port, 1, 1)
      :color_sensor -> LwpMessageBuilder.port_input_format_setup(port, 0, 1)
      _ -> <<>>
    end
  end
end
