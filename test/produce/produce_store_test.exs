defmodule Produce.ProduceStoreTest do
  use ExUnit.Case, async: true
  alias Produce.ProduceStore
  alias DomainTypes.Produce

  @store __MODULE__

  setup do
    {:ok, _store} = ProduceStore.start_link(name: @store)
    :ok
  end

  describe "add_produce/2" do
    setup config do
      {:ok, produce} = Produce.new("strawberry")

      config
      |> Map.put(:produce, produce)
    end

    test "adds produce to the store and records the time", %{produce: produce} do
      now = DateTime.utc_now()

      assert :ok = ProduceStore.add_produce(produce, 5, @store)

      %{produce: ^produce, quantity: 5, date_added: date_added} =
        ProduceStore.fetch_produce(produce, @store)

      assert abs(DateTime.diff(date_added, now, :second)) < 1
    end
  end

  describe "fetch_produce/1" do
    setup config do
      {:ok, produce} = Produce.new("strawberry")
      quantity = 5
      now = DateTime.utc_now()
      ProduceStore.add_produce(produce, quantity, @store)

      config
      |> Map.put(:produce, produce)
      |> Map.put(:quantity, quantity)
      |> Map.put(:date_added, now)
    end

    test "returns an entry for the produce",
         %{produce: produce, quantity: quantity, date_added: date_added} do
      assert %{produce: ^produce, quantity: ^quantity, date_added: recorded_date} =
               ProduceStore.fetch_produce(produce, @store)

      assert abs(DateTime.diff(date_added, recorded_date, :second)) < 1
    end
  end

  describe "list_produce/0" do
    setup config do
      {:ok, produce1} = Produce.new("strawberry")
      {:ok, produce2} = Produce.new("kiwi")
      ProduceStore.add_produce(produce1, 5, @store)
      ProduceStore.add_produce(produce2, 5, @store)

      config
    end

    test "returns a list of all the produce in the inventory" do
      produce_names =
        ProduceStore.list_produce(@store)
        |> Enum.map(&Map.get(&1, :produce))
        |> Enum.map(&Produce.name/1)

      assert length(produce_names) == 2
      assert "strawberry" in produce_names
      assert "kiwi" in produce_names
    end
  end
end
