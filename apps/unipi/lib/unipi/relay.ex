defmodule Unipi.Relay do
  require Logger
  use GenServer
  use Bitwise

  def start_link(restore_states \\ false) do
    {:ok, pid} = GenServer.start_link(__MODULE__, restore_states, name: __MODULE__)
    {:ok, pid}
  end

  def init(restore_states) do
    {:ok, pid} = I2c.start_link("i2c-1", 0x20)
    # Switch pins to output mode
    I2c.write(pid, << 0x00, 0x00 >>)

    cache_pid = case restore_relay_state(restore_states) do
      {:ok, cache_pid, current_state} ->
        I2c.write(pid, << 0x09 >> <> current_state)
        cache_pid
      :no_restore -> :no_restore
    end
    {:ok, %{i2c: pid, cache_pid: cache_pid}}
  end

  def on(port) when port < 0 or port > 8 do
    :error
  end

  def on(port) do
    GenServer.call(__MODULE__, {:on, port})
  end

  def off(port) when port < 0 or port > 8 do
    :error
  end

  def off(port) do
    GenServer.call(__MODULE__, {:off, port})
  end

  def state(port) when port < 0 or port > 8 do
    :error
  end

  def state(port) do
    GenServer.call(__MODULE__, {:state, port})
  end

  def toggle(port) do
    case state(port) do
      :on -> off(port)
      :off -> on(port)
    end
  end

  ## Private
  #
  def handle_call({:on, port}, _from, state) do
    new_value = bor(current_value(state.i2c), relay(port))
    I2c.write(state.i2c, <<0x09, new_value >>)
    store_state(new_value, state.cache_pid)
    {:reply, :ok, state}
  end

  def handle_call({:off, port}, _from, state) do
    new_value = band(current_value(state.i2c), ~~~relay(port))
    I2c.write(state.i2c, <<0x09, new_value >>)
    store_state(new_value, state.cache_pid)
    {:reply, :ok, state}
  end

  def handle_call({:state, port}, _from, state) do
    current_state = case band(current_value(state.i2c), relay(port)) do
      0 -> :off
      _ -> :on
    end
    {:reply, current_state, state}
  end

  defp current_value(i2c) do
    << val >> = I2c.write_read(i2c, <<0x09>>, 1)
    val
  end

  defp relay(port) do
    1 <<< (8 - port)
  end

  def restore_relay_state(false), do: :no_restore

  def restore_relay_state(true) do
    {:ok, pid } = I2c.start_link("i2c-1", 0x50)
    current_state = I2c.write_read(pid, << 0x00 >>, 1)
    {:ok, pid, current_state}
  end

  defp store_state(_state, :no_restore), do: :ok
  defp store_state(state, pid), do: I2c.write(pid, <<0x00, state>>)
end
