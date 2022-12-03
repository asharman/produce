defmodule ProduceWeb.Forms.AddProduce do
  alias ProduceWeb.Form
  alias DomainTypes.Produce

  @typep form_data() :: %{String.t() => String.t()}
  @type validated_form_data() :: %{produce: Produce.t(), quantity: integer()}

  defp construct_form_data(produce, quantity) do
    Map.new()
    |> Map.put(:produce, produce)
    |> Map.put(:quantity, quantity)
  end

  @form_types %{name: :string, quantity: :integer}

  @spec new_form :: Form.t()
  def new_form() do
    Form.new(@form_types)
  end

  @spec validate(form_data()) :: {Form.t(), nil | validated_form_data()}
  def validate(params) do
    Form.new(@form_types, params)
    |> Form.validate(validation())
  end

  @spec validation() :: Form.validation()
  defp validation() do
    Form.pipeline(&construct_form_data/2, [
      Form.required(:name, "Name must be provided"),
      Form.all([
        Form.required(:quantity, "Quantity must be provided"),
        Form.greaterThan(0, :quantity, "Quantity must be greater than 0")
      ])
    ])
  end
end
