defmodule ProduceWeb.InventoryController do
  use ProduceWeb, :controller
  alias ProduceWeb.Forms

  @spec add(Plug.Conn.t(), %{String.t() => %{optional(binary) => binary}}) :: Plug.Conn.t()
  def add(conn, %{"produce" => add_produce_params}) do
    with {_form, %{produce: produce, quantity: quantity}} <-
           Forms.AddProduce.validate(add_produce_params),
         :ok <- Produce.add_produce(produce, quantity) do
      conn
      |> put_flash(:info, "Your produce was successfully added")
      |> redirect(to: Routes.page_path(conn, :index))
    else
      {:error, error} ->
        conn
        |> put_flash(:error, error)
        |> redirect(to: Routes.page_path(conn, :index))

      {invalid_form, nil} ->
        conn
        |> put_flash(:error, "Some values entered are invalid")
        |> put_view(ProduceWeb.PageView)
        |> render("index.html", form: invalid_form)
    end
  end
end
