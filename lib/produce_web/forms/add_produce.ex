defmodule ProduceWeb.Forms.AddProduce do
  alias Ecto.Changeset

  @typep produce_params() :: %{String.t() => String.t()}
  @typep validated_produce_params() :: %{
           produce: DomainTypes.Produce.t(),
           quantity: pos_integer()
         }
  @type result(a) :: {:form_error, reason :: String.t()} | {:ok, a}

  @types %{name: :string, quantity: :integer}
  @fields Map.keys(@types)

  @spec changeset :: Changeset.t()
  def changeset(form_data \\ %{}) do
    Changeset.cast({%{}, @types}, form_data, @fields)
  end

  @spec validate(produce_params()) :: result(validated_produce_params())
  def validate(params) do
    case apply_validations(params) do
      {:ok, data} ->
        data = cast_name_to_produce(data)
        {:ok, data}

      {:error, changeset} ->
        # errors = changeset_errors(changeset) |> format_errors()
        {:form_error, changeset}
    end
  end

  defp apply_validations(params) do
    params
    |> changeset()
    |> Changeset.validate_required(@fields)
    |> Changeset.validate_number(:quantity, greater_than: 0)
    |> Changeset.apply_action(:update)
  end

  defp cast_name_to_produce(data) do
    {:ok, produce} = DomainTypes.Produce.new(data.name)

    data
    |> Map.put(:produce, produce)
    |> Map.delete(:name)
  end

  defp changeset_errors(changeset) do
    Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end

  defp format_errors(changeset_errors) do
    changeset_errors
    |> Map.map(fn {field, errors} ->
      Enum.map(errors, &"#{Atom.to_string(field)} #{&1}")
    end)
    |> Map.values()
    |> List.flatten()
    |> Enum.join(", ")
  end
end
