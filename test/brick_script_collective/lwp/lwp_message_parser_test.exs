defmodule BrickScriptCollective.Lwp.LwpMessageParserTest do
  use ExUnit.Case, async: true
  alias BrickScriptCollective.Lwp.LwpMessageParser

  describe "parsing LWP messages" do
    test "it detects attachment of color sensor" do
      message = <<
        # Message length
        15,
        # Hub Id (always set to 0)
        0,
        # Message type
        4,
        # Attached IO
        1,
        # Hardware revision start
        1,
        61,
        0,
        0,
        0,
        # Hardware revision end
        0,
        # Software revision start
        16,
        0,
        0,
        0,
        # Software revision end
        16
      >>

      parsed = LwpMessageParser.parse({:binary, message})

      assert parsed.header.length == 15
      assert parsed.header.type == :hub_attached_io
      assert parsed.payload.io_type == :color_sensor
    end

    test "it detects attachment of small motor" do
      message = <<
        15,
        0,
        4,
        0,
        1,
        65,
        0,
        1,
        0,
        0,
        0,
        0,
        0,
        3,
        16
      >>

      parsed = LwpMessageParser.parse({:binary, message})

      assert parsed.header.length == 15
      assert parsed.header.type == :hub_attached_io
      assert parsed.payload.io_type == :small_motor
    end

    test "it detects attachment of force sensor" do
      message = <<
        15,
        0,
        4,
        0,
        1,
        63,
        0,
        0,
        0,
        0,
        16,
        0,
        0,
        0,
        16
      >>

      parsed = LwpMessageParser.parse({:binary, message})

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

# Port info response force sensor
# Parameters: %{"0" => 11, "1" => 0, "10" => 0, "2" => 67, "3" => 0, "4" => 1, "5" => 6, "6" => 7, "7" => 63, "8" => 0, "9" => 0
# %{
#   "0" => 11,
#   "1" => 0,
#   "2" => 67,
#   "3" => 0,
#   "4" => 1, # in raw mode
#   "5" => 6,
#   "6" => 7,
#   "7" => 63,
#   "8" => 0,
#   "9" => 0
#   "10" => 0,
# }

# Port info respone empty port
# Parameters: %{"0" => 5, "1" => 0, "2" => 5, "3" => 33, "4" => 6}

# Port mode info mode combinations
# Parameters: %{"0" => 7, "1" => 0, "2" => 67, "3" => 0, "4" => 2, "5" => 63, "6" => 0}

# color sensor port mode response
# %{
#   "0" => 11, length
#   "1" => 0, hub id
#   "2" => 67, message type: Port information type
#   "3" => 0, Mode ifo
#   "4" => 1, Capabilities: input
#   "5" => 7,  Number of modes
#   "6" => 10,
#   "7" => 247,
#   "8" => 1,
#   "9" => 8
#   "10" => 0,
# }

# Mode info
# %{"0" => 7, "1" => 0, "2" => 67, "3" => 0, "4" => 2, "5" => 99, "6" => 0}

# Color sensor seems to be in reflectivity mode
