defmodule ProduceWeb.Forms.AddProduceTest do
  use ExUnit.Case, async: true
  alias ProduceWeb.Forms.AddProduce
  alias ProduceWeb.Form

  @valid_attrs %{"name" => "Strawberry", "quantity" => "5"}
  @invalid_attrs %{"name" => "", "quantity" => "-5"}

  test "new_form/0 returns a form" do
    form = AddProduce.new_form()
    assert form == AddProduce.new_form()
  end

  describe "validate/1" do
    test "valid parameters returns a valid_form and the data" do
      {:ok, expected_produce} = DomainTypes.Produce.new("Strawberry")

      expected_params = %{
        produce: expected_produce,
        quantity: 5
      }

      assert {_form, validated_params} = AddProduce.validate(@valid_attrs)

      assert validated_params == expected_params
    end

    test "invalid parameters returns an error with invalid keys" do
      assert {invalid_form, nil} = AddProduce.validate(@invalid_attrs)
      assert [quantity: _, name: _] = Form.errors(invalid_form)
    end
  end
end
