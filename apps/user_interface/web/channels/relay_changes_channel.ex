defmodule UserInterface.RelayChangesChannel do
  use UserInterface.Web, :channel

  def join("relay_changes:lobby", payload, socket) do
    {:ok, socket}
  end

  def join(_, _payload, socket) do
    {:ok, socket}
  end

end
