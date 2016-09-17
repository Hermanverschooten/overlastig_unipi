defmodule RelayTest do
  use ExUnit.Case
  alias Unipi.Relay

  setup do
    {:ok, pid} = Relay.start_link()
    {:ok, pid: pid}
  end

  test "Get the state of a relay" do
    assert :off == Relay.state(1)
  end

  test "Turn relay 1 on" do
    assert :ok == Relay.on(1)
    assert :on == Relay.state(1)
  end

  test "Toggle relay 1" do
    assert :ok == Relay.off(1)
    assert :off == Relay.state(1)
    assert :ok == Relay.toggle(1)
    assert :on == Relay.state(1)
  end
end
