defmodule BrickScriptCollectiveWeb.LWPChannel do
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
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
