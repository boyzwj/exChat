defmodule ExChat.Repo.Migrations.CreateChat do
  use Ecto.Migration

  def change do
    create table(:chat) do
      add :user_id, :integer
      add :topic, :string
      add :messages, :binary
      timestamps()
    end

    create index(:chat, [:user_id])
  end
end
