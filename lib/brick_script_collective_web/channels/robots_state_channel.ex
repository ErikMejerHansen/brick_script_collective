defmodule BrickScriptCollectiveWeb.RobotsStateChannel do
  use BrickScriptCollectiveWeb, :channel

  @impl true
  def join("robots_state", _payload, socket) do
    {:ok, socket}
  end
end
