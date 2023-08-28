# defmodule BrickScriptCollective.RobotsStateTest do
#   alias BrickScriptCollective.Presence
#   alias BrickScriptCollective.RobotsState
#   alias Phoenix.PubSub

#   use ExUnit.Case, async: true

#   describe "robot state changes" do
#     setup [:setup_presence_tracking]

#     test "a robot joining will trigger update" do
#       RobotsState.robot_joined(self(), "my_user")
#       assert_receive %{payload: %{joins: %{"my_user" => %{metas: [%{robot: %{}}]}}}}
#     end

#     test "a robot leaving will trigger update" do
#       RobotsState.robot_left(self(), "my_user")
#       assert_receive %{payload: %{joins: %{"my_user" => %{metas: [%{}]}}}}
#     end

#     test "attaching something to a port triggers update" do
#       RobotsState.robot_joined(self(), "my_user")
#       RobotsState.attached_to_port(self(), "my_user", 0, :color_sensor)

#       assert_receive %{
#         payload: %{joins: %{"my_user" => %{metas: [%{robot: %{0 => %{color_sensor: 0}}}]}}}
#       }
#     end

#     test "sensor value updates to IO device on a port triggers update" do
#       RobotsState.robot_joined(self(), "my_user")
#       RobotsState.attached_to_port(self(), "my_user", 0, :color_sensor)
#       RobotsState.sensor_update_for(self(), "my_user", 0, :color_sensor, 23)

#       assert_receive %{
#         payload: %{joins: %{"my_user" => %{metas: [%{robot: %{0 => %{color_sensor: 23}}}]}}}
#       }
#     end

#     defp setup_presence_tracking(_context) do
#       Presence.track(self(), "users", "my_user", %{robot: %{}})
#       PubSub.subscribe(BrickScriptCollective.PubSub, "users")
#     end
#   end
# end
