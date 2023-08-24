defmodule BrickScriptCollectiveWeb.CanvasLive.Index do
  alias BrickScriptCollective.Presence
  alias BrickScriptCollective.PubSub

  use BrickScriptCollectiveWeb, :live_view

  # alias BrickScriptCollective.Canvas

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Presence.track(self(), "users", BrickScriptCollective.unique_name(), %{status: "tinkering"})
      Phoenix.PubSub.subscribe(PubSub, "users")
    end

    connected_users = Presence.list("users") |> Enum.map(&elem(&1, 0))

    {:ok,
     socket
     |> stream_configure(:connected_users, dom_id: & &1)
     |> stream(:connected_users, connected_users)}
  end

  @impl true
  def handle_info(%{payload: %{joins: joins, leaves: leaves}}, socket) do
    # IO.inspect("Handle info")
    # IO.inspect(Presence.list("users"))
    # IO.inspect(Map.keys(joins))
    # IO.inspect(Map.keys(leaves))

    socket =
      leaves
      |> Map.keys()
      |> Enum.reduce(socket, &stream_delete_by_dom_id(&2, :connected_users, &1))

    socket =
      joins
      |> Map.keys()
      |> Enum.reduce(socket, &stream_insert(&2, :connected_users, &1))

    {:noreply, socket}
  end

  # @impl true
  # def handle_params(params, _url, socket) do
  #   {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  # end

  # defp apply_action(socket, :edit, %{"id" => id}) do
  #   socket
  #   |> assign(:page_title, "Edit User")
  #   |> assign(:user, Canvas.get_user!(id))
  # end

  # defp apply_action(socket, :new, _params) do
  #   socket
  #   |> assign(:page_title, "New User")
  #   |> assign(:user, %User{})
  # end

  # defp apply_action(socket, :index, _params) do
  #   socket
  #   |> assign(:page_title, "Listing Userss")
  #   |> assign(:user, nil)
  # end

  # @impl true
  # def handle_info({BrickScriptCollectiveWeb.UserLive.FormComponent, {:saved, user}}, socket) do
  #   {:noreply, stream_insert(socket, :userss, user)}
  # end

  # @impl true
  # def handle_event("delete", %{"id" => id}, socket) do
  #   user = Canvas.get_user!(id)
  #   {:ok, _} = Canvas.delete_user(user)

  #   {:noreply, stream_delete(socket, :userss, user)}
  # end
end
