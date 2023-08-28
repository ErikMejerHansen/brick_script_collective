defmodule BrickScriptCollective.RobotsState do
  @moduledoc """
  This module keeps track of the state of all robots server side.
  It is only used for communicating the full state when a new participant joins - after that
  """
  alias BrickScriptCollective.Lwp.LwpMessageBuilder
  alias BrickScriptCollective.Presence
  use Agent

  def start_link(_initial_value) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def robot_joined() do
    # TODO: Agent.cast <--- use cast. No need to block
  end

  def robot_left() do
    # TODO: Agent.cast <--- use cast. No need to block
  end

  # TODO MOVE these!
  def handle_attach_message(%{
        header: %{type: :hub_attached_io},
        payload: %{event: :attached, port: port, io_type: io_type}
      }) do
    case io_type do
      :force_sensor -> LwpMessageBuilder.port_input_format_setup(port, 1, 1)
      :color_sensor -> LwpMessageBuilder.port_input_format_setup(port, 0, 1)
      _ -> <<>>
    end
  end

  def handle_attach_message(%{
        header: %{type: :hub_attached_io},
        payload: %{event: :detached, port: port}
      }) do
    []
  end
end
