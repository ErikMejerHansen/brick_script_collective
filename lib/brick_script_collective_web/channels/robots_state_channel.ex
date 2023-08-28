defmodule BrickScriptCollectiveWeb.RobotsStateChannel do
  use BrickScriptCollectiveWeb, :channel

  @impl true
  def join("robots_state", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  defp authorized?(_payload) do
    true
  end
end
