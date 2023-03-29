defmodule ExChat.Accounts.Chat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chat" do
    field :user_id, :integer
    field :topic, :string
    timestamps()
  end

  @doc false
  def changeset(chat, attrs) do
    chat
    |> cast(attrs, [:user_id, :topic])
    |> validate_required([:user_id, :topic])
  end
end
