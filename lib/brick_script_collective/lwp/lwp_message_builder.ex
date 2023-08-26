defmodule BrickScriptCollective.Lwp.LwpMessageBuilder do
  def port_input_format_setup(port, mode, delta) do
    [
      # length
      0x10,
      # hub id
      0x00,
      # message type
      0x41,
      # port
      port,
      # mode to get info from (seems like 1 is touched)
      mode,
      # delta
      delta,
      # delta
      0x00,
      # delta
      0x00,
      # delta
      0x00,
      # enable notifications
      0x01
    ]
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
