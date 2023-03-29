defmodule ExChatWeb.ChatLive.Index do
  use ExChatWeb, :live_view

  alias ExChat.Accounts
  alias ExChat.Accounts.Chat
  alias ExChat.Accounts.Message
  use Common

  @impl true
  def mount(_params, _session, socket) do
    IO.inspect(socket.assigns.current_user, label: "user")

    socket =
      socket
      |> assign(
        topics: [],
        input_text: "",
        current_topic: "",
        cur_msg_index: 0
      )
      |> stream(:messages, [], dom_id: &"message-#{&1.index}")

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Chat")
    |> assign(:chat, Accounts.get_chat!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Chat")
    |> assign(:chat, %Chat{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Chat")
    |> assign(:chat, nil)
  end

  @impl true
  def handle_info({ExChatWeb.ChatLive.FormComponent, {:saved, chat}}, socket) do
    {:noreply, stream_insert(socket, :chat_collection, chat)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    chat = Accounts.get_chat!(id)
    {:ok, _} = Accounts.delete_chat(chat)

    {:noreply, stream_delete(socket, :chat_collection, chat)}
  end

  def handle_event("send_message", ~m{content}, socket) do
    with content when content != "" <- String.trim(content) do
      role = "user"
      index = socket.assigns.cur_msg_index + 1
      message = ~M{%Message content,role,index}
      IO.inspect(message)

      socket =
        stream_insert(socket, :messages, message)
        |> assign(:cur_msg_index, index)

      {:noreply, socket}
    else
      _ ->
        {:noreply, socket}
    end
  end
end
