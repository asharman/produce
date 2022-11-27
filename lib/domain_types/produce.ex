defmodule DomainTypes.Produce do
  @opaque t() :: String.t()

  @spec new(String.t()) :: {:ok, t()} | {:error, String.t()}
  def new(name) when name === "", do: {:error, "Produce must have a name"}
  def new(name), do: {:ok, name}

  @spec name(t()) :: String.t()
  def name(produce), do: produce
end
