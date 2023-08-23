defmodule BrickScriptCollectiveWeb.CanvasLive.Index do
  use BrickScriptCollectiveWeb, :live_view

  # alias BrickScriptCollective.Canvas

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
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
