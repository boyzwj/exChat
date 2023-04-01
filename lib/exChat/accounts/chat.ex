defmodule ExChat.Accounts.Chat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chat" do
    field :user_id, :integer
    field :topic, :string
    field :messages, EctoMessages
    timestamps()
  end

  @doc false
  def changeset(chat, attrs) do
    chat
    |> cast(attrs, [:user_id, :topic, :messages])
    |> validate_required([:user_id, :topic, :messages])
  end
end
