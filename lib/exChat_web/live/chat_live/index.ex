defmodule ExChatWeb.ChatLive.Index do
  use ExChatWeb, :live_view

  alias ExChat.Accounts
  alias ExChat.Accounts.Chat

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :chat_collection, Accounts.list_chat())}
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
end
