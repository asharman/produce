defmodule Produce do
  alias Produce.ProduceStore

  @moduledoc """
  Produce keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @spec add_produce(DomainTypes.Produce.t(), pos_integer) :: :ok
  defdelegate add_produce(produce, quantity), to: ProduceStore
end
