defmodule BrickScriptCollective.Lwp.RobotHandler do
  alias Phoenix.PubSub
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
    PubSub.subscribe(BrickScriptCollective.PubSub, "vm_command")

    {:ok, %{owning_socket: owning_socket, robot: %Robot{}}}
  end

  def robot_connected(pid, robot_id) do
    GenServer.cast(pid, {:connected, robot_id})
  end

  def robot_disconnected(pid, robot_id) do
    GenServer.cast(pid, {:disconnected, robot_id})
  end

  def lwp_message_received(pid, message) do
    GenServer.cast(pid, {:from_robot, message})
  end

  def handle_cast({event, message}, state) do
    actions =
      case event do
        :connected -> [{:state_update, %Robot{id: message}}]
        :disconnected -> [{:state_update, nil}]
        :from_robot -> from_robot(message, state)
        :vm_command -> handle_vm_command(message, state)
      end

    state = process_actions(actions, state)

    {:noreply, state}
  end

  defp process_actions(actions, state) when is_list(actions),
    do: actions |> Enum.reduce(state, &process_action(&1, &2))

  defp process_action({:send, message}, state) do
    LWPChannel.push_command(state.owning_socket, message)

    state
  end

  defp process_action({:state_update, updated_robot}, state) do
    broadcast_robot_state_update(updated_robot)
    %{state | robot: updated_robot}
  end

  defp from_robot(raw_message, state) do
    message = LwpMessageParser.parse(raw_message)

    case message.header.type do
      :hub_attached_io ->
        handle_hub_attached_io(message, state.robot)

      :port_value_single_mode ->
        handle_port_value_single_mode(message, state.robot)

      :port_output_command_feedback ->
        handle_output_command_feedback(message, state.robot)

      _ ->
        :logger.warning("#{__MODULE__} unhandled message from robot: #{inspect(raw_message)}")
        []
    end
  end

  defp handle_port_value_single_mode(message, robot) do
    %{header: _, payload: payload} = message

    [
      {:state_update, Robot.update_port_value(robot, payload.port, payload.value)}
    ]
  end

  defp handle_hub_attached_io(message, robot) do
    %{header: _header, payload: %{event: :attached, port: port, io_type: io_type}} = message

    sensor_setup_message =
      case io_type do
        :force_sensor -> LwpMessageBuilder.port_input_format_setup(port, 1, 1)
        :color_sensor -> LwpMessageBuilder.port_input_format_setup(port, 0, 1)
        # Motors do not require a port format message
        _ -> <<>>
      end

    updated_robot = Robot.attach_port(robot, port, io_type)

    [{:send, sensor_setup_message}, {:state_update, updated_robot}]
  end

  def handle_vm_command({:vm_command, payload}, state) do
    motor_ports =
      state.robot.ports
      |> Enum.filter(fn port -> match?(%{attachment: %{type: :small_motor}}, port) end)
      |> IO.inspect()

    {duration, _} = payload["duration"] |> Integer.parse()

    messages =
      if payload["command"] == "turn_cw_for_time" do
        motor_ports
        |> Enum.map(fn port ->
          {:send, LwpMessageBuilder.start_motor_for_time(port.id, duration, 60)}
        end)
      else
        motor_ports
        |> Enum.map(fn port ->
          {:send, LwpMessageBuilder.start_motor_for_time(port.id, duration, -60)}
        end)
      end

    messages
  end

  defp handle_output_command_feedback(message, robot) do
    %{header: _, payload: payload} = message

    updated_robot =
      case payload.message do
        :in_progress -> Robot.update_motor_value(robot, payload.port, :running)
        :done -> Robot.update_motor_value(robot, payload.port, :stopped)
      end

    [{:state_update, updated_robot}]
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
end
