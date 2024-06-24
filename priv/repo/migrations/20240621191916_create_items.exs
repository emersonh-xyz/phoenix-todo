defmodule Todolist.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :title, :string
      add :completed, :boolean, default: false, null: false
      add :date, :naive_datetime
      add :username, :string

      timestamps(type: :utc_datetime)
    end
  end
end
