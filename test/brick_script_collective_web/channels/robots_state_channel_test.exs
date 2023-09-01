defmodule BrickScriptCollectiveWeb.RobotsStateChannelTest do
  alias BrickScriptCollective.Lwp.Robot
  alias BrickScriptCollective.Lwp.Robot.Port
  alias BrickScriptCollective.Lwp.Robot.Sensor
  alias BrickScriptCollective.Lwp.Robot.Motor
  use BrickScriptCollectiveWeb.ChannelCase

  describe "robot states broadcasts robot state changes" do
    setup [:join_lwp_messages_channel, :join_robots_state_channel]

    test "robots joining triggers state broadcast", %{
      lwp_socket: lwp_socket
    } do
      send_robot_connected(lwp_socket, "my-robot")

      assert_broadcast("robots_state_update", %{
        topic: "robots_state",
        event: "robots_state_update",
        payload: %{"my-robot" => %{}}
      })
    end

    test "robots leaving triggers state broadcast", %{
      lwp_socket: lwp_socket
    } do
      send_robot_connected(lwp_socket, "my-robot")
      send_robot_disconnected(lwp_socket, "my-robot")

      assert_broadcast("robots_state_update", %{
        topic: "robots_state",
        event: "robots_state_update",
        payload: %{}
      })
    end

    test "attaching a sensor causes a port setup message to be sent", %{
      lwp_socket: lwp_socket
    } do
      send_robot_connected(lwp_socket, "my-robot")
      send_port_io_attached(lwp_socket)

      assert_push("to_robot", {:binary, <<16, 0, 65, 0, 1, 1, 0, 0, 0, 1>>})
    end

    test "attaching a sensor causes a state update broadcast", %{
      lwp_socket: lwp_socket
    } do
      send_robot_connected(lwp_socket, "my-robot")
      send_port_io_attached(lwp_socket)

      assert_broadcast("robots_state_update", %{
        topic: "robots_state",
        event: "robots_state_update",
        payload: %{
          "my-robot" => %Robot{
            ports: [
              %Port{id: 0, attachment: %Sensor{type: :force_sensor}},
              %Port{},
              %Port{},
              %Port{},
              %Port{},
              %Port{}
            ]
          }
        }
      })
    end

    test "port attaches broadcast with correct port", %{
      lwp_socket: lwp_socket,
      state_socket: _state_socket
    } do
      send_robot_connected(lwp_socket, "my-robot")

      for port <- 0..5 do
        send_port_io_attached(lwp_socket, port)
      end

      assert_broadcast("robots_state_update", %{
        payload: %{
          "my-robot" => %Robot{
            ports: [
              %Port{id: 0, attachment: %Sensor{}},
              %Port{},
              %Port{},
              %Port{},
              %Port{},
              %Port{}
            ]
          }
        }
      })

      assert_broadcast("robots_state_update", %{
        payload: %{
          "my-robot" => %Robot{
            ports: [
              %Port{id: 0, attachment: %Sensor{}},
              %Port{id: 1, attachment: %Sensor{}},
              %Port{},
              %Port{},
              %Port{},
              %Port{}
            ]
          }
        }
      })

      assert_broadcast("robots_state_update", %{
        payload: %{
          "my-robot" => %Robot{
            ports: [
              %Port{},
              %Port{},
              %Port{id: 2, attachment: %Sensor{}},
              %Port{},
              %Port{},
              %Port{}
            ]
          }
        }
      })

      assert_broadcast("robots_state_update", %{
        payload: %{
          "my-robot" => %Robot{
            ports: [
              %Port{},
              %Port{},
              %Port{},
              %Port{id: 3, attachment: %Sensor{}},
              %Port{},
              %Port{}
            ]
          }
        }
      })

      assert_broadcast("robots_state_update", %{
        payload: %{
          "my-robot" => %Robot{
            ports: [
              %Port{},
              %Port{},
              %Port{},
              %Port{},
              %Port{id: 4, attachment: %Sensor{}},
              %Port{}
            ]
          }
        }
      })

      assert_broadcast("robots_state_update", %{
        payload: %{
          "my-robot" => %Robot{
            ports: [
              %Port{},
              %Port{},
              %Port{},
              %Port{},
              %Port{},
              %Port{id: 5, attachment: %Sensor{}}
            ]
          }
        }
      })
    end

    test "sensor value changes trigger state update broadcast", %{
      lwp_socket: lwp_socket
    } do
      send_robot_connected(lwp_socket, "my-robot")
      send_port_io_attached(lwp_socket)
      send_port_value_changed(lwp_socket)

      assert_broadcast("robots_state_update", %{
        topic: "robots_state",
        event: "robots_state_update",
        payload: %{
          "my-robot" => %Robot{
            ports: [
              %Port{id: 0, attachment: %Sensor{type: :force_sensor, value: 1}},
              %Port{},
              %Port{},
              %Port{},
              %Port{},
              %Port{}
            ]
          }
        }
      })
    end

    test "sensor value changes trigger state updates identify correct port", %{
      lwp_socket: lwp_socket
    } do
      send_robot_connected(lwp_socket, "my-robot")

      for port <- 0..5 do
        send_port_io_attached(lwp_socket, port)
        send_port_value_changed(lwp_socket, port, port)
      end

      assert_broadcast("robots_state_update", %{
        payload: %{
          "my-robot" => %Robot{
            ports: [
              %Port{id: 0, attachment: %Sensor{type: :force_sensor, value: 0}},
              %Port{},
              %Port{},
              %Port{},
              %Port{},
              %Port{}
            ]
          }
        }
      })

      assert_broadcast("robots_state_update", %{
        payload: %{
          "my-robot" => %Robot{
            ports: [
              %Port{},
              %Port{id: 1, attachment: %Sensor{type: :force_sensor, value: 1}},
              %Port{},
              %Port{},
              %Port{},
              %Port{}
            ]
          }
        }
      })

      assert_broadcast("robots_state_update", %{
        payload: %{
          "my-robot" => %Robot{
            ports: [
              %Port{},
              %Port{},
              %Port{id: 2, attachment: %Sensor{type: :force_sensor, value: 2}},
              %Port{},
              %Port{},
              %Port{}
            ]
          }
        }
      })

      assert_broadcast("robots_state_update", %{
        payload: %{
          "my-robot" => %Robot{
            ports: [
              %Port{},
              %Port{},
              %Port{},
              %Port{id: 3, attachment: %Sensor{type: :force_sensor, value: 3}},
              %Port{},
              %Port{}
            ]
          }
        }
      })

      assert_broadcast("robots_state_update", %{
        payload: %{
          "my-robot" => %Robot{
            ports: [
              %Port{},
              %Port{},
              %Port{},
              %Port{},
              %Port{id: 4, attachment: %Sensor{type: :force_sensor, value: 4}},
              %Port{}
            ]
          }
        }
      })

      assert_broadcast("robots_state_update", %{
        payload: %{
          "my-robot" => %Robot{
            ports: [
              %Port{},
              %Port{},
              %Port{},
              %Port{},
              %Port{},
              %Port{id: 5, attachment: %Sensor{type: :force_sensor, value: 5}}
            ]
          }
        }
      })
    end

    test "motor started messages causes state change", %{
      lwp_socket: lwp_socket
    } do
      send_robot_connected(lwp_socket, "my-robot")
      send_port_io_attached(lwp_socket, 0, 0x41)
      send_motor_started_message(lwp_socket)

      assert_broadcast("robots_state_update", %{
        payload: %{
          "my-robot" => %Robot{
            ports: [
              %Port{attachment: %Motor{running: true}},
              %Port{},
              %Port{},
              %Port{},
              %Port{},
              %Port{}
            ]
          }
        }
      })
    end

    test "motor stopped message causes state change", %{
      lwp_socket: lwp_socket
    } do
      send_robot_connected(lwp_socket, "my-robot")
      send_port_io_attached(lwp_socket, 0, 0x41)
      send_motor_stopped_message(lwp_socket)

      assert_broadcast("robots_state_update", %{
        payload: %{
          "my-robot" => %Robot{
            ports: [
              %Port{attachment: %Motor{running: false}},
              %Port{},
              %Port{},
              %Port{},
              %Port{},
              %Port{}
            ]
          }
        }
      })
    end
  end

  defp send_robot_connected(lwp_socket, robot_id) do
    push(lwp_socket, "robot_connected", %{robot_id: robot_id})
  end

  defp send_robot_disconnected(lwp_socket, robot_id) do
    push(lwp_socket, "robot_disconnected", %{robot_id: robot_id})
  end

  defp send_port_io_attached(socket, port \\ 0, type \\ 63) do
    push(
      socket,
      "lwp_message",
      {:binary, <<15, 0, 4, port, 1, type, 0, 0, 0, 0, 16, 0, 0, 0, 16>>}
    )
  end

  defp send_motor_started_message(socket, port \\ 0) do
    push(
      socket,
      "lwp_message",
      {:binary, <<5, 0, 130, port, 1>>}
    )
  end

  defp send_motor_stopped_message(socket, port \\ 0) do
    push(
      socket,
      "lwp_message",
      {:binary, <<5, 0, 130, port, 10>>}
    )
  end

  defp send_port_value_changed(socket, port \\ 0, value \\ 1) do
    push(
      socket,
      "lwp_message",
      {:binary, <<5, 0, 69, port, value>>}
    )
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
