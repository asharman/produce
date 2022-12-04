defmodule DomainTypes.InventoryTest do
  use ExUnit.Case, async: true
  alias DomainTypes.Inventory
  alias DomainTypes.Produce

  describe "new/0" do
    test "returns a new Inventory" do
      assert inventory1 = Inventory.new()
      assert inventory2 = Inventory.new()

      assert inventory1 == inventory2
    end
  end

  describe "add/4" do
    setup do
      {:ok, produce} = Produce.new("strawberry")
      now = DateTime.utc_now()

      %{item: produce, now: now}
    end

    test "adds items to the inventory", %{item: item, now: now} do
      inventory1 = Inventory.new()
      inventory2 = Inventory.new()

      inventory1 = Inventory.add(inventory1, item, 5, now)
      refute inventory1 == inventory2
      inventory2 = Inventory.add(inventory2, item, 5, now)
      assert inventory1 == inventory2
    end

    test "adding the same item to the inventory at different times keeps the original timestamp",
         %{item: item, now: now} do
      now_plus_5_seconds = DateTime.add(now, 5, :second)
      inventory = Inventory.new()

      inventory = Inventory.add(inventory, item, 5, now)
      inventory = Inventory.add(inventory, item, 5, now_plus_5_seconds)

      assert Inventory.get(inventory, item) == [{item, 5, now_plus_5_seconds}, {item, 5, now}]
    end
  end
end
