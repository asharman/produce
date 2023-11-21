defmodule Produce.FoodStorageFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Produce.FoodStorage` context.
  """

  @doc """
  Generate a grocery.
  """
  def grocery_fixture(attrs \\ %{}) do
    {:ok, grocery} =
      attrs
      |> Enum.into(%{
        name: "some name",
        quantity: 42
      })
      |> Produce.FoodStorage.create_grocery()

    grocery
  end
end
