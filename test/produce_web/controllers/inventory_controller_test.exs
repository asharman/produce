defmodule ProduceWeb.InventoryControllerTest do
  use ProduceWeb.ConnCase
  @add_attrs %{"produce" => %{"name" => "Strawberry", "quantity" => "5"}}
  @invalid_attrs %{"produce" => %{"name" => "", "quantity" => "-5"}}

  describe "POST /inventory/add" do
    test "Redirects to index with an info flash on success", %{conn: conn} do
      conn = post(conn, "/inventory/add", @add_attrs)

      assert redirected_to(conn) === Routes.page_path(conn, :index)
      assert %{"info" => _message} = get_flash(conn)
    end

    test "Renders index with error messages on the form", %{conn: conn} do
      conn = post(conn, "/inventory/add", @invalid_attrs)

      assert %{"error" => _message} = get_flash(conn)
      assert html_response(conn, 200) =~ "phx-feedback-for=\"produce[name]\""
      assert html_response(conn, 200) =~ "phx-feedback-for=\"produce[quantity]\""
    end
  end
end
