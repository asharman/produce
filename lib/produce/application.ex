defmodule Produce.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ProduceWeb.Telemetry,
      Produce.Repo,
      {DNSCluster, query: Application.get_env(:produce, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Produce.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Produce.Finch},
      # Start a worker by calling: Produce.Worker.start_link(arg)
      # {Produce.Worker, arg},
      # Start to serve requests, typically the last entry
      ProduceWeb.Endpoint
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
