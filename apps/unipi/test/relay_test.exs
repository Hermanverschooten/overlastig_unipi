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

  test "Out of range relays do not throw errors" do
    assert :error == Relay.on(-1)
    assert :error == Relay.on(100)

    assert :error == Relay.off(-1)
    assert :error == Relay.off(100)

    assert :error == Relay.state(-1)
    assert :error == Relay.state(100)
  end
end
