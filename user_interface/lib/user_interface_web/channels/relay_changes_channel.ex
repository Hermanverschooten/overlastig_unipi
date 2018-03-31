defmodule UserInterfaceWeb.RelayChangesChannel do
  use UserInterfaceWeb, :channel
  alias Unipi.Relay

  def join("relay_changes:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (relay_changes:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  def handle_in("toggle", %{"button" => "M"}, socket) do
    MusicServer.toggle()

    {:noreply, socket}
  end

  def handle_in("toggle", %{"button" => button}, socket) do
    {relay, _rest} = Integer.parse(button)
    Relay.toggle(relay)
    broadcast! socket, "change", %{ relay: relay, state: Relay.state(relay) }
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
