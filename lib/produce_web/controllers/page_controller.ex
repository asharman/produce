defmodule ProduceWeb.PageController do
  use ProduceWeb, :controller

  def index(conn, _params) do
    new_form = ProduceWeb.Forms.AddProduce.new_form()
    render(conn, "index.html", form: new_form)
  end
end
