defmodule BrickScriptCollective.Lwp.LwpMessageBuilder do
  def port_input_format_setup(port, mode, delta) do
    <<
      # length
      0x10::integer-size(8),
      # hub id
      0x00::integer-size(8),
      # message type
      0x41::integer-size(8),
      # port
      port,
      # mode to get info from (seems like 1 is touched)
      mode::integer-size(8),
      # delta
      delta::integer-size(8),
      # delta
      0x00::integer-size(8),
      # delta
      0x00::integer-size(8),
      # delta
      0x00::integer-size(8),
      # enable notifications
      0x01::integer-size(8)
    >>
  end

  def start_motor_for_time(port, time, speed) do
    # [0x09, 0x00, 0x81, 0x00, 0b00010001, 0x09, 0x64, 0x02, 0x50, 0x64, 0x00, 0x00]
    <<
      # Length
      0x09::integer-size(8),
      # HubId
      0x00::integer-size(8),
      # Command: port output command
      0x81::integer-size(8),
      port,
      # Execute immediately, Command feedback
      0b00010001::integer-size(8),
      time::integer-size(2 * 8),
      speed,
      # Max power
      0x64::integer-size(8),
      # End state (float)
      0x00::integer-size(8),
      # Don't use any acceleration or deceleration profile
      0x00::integer-size(8)
    >>
  end
end

# Message header
# length
# hub_id - always 0
# message type

# Port information request
# 0x05, # Length
# 0x00, # Hub id
# 0x21, # info type
# 0x00, # Port a?
# 0x01 # mode info

# Set delta for force sensor
# 0x10, # length
# 0x00, # hub id
# 0x41, # message type
# 0x00, # port
# 0x01, # mode to get info from (seems like 1 is touched)
# 0x01, # delta
# 0x00, # delta
# 0x00, # delta
# 0x00, # delta
# 0x01 # enable notifications

# Color sensor mode 0x00 is color index. 255 == none

# Set delta for color sensor
# 0x10, # length
# 0x00, # hub id
# 0x41, # message type
# 0x00, # port
# 0x01, # mode to get info from (seems like 1 is reflectivity, 0=?, 2 is ambient light, 3=?, 4=? RGB raw?, 5=?, 6=?, )
# 0x01, # delta
# 0x00, # delta
# 0x00, # delta
# 0x00, # delta
# 0x01 # enable notifications
