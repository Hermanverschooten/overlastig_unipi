defmodule UserInterface.RelayChangesChannel do
  use UserInterface.Web, :channel
  alias Unipi.Relay

  def join("relay_changes:lobby", _payload, socket) do
    {:ok, socket}
  end

  def join(_, _payload, socket) do
    {:ok, socket}
  end

  def handle_in("toggle", %{"button" => button}, socket) do
    {relay, _rest} = Integer.parse(button)
    Relay.toggle(relay)
    broadcast! socket, "change", %{ relay: relay, state: Relay.state(relay) }
    {:noreply, socket}
  end

  def handle_in(_cmd, _payload, socket) do
    {:noreply, socket}
  end

end
