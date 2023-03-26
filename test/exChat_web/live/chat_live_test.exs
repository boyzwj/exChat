defmodule ExChatWeb.ChatLiveTest do
  use ExChatWeb.ConnCase

  import Phoenix.LiveViewTest
  import ExChat.AccountsFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_chat(_) do
    chat = chat_fixture()
    %{chat: chat}
  end

  describe "Index" do
    setup [:create_chat]

    test "lists all chat", %{conn: conn, chat: chat} do
      {:ok, _index_live, html} = live(conn, ~p"/chat")

      assert html =~ "Listing Chat"
      assert html =~ chat.name
    end

    test "saves new chat", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/chat")

      assert index_live |> element("a", "New Chat") |> render_click() =~
               "New Chat"

      assert_patch(index_live, ~p"/chat/new")

      assert index_live
             |> form("#chat-form", chat: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#chat-form", chat: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/chat")

      html = render(index_live)
      assert html =~ "Chat created successfully"
      assert html =~ "some name"
    end

    test "updates chat in listing", %{conn: conn, chat: chat} do
      {:ok, index_live, _html} = live(conn, ~p"/chat")

      assert index_live |> element("#chat-#{chat.id} a", "Edit") |> render_click() =~
               "Edit Chat"

      assert_patch(index_live, ~p"/chat/#{chat}/edit")

      assert index_live
             |> form("#chat-form", chat: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#chat-form", chat: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/chat")

      html = render(index_live)
      assert html =~ "Chat updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes chat in listing", %{conn: conn, chat: chat} do
      {:ok, index_live, _html} = live(conn, ~p"/chat")

      assert index_live |> element("#chat-#{chat.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#chat-#{chat.id}")
    end
  end

  describe "Show" do
    setup [:create_chat]

    test "displays chat", %{conn: conn, chat: chat} do
      {:ok, _show_live, html} = live(conn, ~p"/chat/#{chat}")

      assert html =~ "Show Chat"
      assert html =~ chat.name
    end

    test "updates chat within modal", %{conn: conn, chat: chat} do
      {:ok, show_live, _html} = live(conn, ~p"/chat/#{chat}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Chat"

      assert_patch(show_live, ~p"/chat/#{chat}/show/edit")

      assert show_live
             |> form("#chat-form", chat: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#chat-form", chat: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/chat/#{chat}")

      html = render(show_live)
      assert html =~ "Chat updated successfully"
      assert html =~ "some updated name"
    end
  end
end
