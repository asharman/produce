defmodule DomainTypes.InventoryTest do
  use ExUnit.Case, async: true
  alias DomainTypes.Inventory
  alias DomainTypes.Produce

  describe "new/0" do
    test "returns an empty Inventory" do
      assert inventory1 = Inventory.new()
      assert inventory2 = Inventory.new()

      assert inventory1 == inventory2
    end
  end

  describe "add/4" do
    setup do
      {:ok, produce} = Produce.new("strawberry")
      now = DateTime.utc_now()

      %{produce: produce, now: now}
    end

    test "adds items to the inventory", %{produce: produce, now: now} do
      inventory1 = Inventory.new()
      inventory2 = Inventory.new()

      inventory1 = Inventory.add(inventory1, produce, 5, now)
      refute inventory1 == inventory2
      inventory2 = Inventory.add(inventory2, produce, 5, now)
      assert inventory1 == inventory2
    end

    test "adding the same item to the inventory at different times keeps the original timestamp",
         %{produce: produce, now: now} do
      now_plus_5_seconds = DateTime.add(now, 5, :second)
      inventory = Inventory.new()

      inventory = Inventory.add(inventory, produce, 5, now)
      inventory = Inventory.add(inventory, produce, 5, now_plus_5_seconds)

      assert Inventory.get(inventory, produce) == %{
               produce: produce,
               quantity: 10,
               date_added: now
             }
    end
  end

  describe "get/2" do
    setup do
      {:ok, produce} = Produce.new("strawberry")
      now = DateTime.utc_now()

      inventory =
        Inventory.new()
        |> Inventory.add(produce, 5, now)

      %{produce: produce, inventory: inventory}
    end

    test "returns an entry for the produce with the current quantity", %{
      produce: produce,
      inventory: inventory
    } do
      assert %{produce: ^produce, quantity: 5, date_added: _} = Inventory.get(inventory, produce)
    end

    test "returns nil if the produce is not found in the inventory", %{produce: produce} do
      inventory = Inventory.new()

      assert nil == Inventory.get(inventory, produce)
    end
  end

  describe "list/1" do
    setup do
      {:ok, produce_1} = Produce.new("strawberry")
      {:ok, produce_2} = Produce.new("kiwi")
      now = DateTime.utc_now()

      inventory =
        Inventory.new()
        |> Inventory.add(produce_1, 5, now)
        |> Inventory.add(produce_2, 5, now)

      %{inventory: inventory}
    end

    test "returns a list of all the produce in the inventory", %{
      inventory: inventory
    } do
      produce_names =
        Inventory.list(inventory)
        |> Enum.map(&Map.get(&1, :produce))
        |> Enum.map(&Produce.name/1)

      assert length(produce_names) == 2
      assert "strawberry" in produce_names
      assert "kiwi" in produce_names
    end
  end
end
