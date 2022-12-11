defmodule ProduceWeb.PageController do
  use ProduceWeb, :controller

  def index(conn, _params) do
    conn
    |> ProduceWeb.PageView.prep_for_render()
    |> render("index.html")
  end
end
