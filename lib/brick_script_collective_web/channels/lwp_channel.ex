defmodule BrickScriptCollectiveWeb.LWPChannel do
  alias BrickScriptCollective.RobotsState
  alias BrickScriptCollective.Lwp.LwpMessageParser
  use BrickScriptCollectiveWeb, :channel

  @impl true
  def join("lwp", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_in("lwp_message", payload, socket) do
    message = LwpMessageParser.parse(payload)

    IO.inspect("Got message")

    if message.header.type == :hub_attached_io do
      reply =
        RobotsState.handle_attach_message(message)
        |> Enum.into(<<>>, fn byte -> <<byte::8>> end)

      IO.inspect("Pushing")

      unless byte_size(reply) == 0 do
        push(socket, "to_robot", {:binary, reply})
      end
    end

    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
