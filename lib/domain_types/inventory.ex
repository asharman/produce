defmodule DomainTypes.Inventory do
  alias DomainTypes.Produce

  @type entry :: %{
          produce: Produce.t(),
          quantity: pos_integer(),
          date_added: DateTime.t()
        }
  # @type entry_with_produce :: {Produce.t(), quantity(), date_first_added()}
  @opaque t :: %{
            Produce.t() => list(entry())
          }

  @spec new :: t()
  def new(), do: %{}

  @spec add(t(), Produce.t(), pos_integer(), DateTime.t()) :: t()
  def add(inventory, produce, quantity, timestamp) do
    new_entry = %{produce: produce, quantity: quantity, date_added: timestamp}

    Map.update(
      inventory,
      produce,
      [new_entry],
      fn entries ->
        [new_entry | entries]
      end
    )
  end

  @spec get(t(), Produce.t()) :: entry()
  def get(inventory, produce) do
    entries = Map.get(inventory, produce, [])

    collapse_entries(entries)
  end

  @spec list(t()) :: list(entry())
  def list(inventory) do
    inventory
    |> Map.map(fn {_produce, entries} -> collapse_entries(entries) end)
    |> Map.values()
  end

  defp collapse_entries(entries) do
    Enum.reduce(entries, nil, fn
      entry, nil ->
        entry

      entry, acc ->
        date_added =
          if DateTime.compare(entry.date_added, acc.date_added) == :lt,
            do: entry.date_added,
            else: acc.date_added

        %{acc | quantity: acc.quantity + entry.quantity, date_added: date_added}
    end)
  end
end
