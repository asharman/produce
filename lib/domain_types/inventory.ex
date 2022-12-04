defmodule DomainTypes.Inventory do
  alias DomainTypes.Produce

  @typep date_first_added :: DateTime.t()
  @typep quantity :: pos_integer()
  @typep entry :: {quantity(), date_first_added()}
  @type entry_with_produce :: {Produce.t(), quantity(), date_first_added()}
  @opaque t :: %{
            Produce.t() => list(entry())
          }

  @spec new :: t()
  def new(), do: %{}

  @spec add(t(), Produce.t(), pos_integer(), DateTime.t()) :: t()
  def add(inventory, produce, quantity, timestamp) do
    Map.update(inventory, produce, [{quantity, timestamp}], fn entries ->
      [{quantity, timestamp} | entries]
    end)
  end

  @spec get(t(), Produce.t()) :: list(entry_with_produce())
  def get(inventory, produce) do
    Map.get(inventory, produce, [])
    |> Enum.map(&wrap_entry_with_produce(&1, produce))
  end

  @spec wrap_entry_with_produce(entry(), Produce.t()) :: entry_with_produce()
  defp wrap_entry_with_produce({quantity, date}, produce), do: {produce, quantity, date}
end
