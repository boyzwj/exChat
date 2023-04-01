defmodule ExChatWeb.ChatLive.Index do
  use ExChatWeb, :live_view
  import Phoenix.LiveView

  alias ExChat.OpenAi
  alias ExChat.Accounts
  alias ExChat.Accounts.Chat
  alias ExChat.Accounts.Message
  use Common

  @status_ready 0
  @status_waiting 1

  @impl true
  def mount(_params, _session, socket) do
    Logger.debug("mounting chat live view #{inspect(socket.assigns.current_user)}",
      tag: "chat_live_view"
    )

    socket =
      socket
      |> assign(
        topics: [],
        input_text: "",
        current_topic: "",
        cur_msg_index: 0,
        messages: [],
        status: @status_ready
      )

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
  def handle_info({:chat_message, content}, socket) do
    role = "system"
    index = socket.assigns.cur_msg_index + 1
    message = ~M{%Message content,role,index}
    messages = [message | socket.assigns.messages]

    socket =
      socket
      |> assign(:messages, messages)
      |> assign(:cur_msg_index, index)
      |> assign(:status, @status_ready)

    {:noreply, socket}
  end

  def handle_info(:get_response, socket) do
    messages =
      for ~M{role,content} <- socket.assigns.messages do
        ~M{role,content}
      end

    with {:ok, ~m{choices}} <- OpenAi.Worker.do_request(messages),
         [~m{message} | _] <- choices,
         ~m{content,role} <- message do
      index = socket.assigns.cur_msg_index + 1
      message = ~M{%Message content,role,index}
      messages = [message | socket.assigns.messages]

      socket =
        socket
        |> assign(:messages, messages)
        |> assign(:cur_msg_index, index)
        |> assign(:status, @status_ready)

      {:noreply, socket}
    else
      {:error, error} ->
        Logger.error("error getting response: #{inspect(error)}")

        socket =
          socket
          |> assign(:status, @status_ready)
          |> put_flash(:error, error)

        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("user_message", ~m{content}, socket) do
    with content when content != "" <- String.trim(content) do
      role = "user"
      index = socket.assigns.cur_msg_index + 1
      message = ~M{%Message content,role,index}
      messages = [message | socket.assigns.messages]

      socket =
        socket
        |> assign(:messages, messages)
        |> assign(:cur_msg_index, index)
        |> assign(:status, @status_waiting)
        |> push_event("scroll_to_bottom", %{})

      send(self(), :get_response)
      {:noreply, socket}
    else
      _ ->
        {:noreply, socket}
    end
  end

  # defp assign_messages(socket, messages) do
  #   socket
  #   |> assign(:messages, messages)
  #   |> assign(:cur_msg_index, Enum.count(messages))
  # end
end
