defmodule ExChat.Repo.Migrations.CreateChat do
  use Ecto.Migration

  def change do
    create table(:chat) do
      add :user_id, :integer
      add :topic, :string
      timestamps()
    end

    create index(:chat, [:user_id])

    create table(:message) do
      add :chat_id, :integer
      add :index, :integer
      add :role, :string
      add :content, :string
      timestamps()
    end

    create index(:message, [:chat_id])
  end
end
