defmodule BrickScriptCollective.Lwp.LwpMessageParser do
  def parse(message) do
    message = convert_to_list(message)
    header = message |> Enum.take(3) |> parse_common_message_header()
    payload = parse(header.type, message |> Enum.drop(3))

    %{header: header, payload: payload}
  end

  defp convert_to_list(message) when is_map(message) do
    message
    |> Map.to_list()
    |> Enum.map(fn {key, value} ->
      {key, _rest} = Integer.parse(key)
      {key, value}
    end)
    |> Enum.sort()
    |> Enum.map(&elem(&1, 1))
  end

  defp parse_common_message_header([length, 0, message_type]) do
    # assuming message length are kept below 128
    message_type =
      case message_type do
        0x01 -> :hub_properties
        0x02 -> :hub_actions
        0x03 -> :hub_alerts
        0x04 -> :hub_attached_io
        0x05 -> :generic_error
        0x43 -> :port_information
        0x44 -> :port_mode_information
        0x45 -> :port_value_single_mode
        0x46 -> :port_mode_combined_mode
        0x47 -> :port_input_format_single_mode
        0x48 -> :port_input_format_combined_mode
        0x82 -> :port_output_command_feedback
        _ -> raise "Unknown message type #{message_type}"
      end

    %{length: length, type: message_type}
  end

  defp parse(:hub_attached_io, [port_id, 0x00 | _rest]) do
    %{event: :detached, port: port_id}
  end

  defp parse(:hub_attached_io, [port_id, 0x01, type_msb, type_lsb | _rest]) do
    %{event: :attached, port: port_id, io_type: parse_io_type(type_msb, type_lsb)}
  end

  defp parse(:hub_attached_io, [port_id, 0x02, type_msb, type_lsb | _rest]) do
    %{event: :attached_virtual, port: port_id, io_type: parse_io_type(type_msb, type_lsb)}
  end

  defp parse(_, _) do
    %{event: :ignored}
  end

  defp parse_io_type(type_lsb, _type_msb) do
    case type_lsb do
      0x3D -> :color_sensor
      0x3F -> :force_sensor
      0x41 -> :small_motor
      _ -> :unknown
    end
  end
end
