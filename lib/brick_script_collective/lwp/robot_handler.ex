defmodule BrickScriptCollective.Lwp.RobotHandler do
  alias BrickScriptCollective.Lwp.LwpMessageParser
  alias BrickScriptCollective.Lwp.LwpMessageBuilder
  alias BrickScriptCollectiveWeb.LWPChannel
  alias BrickScriptCollectiveWeb.Endpoint
  alias BrickScriptCollective.Lwp.Robot
  alias BrickScriptCollective.Lwp.Robot.Port
  alias BrickScriptCollective.Lwp.Robot.Sensor

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

  def handle_cast({:connected, robot_id}, {owning_socket, robot}) do
    updated_robot = %Robot{robot | id: robot_id}

    broadcast_robot_state_update(updated_robot)

    {:noreply, {owning_socket, updated_robot}}
  end

  def handle_cast({:from_robot, raw_message}, state = {owning_socket, robot}) do
    message = LwpMessageParser.parse(raw_message)

    case message.header.type do
      :hub_attached_io ->
        {:push, outbound_message, updated_robot} = do_lwp_message_received(message, robot)

        broadcast_robot_state_update(updated_robot)

        unless byte_size(outbound_message) == 0 do
          LWPChannel.push_command(owning_socket, outbound_message)
        end

        {:noreply, {owning_socket, updated_robot}}

      :port_value_single_mode ->
        updated_robot = do_lwp_message_received(message, robot)
        broadcast_robot_state_update(updated_robot)
        {:noreply, {owning_socket, updated_robot}}

      _ ->
        {:noreply, state}
    end
  end

  defp broadcast_robot_state_update(robot) do
    Endpoint.broadcast("robots_state", "robots_state_update", %{
      event: "robots_state_update",
      payload: %{
        :event => "robots_state_update",
        robot.id => robot
      },
      topic: "robots_state"
    })
  end

  defp do_lwp_message_received(
         %{
           header: %{type: :port_value_single_mode},
           payload: %{event: :value_change, port: port, value: value}
         },
         robot
       ) do
    updated_robot = update_port_value(robot, port, value)

    updated_robot
  end

  defp do_lwp_message_received(
         %{
           header: %{type: :hub_attached_io},
           payload: %{event: :attached, port: port, io_type: io_type}
         },
         robot
       ) do
    outbound_message =
      case io_type do
        :force_sensor -> LwpMessageBuilder.port_input_format_setup(port, 1, 1)
        :color_sensor -> LwpMessageBuilder.port_input_format_setup(port, 0, 1)
        _ -> <<>>
      end

    updated_robot = attach_port(robot, port, io_type)

    {:push, outbound_message, updated_robot}
  end

  defp attach_port(robot, port, io_type) do
    updated_ports =
      robot.ports
      |> List.update_at(port, fn port -> %Port{port | attachment: %Sensor{type: io_type}} end)

    %Robot{robot | ports: updated_ports}
  end

  defp update_port_value(robot, port, value) do
    updated_ports =
      robot.ports
      |> List.update_at(port, fn port ->
        %Port{port | attachment: %Sensor{port.attachment | value: value}}
      end)

    %Robot{robot | ports: updated_ports}
    # ports = robot.ports

    #       %Robot{
    #         robot
    #         | port_5: %Port{
    #             robot.port_5
    #             | attachment: %Sensor{robot.port_5.attachment | value: value}
    #           }
    #       }
  end
end
