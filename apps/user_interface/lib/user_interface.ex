defmodule UserInterface do
  require Logger
  use Application
  alias Unipi

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      supervisor(UserInterface.Endpoint, []),
      worker(Unipi.Relay, [true]),
      worker(Unipi.Pins, [
        [1,2,3,4,5,6,7,8], :falling, fn(pin, _dir) -> button_push(pin) end
      ])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: UserInterface.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    UserInterface.Endpoint.config_change(changed, removed)
    :ok
  end

  def button_push(pin) do
    Unipi.Relay.toggle(pin)
    UserInterface.Endpoint.broadcast_from! self(), "relay_changes:lobby", "change", %{ relay: pin, state: Unipi.Relay.state(pin) }
  end
end
