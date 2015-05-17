defmodule Conway do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Start the endpoint when the application starts
      supervisor(Conway.Endpoint, []),
      # Start the Ecto repository
      worker(Conway.Repo, []),

      worker(Conway.BoardServer, [[height: 50, width: 50]]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Conway.Supervisor]
    pid = Supervisor.start_link(children, opts)
    Conway.BoardServer.activate_cells([ [1,2], [2,2], [3,2] ])
    pid
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Conway.Endpoint.config_change(changed, removed)
    :ok
  end
end
