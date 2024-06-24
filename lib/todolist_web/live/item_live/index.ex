defmodule TodolistWeb.ItemLive.Index do
  use TodolistWeb, :live_view

  alias Todolist.List
  alias Todolist.List.Item

  @impl true
  def mount(_params, _session, socket) do
    items = Todolist.List.list_items(1)
    total_pages = Todolist.List.total_pages()

    {:ok,
     assign(socket, :items, items)
     |> assign(:current_page, 1)
     |> assign(:total_pages, total_pages)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Item")
    |> assign(:item, List.get_item!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Item")
    |> assign(:item, %Item{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Items")
    |> assign(:item, nil)
  end

  @impl true
  def handle_info({TodolistWeb.ItemLive.FormComponent, {:saved, item}}, socket) do
    {:noreply, stream_insert(socket, :items, item)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    item = List.get_item!(id)
    {:ok, _} = List.delete_item(item)

    {:noreply, stream_delete(socket, :items, item)}
  end

  def handle_event("next_page", _value, socket) do
    total_pages = socket.assigns.total_pages
    current_page = socket.assigns.current_page

    # if we are on max pages then do nothing
    if current_page === total_pages do
      {:noreply, socket}
    else
      next_page = current_page + 1
      next_items = Todolist.List.list_items(next_page)

      socket =
        assign(socket, :items, next_items)
        |> assign(:current_page, next_page)

      {:noreply, socket}
    end
  end

  def handle_event("prev_page", _value, socket) do
    current_page = socket.assigns.current_page

    # if we are on the first page do nothing
    if current_page === 1 do
      {:noreply, socket}
    else
      IO.puts(~c"here")
      new_page = current_page - 1
      prev_items = Todolist.List.list_items(new_page)

      socket =
        assign(socket, :items, prev_items)
        |> assign(:current_page, new_page)

      {:noreply, socket}
    end
  end

  def handle_event("toggle_item", %{"item_id" => value}, socket) do
    item = Todolist.List.get_item!(value)

    new_item = %{
      title: item.title,
      username: item.username,
      date: item.date,
      completed: !item.completed
    }

    {:ok, %Item{} = item} = Todolist.List.update_item(item, new_item)

    {:noreply,
     socket
     |> put_flash(:info, "Item updated successfully")}
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-4">
      <h1 class="text-lg mb-8">To-do App</h1>
      <div class="flex flex-col">
        <%= for item <- @items do %>
          <div class="flex items-center gap-2">
            <%= if item.completed do %>
              <input
                phx-click={JS.push("toggle_item", value: %{item_id: item.id})}
                checked
                type="checkbox"
              />
            <% else %>
              <input type="checkbox" />
            <% end %>
            <label for="scales">
              <%= item.title %>
            </label>
          </div>
        <% end %>
      </div>
      <div class="flex flex-col gap-2 mt-8 items-start">
        <div class="flex gap-2">
          <%= if @current_page === 1 do %>
            <button disabled class="bg-red-200" phx-click="prev_page">Prev page</button>
          <% else %>
            <button class="bg-green-200" phx-click="prev_page">Prev page</button>
          <% end %>
          <%= if @current_page === @total_pages do %>
            <button disabled class="bg-red-200" phx-click="next_page">Next page</button>
          <% else %>
            <button class="bg-green-200" phx-click="next_page">Next page</button>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
