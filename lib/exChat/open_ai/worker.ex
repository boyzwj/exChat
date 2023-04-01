defmodule ExChat.OpenAi.Worker do
  use GenServer
  use Common

  @open_ai_comp_url "https://api.openai.com/v1/chat/completions"
  @model1 "gpt-3.5-turbo"
  @model2 "gpt-4"

  defp worker_name(id) do
    :"#{__MODULE__}_#{id}"
  end

  @spec start_link :: :ignore | {:error, any} | {:ok, pid}
  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:ok, nil}
  end

  def handle_call({:send_message, message}, _from, state) do
    {:reply, {:ok, message}, state}
  end

  def handle_call({:get_message, messages}, _from, state) do
    reply = do_request(messages)
    {:reply, reply, state}
  end

  def do_request(messages, model \\ @model1) do
    messages = Enum.reverse(messages)
    data = Jason.encode!(~M{model,messages})

    headers = [
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer #{System.get_env("OPEN_AI_KEY")}"}
    ]

    with {:ok, %Finch.Response{status: 200, body: body}} <-
           Finch.build(:post, @open_ai_comp_url, headers, data, [])
           |> Finch.request(ExChat.Finch, receive_timeout: 60_000) do
      {:ok, Jason.decode!(body)}
    else
      {:ok, %Finch.Response{status: 401, body: body}} ->
        ~m{error} = Jason.decode!(body)
        {:error, error["message"]}

      {:error, error} ->
        {:error, error}
    end
  end
end
