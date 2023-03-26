defmodule ExChat.Repo.Migrations.CreateChat do
  use Ecto.Migration

  def change do
    create table(:chat) do
      add :name, :string

      timestamps()
    end
  end
end
