defmodule BrickScriptCollective.Lwp.LwpMessageParserTest do
  use ExUnit.Case, async: true
  alias BrickScriptCollective.Lwp.LwpMessageParser

  describe "parsing LWP messages" do
    test "it can parse one of the initial messages" do
      message = %{
        # length
        "0" => 15,
        # hub id
        "1" => 0,
        # type
        "2" => 4,
        # message type: HubAttacheIO
        "3" => 98,
        # event type attached
        "4" => 1,
        # Type id 1
        "5" => 58,
        # type id 2
        "6" => 0,
        # Hardware revistion
        "7" => 1,
        "8" => 0,
        "9" => 0,
        "10" => 0,
        # software revision
        "11" => 17,
        "12" => 0,
        "13" => 0,
        "14" => 0
      }

      parsed = LwpMessageParser.parse(message)

      assert parsed.header.length == 15
      assert parsed.header.type == :hub_attached_io
    end

    test "it detects attachment of color sensor" do
      message = %{
        "0" => 15,
        "1" => 0,
        "10" => 16,
        "11" => 0,
        "12" => 0,
        "13" => 0,
        "14" => 16,
        "2" => 4,
        "3" => 1,
        "4" => 1,
        "5" => 61,
        "6" => 0,
        "7" => 0,
        "8" => 0,
        "9" => 0
      }

      parsed = LwpMessageParser.parse(message)

      assert parsed.header.length == 15
      assert parsed.header.type == :hub_attached_io
      assert parsed.payload.io_type == :color_sensor
    end

    test "it detects attachment of small motor" do
      message = %{
        "0" => 15,
        "1" => 0,
        "10" => 0,
        "11" => 0,
        "12" => 0,
        "13" => 3,
        "14" => 16,
        "2" => 4,
        "3" => 0,
        "4" => 1,
        "5" => 65,
        "6" => 0,
        "7" => 1,
        "8" => 0,
        "9" => 0
      }

      parsed = LwpMessageParser.parse(message)

      assert parsed.header.length == 15
      assert parsed.header.type == :hub_attached_io
      assert parsed.payload.io_type == :small_motor
    end

    test "it detects attachment of force sensor" do
      message = %{
        "0" => 15,
        "1" => 0,
        "10" => 16,
        "11" => 0,
        "12" => 0,
        "13" => 0,
        "14" => 16,
        "2" => 4,
        "3" => 0,
        "4" => 1,
        "5" => 63,
        "6" => 0,
        "7" => 0,
        "8" => 0,
        "9" => 0
      }

      parsed = LwpMessageParser.parse(message)

      assert parsed.header.length == 15
      assert parsed.header.type == :hub_attached_io
      assert parsed.payload.io_type == :force_sensor
    end
  end
end

# [debug] HANDLED lwp_message INCOMING ON lwp (BrickScriptCollectiveWeb.LWPChannel) in 466µs
#   Parameters: %{"0" => 15, "1" => 0, "10" => 1, "11" => 6, "12" => 0, "13" => 0, "14" => 32, "2" => 4, "3" => 49, "4" => 1, "5" => 23, "6" => 0, "7" => 0, "8" => 0, "9" => 0}
# [debug] HANDLED lwp_message INCOMING ON lwp (BrickScriptCollectiveWeb.LWPChannel) in 30µs
#   Parameters: %{"0" => 15, "1" => 0, "10" => 1, "11" => 6, "12" => 0, "13" => 0, "14" => 32, "2" => 4, "3" => 48, "4" => 1, "5" => 78, "6" => 0, "7" => 0, "8" => 0, "9" => 0}
# [debug] HANDLED lwp_message INCOMING ON lwp (BrickScriptCollectiveWeb.LWPChannel) in 22µs
#   Parameters: %{"0" => 15, "1" => 0, "10" => 16, "11" => 1, "12" => 0, "13" => 0, "14" => 16, "2" => 4, "3" => 59, "4" => 1, "5" => 21, "6" => 0, "7" => 1, "8" => 0, "9" => 0}
# [debug] HANDLED lwp_message INCOMING ON lwp (BrickScriptCollectiveWeb.LWPChannel) in 95µs
#   Parameters: %{"0" => 15, "1" => 0, "10" => 16, "11" => 1, "12" => 0, "13" => 0, "14" => 16, "2" => 4, "3" => 60, "4" => 1, "5" => 20, "6" => 0, "7" => 1, "8" => 0, "9" => 0}
# #PID<0.14451.0>

# Color sensor
# Parameters: %{"0" => 15, "1" => 0, "10" => 16, "11" => 0, "12" => 0, "13" => 0, "14" => 16, "2" => 4, "3" => 1, "4" => 1, "5" => 61, "6" => 0, "7" => 0, "8" => 0, "9" => 0}

# Detached
# Parameters: %{"0" => 5, "1" => 0, "2" => 4, "3" => 1, "4" => 0}
# force sensor
# Parameters: %{"0" => 15, "1" => 0, "10" => 16, "11" => 0, "12" => 0, "13" => 0, "14" => 16, "2" => 4, "3" => 0, "4" => 1, "5" => 63, "6" => 0, "7" => 0, "8" => 0, "9" => 0}

# small motor
# Parameters: %{"0" => 15, "1" => 0, "10" => 0, "11" => 0, "12" => 0, "13" => 3, "14" => 16, "2" => 4, "3" => 0, "4" => 1, "5" => 65, "6" => 0, "7" => 1, "8" => 0, "9" => 0}
