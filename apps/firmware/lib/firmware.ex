defmodule Firmware do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      worker(Task, [fn -> start_network end], restart: :transient),
      worker(Unipi.Relay, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Firmware.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp start_network do
    Nerves.Networking.setup :eth0, [mode: "dhcp"]
    Nerves.Cell.setup
  end
end
