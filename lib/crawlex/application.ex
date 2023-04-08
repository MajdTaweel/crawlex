defmodule Crawlex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      CrawlexWeb.Telemetry,
      # Start the Ecto repository
      Crawlex.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Crawlex.PubSub},
      # Start Finch
      {Finch, name: Crawlex.Finch},
      # Start the Endpoint (http/https)
      CrawlexWeb.Endpoint
      # Start a worker by calling: Crawlex.Worker.start_link(arg)
      # {Crawlex.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Crawlex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CrawlexWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
