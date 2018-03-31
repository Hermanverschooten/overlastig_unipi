defmodule UserInterfaceWeb.PageController do
  use UserInterfaceWeb, :controller
  alias Unipi.Relay

  def index(conn, _params) do
    render conn, "index.html", relays: get_relay_statuses()
  end

  defp get_relay_statuses do
    [
      %Button{name: "Strobo achter", relay: 1, status: Relay.state(1)},
      %Button{name: "Strobo voor", relay: 2, status: Relay.state(2)},
      %Button{name: "Rook-machine", relay: 3, status: Relay.state(3)},
      %Button{name: "Disco-ruimte", relay: 4, status: Relay.state(4)},
      %Button{name: "Verlichting", relay: 5, status: Relay.state(5)},
      %Button{name: "Blazer", relay: 6, status: Relay.state(6)},
      %Button{name: "Muziek", relay: "M", status: MusicServer.state},
      # %Button{name: "Relay 7", relay: 7, status: Relay.state(7)},
      # %Button{name: "Relay 8", relay: 8, status: Relay.state(8)}
    ]
  end
end
