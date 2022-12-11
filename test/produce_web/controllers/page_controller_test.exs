defmodule ProduceWeb.PageControllerTest do
  use ProduceWeb.ConnCase

  describe "GET /" do
    test "Returns a 200 Response", %{conn: conn} do
      conn = get(conn, "/")
      assert html_response(conn, 200) =~ "Add new Produce"
    end

    test "Contains a form that POSTs to /inventory/add", %{conn: conn} do
      conn = get(conn, "/")
      assert html_response(conn, 200) =~ "<form action=\"/inventory/add\" method=\"post\">"
    end
  end
end
