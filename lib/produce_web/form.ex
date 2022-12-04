defmodule ProduceWeb.Form do
  alias Ecto.Changeset

  @opaque t() :: Changeset.t()
  @type form_types :: %{atom() => atom()}
  @type form_data :: %{optional(atom | binary) => term()}
  @type error() :: String.t()

  @spec new(form_types(), form_data()) :: t()
  def new(types, form_data \\ %{}) do
    fields = Map.keys(types)
    Changeset.cast({%{}, types}, form_data, fields)
  end

  # VALIDATIONS ============================
  @opaque validation() :: (t() -> {t(), nil | any()})

  @spec validate(t(), validation()) :: {t(), nil | any()}
  def validate(form, validator) do
    {validated_form, data} = validator.(form)

    if valid?(validated_form) do
      # If its valid we should have all the data
      {validated_form, data}
    else
      # Just throw away the partial data
      {:error, invalid_form} = Changeset.apply_action(validated_form, :validate)
      {invalid_form, nil}
    end
  end

  @spec required(atom(), error()) :: validation()
  def required(field, error) do
    fn form ->
      checked_form = validate_required(form, field, message: error)

      if valid?(checked_form) do
        {checked_form, value(checked_form, field)}
      else
        {checked_form, nil}
      end
    end
  end

  @spec greaterThan(integer(), atom(), error()) :: validation()
  def greaterThan(x, field, error) do
    fn form ->
      checked_form = validate_number(form, field, greater_than: x, message: error)

      if valid?(checked_form) do
        {checked_form, value(checked_form, field)}
      else
        {checked_form, nil}
      end
    end
  end

  @spec all(list(validation())) :: validation()
  def all(validations) do
    fn form ->
      # assuming we're working validating the same field at the moment
      {checked_form, data} = Enum.reduce(validations, {form, nil}, & &1.(elem(&2, 0)))

      if valid?(checked_form) do
        {checked_form, data}
      else
        {checked_form, nil}
      end
    end
  end

  @spec pipeline(function(), list(validation())) :: validation()
  def pipeline(fun, validations) do
    fn form ->
      {checked_form, args} =
        Enum.reduce(validations, {form, []}, fn val, {f, a} ->
          {new_f, data} = val.(f)
          {new_f, a ++ [data]}
        end)

      if valid?(checked_form) do
        {checked_form, apply(fun, args)}
      else
        {checked_form, nil}
      end
    end
  end

  # Changeset specific stuff to keep type opaque ===============
  defp valid?(form), do: form.valid?
  defp value(form, field), do: Map.get(form.changes, field)
  def errors(form), do: form.errors

  @spec validate_required(t(), atom(), Keyword.t()) :: t()
  defdelegate validate_required(form, field, opts), to: Changeset

  @spec validate_number(t(), atom(), Keyword.t()) :: t()
  defp validate_number(form, field, opts), do: Changeset.validate_number(form, field, opts)
end
