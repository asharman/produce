defmodule Produce.ProduceStore do
  use Agent, restart: :transient
  alias DomainTypes.Inventory
  alias DomainTypes.Produce

  @name __MODULE__

  @spec start_link(GenServer.options()) :: Agent.on_start()
  def start_link(opts \\ []) do
    name = Keyword.get(opts, :name, @name)
    Agent.start_link(fn -> Inventory.new() end, name: name)
  end

  @spec fetch_produce(Produce.t(), Agent.name()) :: list(Inventory.entry_with_produce())
  def fetch_produce(produce, name \\ @name) do
    Agent.get(name, Inventory, :get, [produce])
  end

  @spec add_produce(Produce.t(), pos_integer(), Agent.name()) :: :ok
  def add_produce(produce, quantity, name \\ @name) do
    Agent.update(name, Inventory, :add, [produce, quantity, DateTime.utc_now()])
  end

  @spec list_produce(Agent.name()) :: list(Inventory.entry_with_produce())
  def list_produce(name \\ @name) do
    Agent.get(name, Inventory, :list, [])
  end
end
