defmodule ProduceWeb.PageController do
  use ProduceWeb, :controller

  def index(conn, _params) do
    new_form = ProduceWeb.Forms.AddProduce.changeset()
    render(conn, "index.html", form: new_form)
  end
end
