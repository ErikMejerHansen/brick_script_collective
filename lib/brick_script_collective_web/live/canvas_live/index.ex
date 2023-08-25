defmodule BrickScriptCollectiveWeb.CanvasLive.Index do
  alias BrickScriptCollective.Presence
  alias BrickScriptCollective.PubSub

  use BrickScriptCollectiveWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      {user_name, _} = BrickScriptCollective.unique_name_and_color()

      socket =
        socket
        |> assign(:user_name, user_name)

      Presence.track(self(), "users", socket.assigns[:user_name], %{robot_connected: false})
      Phoenix.PubSub.subscribe(PubSub, "users")

      connected_users = Presence.list("users") |> Enum.map(&presence_to_view_model/1)

      {:ok,
       socket
       |> stream_configure(:connected_users, dom_id: & &1[:dom_id])
       |> stream(:connected_users, connected_users)}
    else
      {:ok,
       socket
       |> stream_configure(:connected_users, dom_id: & &1[:dom_id])
       |> stream(:connected_users, [])}
    end
  end

  @impl true
  def handle_info(%Phoenix.Socket.Broadcast{event: "presence_diff", payload: diff}, socket) do
    socket =
      diff.leaves
      |> Enum.map(&presence_to_view_model/1)
      |> Enum.reduce(socket, fn leaver, acc ->
        stream_delete_by_dom_id(acc, :connected_users, leaver.dom_id)
      end)

    socket =
      diff.joins
      |> Enum.map(&presence_to_view_model/1)
      |> Enum.reduce(socket, fn joiner, acc ->
        stream_insert(acc, :connected_users, joiner)
      end)

    {:noreply, socket}
  end

  defp presence_to_view_model(
         {user_name, %{metas: [%{phx_ref: ref, robot_connected: robot_connected}]}}
       ) do
    %{
      dom_id: ref,
      name: user_name,
      robot_connected: robot_connected
    }
  end

  @impl true
  def handle_event("robot-connected", %{}, socket) do
    Presence.update(
      self(),
      "users",
      socket.assigns[:user_name],
      &Map.put(&1, :robot_connected, true)
    )

    {:noreply, socket}
  end
end
