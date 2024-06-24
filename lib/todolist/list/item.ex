defmodule Todolist.List.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :date, :naive_datetime
    field :title, :string
    field :completed, :boolean, default: false
    field :username, :string, default: "emerson"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:title])
    |> validate_required([:title])
    |> validate_length(:title, min: 5, max: 50)
  end
end
