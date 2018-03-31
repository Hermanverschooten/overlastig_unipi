defmodule UserInterface.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      supervisor(UserInterfaceWeb.Endpoint, []),
      worker(Unipi.Relay, [true]),
      worker(Unipi.Pins, [
        [1,2,3,4,5,6,7,8,9], :falling, fn(pin, _dir) -> button_push(pin) end]
      ),
      worker(MusicServer, [])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: UserInterface.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    UserInterfaceWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  def button_push(9) do
    MusicServer.toggle()
  end

  def button_push(pin) do
    Unipi.Relay.toggle(pin)
    UserInterfaceWeb.Endpoint.broadcast_from!(self(), "relay_changes:lobby", "change", %{relay: pin, state: Unipi.Relay.state(pin)})
  end
end
