defmodule MusicServer do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def toggle() do
    GenServer.cast(__MODULE__, :toggle)
  end

  def state() do
    case GenServer.call(__MODULE__, :status) do
      true -> "on"
      false -> "off"
    end
  end

  def init(_) do
    {:ok, %{port: nil}}
  end

  def handle_cast(:toggle, state) do
    state = case state.port do
      nil ->
        port = Port.open(
        {:spawn_executable, "/usr/bin/omxplayer"},
        [:binary, args: ["-o", "local", "--loop", "/music/bus.mp3"]]
        )
        Port.monitor(port)
        UserInterfaceWeb.Endpoint.broadcast!("relay_changes:lobby", "change", %{relay: "M", state: "on"})
        %{port: port}
      _port ->
        System.cmd "killall", ["-9", "omxplayer"]
        state
    end
    {:noreply, state}
  end

  def handle_info({:DOWN, _ref, :port, p, _reason}, state) do
    state = case p == state.port do
      true ->
        UserInterfaceWeb.Endpoint.broadcast!("relay_changes:lobby", "change", %{relay: "M", state: "off"})
        %{port: nil}
      false -> state
    end
    {:noreply, state}
  end

  def handle_call(:status, _from, state) do
    {:reply, currently_playing?(), state}
  end

  defp currently_playing? do
    { ps, _ } = System.cmd("ps", [])
    String.match?(ps, ~r/omxplayer/)
  end

end
