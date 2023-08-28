defmodule BrickScriptCollective.RobotsState do
  @moduledoc """
  This module keeps track of the state of all robots server side.
  It is only used for communicating the full state when a new participant joins - after that
  """
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
end
