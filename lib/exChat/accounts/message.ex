defmodule ExChat.Accounts.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "message" do
    field :chat_id, :integer
    field :index, :integer
    field :role, :string
    field :content, :string
    timestamps()
  end

  def changeset(message, attrs) do
    message
    |> cast(attrs, [:chat_id, :index, :role, :content])
    |> validate_required([:chat_id, :index, :role, :content])
  end
end
