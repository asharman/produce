defmodule DomainTypes.ProduceTest do
  use ExUnit.Case, async: true
  alias DomainTypes.Produce

  describe "new/1" do
    test "returns a new Produce with a given name" do
      assert {:ok, produce1} = Produce.new("strawberry")
      assert {:ok, produce2} = Produce.new("strawberry")

      assert produce1 == produce2
    end

    test "returns an error if an empty string is provided" do
      assert {:error, message} = Produce.new("")

      assert message == "Produce must have a name"
    end
  end

  describe "name/1" do
    test "returns the name of the given Produce" do
      name = "strawberry"
      {:ok, produce} = Produce.new(name)

      assert Produce.name(produce) == name
    end
  end
end
