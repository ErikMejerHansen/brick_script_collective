defmodule BrickScriptCollectiveWeb.UserLiveTest do
  use BrickScriptCollectiveWeb.ConnCase

  import Phoenix.LiveViewTest
  import BrickScriptCollective.CanvasFixtures

  @create_attrs %{foo: "some foo"}
  @update_attrs %{foo: "some updated foo"}
  @invalid_attrs %{foo: nil}

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end

  describe "Index" do
    setup [:create_user]

    test "lists all userss", %{conn: conn, user: user} do
      {:ok, _index_live, html} = live(conn, ~p"/userss")

      assert html =~ "Listing Userss"
      assert html =~ user.foo
    end

    test "saves new user", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/userss")

      assert index_live |> element("a", "New User") |> render_click() =~
               "New User"

      assert_patch(index_live, ~p"/userss/new")

      assert index_live
             |> form("#user-form", user: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#user-form", user: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/userss")

      html = render(index_live)
      assert html =~ "User created successfully"
      assert html =~ "some foo"
    end

    test "updates user in listing", %{conn: conn, user: user} do
      {:ok, index_live, _html} = live(conn, ~p"/userss")

      assert index_live |> element("#userss-#{user.id} a", "Edit") |> render_click() =~
               "Edit User"

      assert_patch(index_live, ~p"/userss/#{user}/edit")

      assert index_live
             |> form("#user-form", user: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#user-form", user: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/userss")

      html = render(index_live)
      assert html =~ "User updated successfully"
      assert html =~ "some updated foo"
    end

    test "deletes user in listing", %{conn: conn, user: user} do
      {:ok, index_live, _html} = live(conn, ~p"/userss")

      assert index_live |> element("#userss-#{user.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#userss-#{user.id}")
    end
  end

  describe "Show" do
    setup [:create_user]

    test "displays user", %{conn: conn, user: user} do
      {:ok, _show_live, html} = live(conn, ~p"/userss/#{user}")

      assert html =~ "Show User"
      assert html =~ user.foo
    end

    test "updates user within modal", %{conn: conn, user: user} do
      {:ok, show_live, _html} = live(conn, ~p"/userss/#{user}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit User"

      assert_patch(show_live, ~p"/userss/#{user}/show/edit")

      assert show_live
             |> form("#user-form", user: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#user-form", user: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/userss/#{user}")

      html = render(show_live)
      assert html =~ "User updated successfully"
      assert html =~ "some updated foo"
    end
  end
end
