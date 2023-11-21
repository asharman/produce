defmodule Produce.Repo do
  use Ecto.Repo,
    otp_app: :produce,
    adapter: Ecto.Adapters.Postgres
end
