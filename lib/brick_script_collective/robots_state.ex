defmodule BrickScriptCollective.RobotsState do
  @moduledoc """
  Module is responsible for reacting to robot state and updating
  Presence accordingly.
  """
  alias BrickScriptCollective.Presence
  use Agent

  def start_link(_initial_value) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def robot_joined(owner_pid, user) do
    Presence.update(
      owner_pid,
      "users",
      user,
      &Map.put(&1, :robot, %{})
    )
  end

  def robot_left(owner_pid, user) do
    Presence.update(
      owner_pid,
      "users",
      user,
      &Map.delete(&1, :robot)
    )
  end

  def attached_to_port(owner_pid, user, port, type) do
    Presence.update(
      owner_pid,
      "users",
      user,
      &add_port(&1, port, type)
    )
  end

  def detached_from_port(owner_pid, user, port) do
    Presence.update(
      owner_pid,
      "users",
      user,
      &remove_port(&1, port)
    )
  end

  def sensor_update_for(owner_pid, user, port, type, value) do
    Presence.update(
      owner_pid,
      "users",
      user,
      &update_port_value(&1, port, type, value)
    )
  end

  defp add_port(map, port, type) do
    put_in(map, [:robot], %{
      port => %{
        type => 0
      }
    })
  end

  defp update_port_value(map, port, type, value) do
    put_in(map, [:robot, port, type], value)
  end

  defp remove_port(map, port) do
    pop_in(map, [:robot, port]) |> elem(1)
  end
end
