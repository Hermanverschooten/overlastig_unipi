defmodule Unipi.Relay do
  require Logger
  use GenServer
  use Bitwise

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_opts) do
    {:ok, pid} = I2c.start_link("i2c-1", 0x20)
    # Switch pins to output mode
    I2c.write(pid, << 0x00, 0x00 >>)
    {:ok, pid}
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
  def handle_call({:on, port}, _from, i2c) do
    new_value = bor(current_value(i2c), relay(port))
    I2c.write(i2c, <<0x09, new_value >>)
    {:reply, :ok, i2c}
  end

  def handle_call({:off, port}, _from, i2c) do
    new_value = band(current_value(i2c), ~~~relay(port))
    I2c.write(i2c, <<0x09, new_value >>)
    {:reply, :ok, i2c}
  end

  def handle_call({:state, port}, _from, i2c) do
    state = case band(current_value(i2c), relay(port)) do
      0 -> :off
      _ -> :on
    end
    {:reply, state, i2c}
  end

  defp current_value(i2c) do
    << val >> = I2c.write_read(i2c, <<0x09>>, 1)
    val
  end

  defp relay(port) do
    1 <<< (8 - port)
  end
end
