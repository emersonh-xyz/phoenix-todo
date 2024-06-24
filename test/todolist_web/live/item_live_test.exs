defmodule TodolistWeb.ItemLiveTest do
  use TodolistWeb.ConnCase

  import Phoenix.LiveViewTest
  import Todolist.ListFixtures

  @create_attrs %{date: "2024-06-20T19:19:00", title: "some title", completed: true}
  @update_attrs %{date: "2024-06-21T19:19:00", title: "some updated title", completed: false}
  @invalid_attrs %{date: nil, title: nil, completed: false}

  defp create_item(_) do
    item = item_fixture()
    %{item: item}
  end

  describe "Index" do
    setup [:create_item]

    test "lists all items", %{conn: conn, item: item} do
      {:ok, _index_live, html} = live(conn, ~p"/items")

      assert html =~ "Listing Items"
      assert html =~ item.title
    end

    test "saves new item", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/items")

      assert index_live |> element("a", "New Item") |> render_click() =~
               "New Item"

      assert_patch(index_live, ~p"/items/new")

      assert index_live
             |> form("#item-form", item: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#item-form", item: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/items")

      html = render(index_live)
      assert html =~ "Item created successfully"
      assert html =~ "some title"
    end

    test "updates item in listing", %{conn: conn, item: item} do
      {:ok, index_live, _html} = live(conn, ~p"/items")

      assert index_live |> element("#items-#{item.id} a", "Edit") |> render_click() =~
               "Edit Item"

      assert_patch(index_live, ~p"/items/#{item}/edit")

      assert index_live
             |> form("#item-form", item: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#item-form", item: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/items")

      html = render(index_live)
      assert html =~ "Item updated successfully"
      assert html =~ "some updated title"
    end

    test "deletes item in listing", %{conn: conn, item: item} do
      {:ok, index_live, _html} = live(conn, ~p"/items")

      assert index_live |> element("#items-#{item.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#items-#{item.id}")
    end
  end

  describe "Show" do
    setup [:create_item]

    test "displays item", %{conn: conn, item: item} do
      {:ok, _show_live, html} = live(conn, ~p"/items/#{item}")

      assert html =~ "Show Item"
      assert html =~ item.title
    end

    test "updates item within modal", %{conn: conn, item: item} do
      {:ok, show_live, _html} = live(conn, ~p"/items/#{item}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Item"

      assert_patch(show_live, ~p"/items/#{item}/show/edit")

      assert show_live
             |> form("#item-form", item: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#item-form", item: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/items/#{item}")

      html = render(show_live)
      assert html =~ "Item updated successfully"
      assert html =~ "some updated title"
    end
  end
end
