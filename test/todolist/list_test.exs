defmodule Todolist.ListTest do
  use Todolist.DataCase

  alias Todolist.List

  describe "items" do
    alias Todolist.List.Item

    import Todolist.ListFixtures

    @invalid_attrs %{date: nil, title: nil, completed: nil}

    test "list_items/0 returns all items" do
      item = item_fixture()
      assert List.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert List.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      valid_attrs = %{date: ~N[2024-06-20 19:19:00], title: "some title", completed: true}

      assert {:ok, %Item{} = item} = List.create_item(valid_attrs)
      assert item.date == ~N[2024-06-20 19:19:00]
      assert item.title == "some title"
      assert item.completed == true
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = List.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      update_attrs = %{date: ~N[2024-06-21 19:19:00], title: "some updated title", completed: false}

      assert {:ok, %Item{} = item} = List.update_item(item, update_attrs)
      assert item.date == ~N[2024-06-21 19:19:00]
      assert item.title == "some updated title"
      assert item.completed == false
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = List.update_item(item, @invalid_attrs)
      assert item == List.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = List.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> List.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = List.change_item(item)
    end
  end
end
