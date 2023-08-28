defmodule BrickScriptCollectiveWeb.RobotsStateChannelTest do
  alias Phoenix.Socket.Broadcast
  alias Phoenix.Socket.Message
  use BrickScriptCollectiveWeb.ChannelCase

  describe "robot states broadcasts robot state changes" do
    setup [:join_lwp_messages_channel, :join_robots_state_channel]

    # setup do
    #   {:ok, _, socket} =
    #     BrickScriptCollectiveWeb.UserSocket
    #     |> socket("user_id", %{some: :assign})
    #     |> subscribe_and_join(BrickScriptCollectiveWeb.LWPChannel, "lwp")

    #   %{socket: socket}
    # end

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
  end

  defp send_robot_connected(socket, robot_id) do
    push(socket, "robot_connected", %{robot_id: robot_id})
  end

  defp join_robots_state_channel(context) do
    {:ok, _, socket} =
      BrickScriptCollectiveWeb.RobotsStateSocket
      |> socket("user_id", %{})
      |> subscribe_and_join(BrickScriptCollectiveWeb.RobotsStateChannel, "robots_state")

    Map.put(context, :state_socket, socket)
  end

  defp join_lwp_messages_channel(context) do
    {:ok, _, socket} =
      BrickScriptCollectiveWeb.UserSocket
      |> socket("user_id", %{})
      |> subscribe_and_join(BrickScriptCollectiveWeb.LWPChannel, "lwp")

    %{lwp_socket: socket}
  end
end
