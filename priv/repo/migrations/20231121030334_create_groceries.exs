defmodule Produce.Repo.Migrations.CreateGroceries do
  use Ecto.Migration

  def change do
    create table(:groceries) do
      add :name, :string
      add :quantity, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
