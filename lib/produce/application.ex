defmodule Produce.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Produce.Repo,
      # Start the Telemetry supervisor
      ProduceWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Produce.PubSub},
      # Start the Endpoint (http/https)
      ProduceWeb.Endpoint
      # Start a worker by calling: Produce.Worker.start_link(arg)
      # {Produce.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Produce.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ProduceWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
