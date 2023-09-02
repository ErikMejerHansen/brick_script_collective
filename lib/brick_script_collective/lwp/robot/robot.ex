defmodule BrickScriptCollective.Lwp.Robot do
  alias BrickScriptCollective.Lwp.Robot.Port
  alias BrickScriptCollective.Lwp.Robot.Motor
  alias BrickScriptCollective.Lwp.Robot.Sensor

  @derive Jason.Encoder
  defstruct id: "",
            ports: [
              %Port{id: 0},
              %Port{id: 1},
              %Port{id: 2},
              %Port{id: 3},
              %Port{id: 4},
              %Port{id: 5}
            ]

  def attach_port(robot, port, :small_motor) do
    updated_ports =
      robot.ports
      |> List.update_at(port, fn port ->
        %Port{port | attachment: %Motor{type: :small_motor, running: false}}
      end)

    %__MODULE__{robot | ports: updated_ports}
  end

  def attach_port(robot, port, io_type) do
    updated_ports =
      robot.ports
      |> List.update_at(port, fn port -> %Port{port | attachment: %Sensor{type: io_type}} end)

    %__MODULE__{robot | ports: updated_ports}
  end

  def detach_port(robot, port) do
    updated_ports =
      robot.ports
      |> List.update_at(port, fn port -> %Port{port | attachment: :none} end)

    %__MODULE__{robot | ports: updated_ports}
  end

  def update_motor_value(robot, port, :running) do
    updated_ports =
      robot.ports
      |> List.update_at(port, fn port ->
        %Port{port | attachment: %Motor{port.attachment | running: true}}
      end)

    %__MODULE__{robot | ports: updated_ports}
  end

  def update_motor_value(robot, port, :stopped) do
    updated_ports =
      robot.ports
      |> List.update_at(port, fn port ->
        %Port{port | attachment: %Motor{port.attachment | running: false}}
      end)

    %__MODULE__{robot | ports: updated_ports}
  end

  def update_port_value(robot, port, value) do
    updated_ports =
      robot.ports
      |> List.update_at(port, fn port ->
        %Port{port | attachment: %Sensor{port.attachment | value: value}}
      end)

    %__MODULE__{robot | ports: updated_ports}
  end
end
