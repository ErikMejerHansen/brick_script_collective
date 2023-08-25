defmodule BrickScriptCollectiveWeb.CanvasLive.Index do
  alias BrickScriptCollective.Presence
  alias BrickScriptCollective.PubSub

  use BrickScriptCollectiveWeb, :live_view

  # alias BrickScriptCollective.Canvas

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      {user_name, user_color} = BrickScriptCollective.unique_name_and_color()

      Presence.track(self(), "users", user_name, %{accent: user_color})
      Phoenix.PubSub.subscribe(PubSub, "users")
    end

    connected_users = Presence.list("users") |> Enum.map(&presence_to_view_model/1)

    {:ok,
     socket
     |> stream_configure(:connected_users, dom_id: & &1[:dom_id])
     |> stream(:connected_users, connected_users)}
  end

  @impl true
  def handle_info(%{payload: %{joins: joins, leaves: leaves}}, socket) do
    socket =
      leaves
      |> Enum.map(&presence_to_view_model/1)
      |> Enum.reduce(socket, fn leaver, acc ->
        stream_delete_by_dom_id(acc, :connected_users, leaver.dom_id)
      end)

    socket =
      joins
      |> Enum.map(&presence_to_view_model/1)
      |> Enum.reduce(socket, fn joiner, acc ->
        stream_insert(acc, :connected_users, joiner)
      end)

    {:noreply, socket}
  end

  defp presence_to_view_model({user_name, %{metas: [%{accent: accent, phx_ref: ref}]}}) do
    %{
      dom_id: ref,
      name: user_name,
      accent: accent
    }
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
