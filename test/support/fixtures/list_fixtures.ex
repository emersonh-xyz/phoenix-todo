defmodule Todolist.ListFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Todolist.List` context.
  """

  @doc """
  Generate a item.
  """
  def item_fixture(attrs \\ %{}) do
    {:ok, item} =
      attrs
      |> Enum.into(%{
        completed: true,
        date: ~N[2024-06-20 19:19:00],
        title: "some title"
      })
      |> Todolist.List.create_item()

    item
  end
end
