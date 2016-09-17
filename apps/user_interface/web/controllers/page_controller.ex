defmodule Button do
  defstruct name: "VRIJ", relay: 0, status: :off
end
defmodule UserInterface.PageController do
  use UserInterface.Web, :controller
  alias Unipi.Relay

  def index(conn, _params) do
    render conn, "index.html", relays: get_relay_statuses
  end

  def toggle(conn, %{ "button" => button}) do
    {relay, _rest} = Integer.parse(button)
    Relay.toggle(relay)
    broadcast_change(relay, Relay.state(relay))
    redirect(conn, to: page_path(conn, :index))
  end

  defp get_relay_statuses do
    [
      %Button{name: "Relay 1", relay: 1, status: Relay.state(1)},
      %Button{name: "Relay 2", relay: 2, status: Relay.state(2)},
      %Button{name: "Relay 3", relay: 3, status: Relay.state(3)},
      %Button{name: "Relay 4", relay: 4, status: Relay.state(4)},
      %Button{name: "Relay 5", relay: 5, status: Relay.state(5)},
      %Button{name: "Relay 6", relay: 6, status: Relay.state(6)},
      %Button{name: "Relay 7", relay: 7, status: Relay.state(7)},
      %Button{name: "Relay 8", relay: 8, status: Relay.state(8)}
    ]
  end

  defp broadcast_change(relay, state) do
    payload = %{
      relay: relay,
      state: state
    }

    UserInterface.Endpoint.broadcast! "relay_changes:lobby","change", payload
  end
end
