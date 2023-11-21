defmodule ProduceWeb.GroceryLive.Index do
  use ProduceWeb, :live_view

  alias Produce.FoodStorage
  alias Produce.FoodStorage.Grocery

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :groceries, FoodStorage.list_groceries())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Grocery")
    |> assign(:grocery, FoodStorage.get_grocery!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Grocery")
    |> assign(:grocery, %Grocery{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Groceries")
    |> assign(:grocery, nil)
  end

  @impl true
  def handle_info({ProduceWeb.GroceryLive.FormComponent, {:saved, grocery}}, socket) do
    {:noreply, stream_insert(socket, :groceries, grocery)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    grocery = FoodStorage.get_grocery!(id)
    {:ok, _} = FoodStorage.delete_grocery(grocery)

    {:noreply, stream_delete(socket, :groceries, grocery)}
  end
end
