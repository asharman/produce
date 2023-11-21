defmodule Produce.FoodStorage.Grocery do
  use Ecto.Schema
  import Ecto.Changeset

  schema "groceries" do
    field :name, :string
    field :quantity, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(grocery, attrs) do
    grocery
    |> cast(attrs, [:name, :quantity])
    |> validate_required([:name, :quantity])
  end
end
