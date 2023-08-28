defmodule BrickScriptCollectiveWeb.RobotsStateChannelTest do
  alias BrickScriptCollective.Lwp.Robot
  alias BrickScriptCollective.Lwp.Robot.Port
  alias BrickScriptCollective.Lwp.Robot.Sensor
  alias Phoenix.Socket.Broadcast
  use BrickScriptCollectiveWeb.ChannelCase

  describe "robot states broadcasts robot state changes" do
    setup [:join_lwp_messages_channel, :join_robots_state_channel]

    test "robots joining triggers state broadcast", %{
      lwp_socket: lwp_socket,
      state_socket: state_socket
    } do
      send_robot_connected(lwp_socket, "my-robot")

      assert_broadcast("robots_state_update", %Broadcast{
        topic: "robots_state",
        event: "robots_state_update",
        payload: %{"my-robot" => %{}}
      })
    end

    test "attaching a sensor causes a port setup message to be sent", %{
      lwp_socket: lwp_socket,
      state_socket: state_socket
    } do
      send_robot_connected(lwp_socket, "my-robot")
      send_port_io_attached(lwp_socket)

      assert_push("to_robot", {:binary, <<16, 0, 65, 0, 1, 1, 0, 0, 0, 1>>})
    end

    test "attaching a sensor causes a state update broadcast", %{
      lwp_socket: lwp_socket,
      state_socket: state_socket
    } do
      send_robot_connected(lwp_socket, "my-robot")
      send_port_io_attached(lwp_socket)

      assert_broadcast("robots_state_update", %Broadcast{
        topic: "robots_state",
        event: "robots_state_update",
        payload: %{
          "my-robot" => %Robot{port_1: %Port{id: 0, attachment: %Sensor{type: :force_sensor}}}
        }
      })
    end
  end

  defp send_robot_connected(lwp_socket, robot_id) do
    push(lwp_socket, "robot_connected", %{robot_id: robot_id})
  end

  defp send_port_io_attached(socket) do
    push(socket, "lwp_message", {:binary, <<15, 0, 4, 0, 1, 63, 0, 0, 0, 0, 16, 0, 0, 0, 16>>})
  end

  defp join_robots_state_channel(_context) do
    {:ok, _, socket} =
      BrickScriptCollectiveWeb.RobotsStateSocket
      |> socket("user_id", %{})
      |> subscribe_and_join(BrickScriptCollectiveWeb.RobotsStateChannel, "robots_state")

    %{state_socket: socket}
  end

  defp join_lwp_messages_channel(_context) do
    {:ok, _, socket} =
      BrickScriptCollectiveWeb.UserSocket
      |> socket("user_id", %{})
      |> subscribe_and_join(BrickScriptCollectiveWeb.LWPChannel, "lwp")

    %{lwp_socket: socket}
  end
end

# Example messages for button pushes
# {:binary, <<5, 0, 69, 1, 0>>}
# rs: {:binary, <<5, 0, 69, 1, 1>>}
