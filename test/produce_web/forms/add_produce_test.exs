defmodule ProduceWeb.Forms.AddProduceTest do
  use ExUnit.Case, async: true
  alias ProduceWeb.Forms.AddProduce

  @valid_attrs %{"name" => "Strawberry", "quantity" => "5"}
  @invalid_attrs %{"name" => "", "quantity" => "-5"}

  test "changeset/0 returns an empty changeset" do
    changeset = AddProduce.changeset()

    assert changeset.changes == %{}
  end

  test "changeset/1 returns a changeset with form data applied" do
    changeset = AddProduce.changeset(@valid_attrs)

    assert changeset.changes == %{name: "Strawberry", quantity: 5}
  end

  describe "validate/1" do
    test "valid parameters returns casted parameters" do
      {:ok, expected_produce} = DomainTypes.Produce.new("Strawberry")

      expected_params = %{
        produce: expected_produce,
        quantity: 5
      }

      assert {:ok, validated_params} = AddProduce.validate(@valid_attrs)

      assert validated_params == expected_params
    end

    test "invalid parameters returns an error with invalid keys" do
      assert {:form_error, invalid_changeset} = AddProduce.validate(@invalid_attrs)
      assert %{errors: [quantity: _, name: _]} = invalid_changeset
    end
  end
end
