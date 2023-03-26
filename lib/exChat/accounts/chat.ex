defmodule ExChat.Accounts.Chat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chat" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(chat, attrs) do
    chat
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
