defmodule ProduceWeb.PageView do
  use ProduceWeb, :view
  alias Plug.Conn

  @spec prep_for_render(Conn.t()) :: Conn.t()
  def prep_for_render(conn) do
    conn
    |> Conn.assign(:form, ProduceWeb.Forms.AddProduce.new_form())
    |> Conn.assign(:produce, Produce.list_produce())
  end
end
