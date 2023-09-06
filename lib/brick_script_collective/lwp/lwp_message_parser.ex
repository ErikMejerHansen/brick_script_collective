defmodule BrickScriptCollective.Lwp.LwpMessageParser do
  def parse(<<header::bitstring-size(3 * 8), payload::bitstring>>) do
    parsed_header = parse_common_message_header(header)
    parsed_payload = parse(parsed_header.type, payload)

    %{header: parsed_header, payload: parsed_payload}
  end

  defp parse_common_message_header(
         <<length::integer-size(8), 0::integer-size(8), message_type::integer-size(8)>>
       ) do
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

  defp parse(:hub_attached_io, <<port_id::integer-size(8), 0x00::integer-size(8)>>) do
    %{event: :detached, port: port_id}
  end

  defp parse(
         :hub_attached_io,
         <<
           port_id::integer-size(8),
           0x01::integer-size(8),
           type::bitstring-size(8 * 2),
           _rest::bitstring
         >>
       ) do
    %{event: :attached, port: port_id, io_type: parse_io_type(type)}
  end

  defp parse(
         :hub_attached_io,
         <<
           port_id::integer-size(8),
           0x02::integer-size(8),
           type::bitstring-size(8 * 2),
           _rest::bitstring
         >>
       ) do
    %{event: :attached_virtual, port: port_id, io_type: parse_io_type(type)}
  end

  defp parse(:port_value_single_mode, <<
         port_id::integer-size(8),
         value::integer-size(8)
       >>) do
    %{event: :value_change, port: port_id, value: value}
  end

  defp parse(:port_output_command_feedback, <<
         port_id::integer-size(8),
         message::integer-size(8)
       >>) do
    message =
      case message do
        0x01 -> :in_progress
        0x02 -> :completed
        0x04 -> :discarded
        0x08 -> :idle
        0x10 -> :done
        0x0A -> :done
        _ -> :done
      end

    %{event: :port_output_command_feedback, port: port_id, message: message}
  end

  defp parse(_, _) do
    %{event: :ignored}
  end

  defp parse_io_type(<<type_msb::bitstring-size(8), _type_lsb::bitstring-size(8)>>) do
    case type_msb do
      <<0x3D>> -> :color_sensor
      <<0x3F>> -> :force_sensor
      <<0x30>> -> :small_motor
      <<0x41>> -> :small_motor
      _ -> :unknown
    end
  end
end
