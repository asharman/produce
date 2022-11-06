defmodule ProduceWeb.PageController do
  use ProduceWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
