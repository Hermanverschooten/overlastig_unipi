defmodule Unipi.Pins do
  require Logger
  use GenServer

  @doc """
  Register to be notified of events on the 12 GPIO pins of the UniPi.

  Unipi.Pins.start_link [1,2,10], :falling

  Will notify us of the :falling event for pins 1,2 and 10.
  You can also register for :rising, or :both

  The message you receive will be:
  {:pin_state, pin, direction}

  e.g. {:pin_state, 1, :falling}
  """

  @gpios [4, 17, 27, 23, 22, 24, 11, 7, 8 , 9, 25, 10]

  def start_link(pins, direction) do
    GenServer.start_link(__MODULE__, %{pins: pins, callback: self, direction: direction},  name: __MODULE__)
  end

  def init(%{pins: pins, callback: _callback, direction: direction} = opts) do
    for pin <- pins do
      {:ok, pid } = Gpio.start_link(get_gpio(pin), :input)
      Gpio.set_int(pid, direction)
    end
    {:ok, opts}
  end

  defp get_gpio(pin) when pin < 1 or pin > 12, do: raise "#{pin} is out of range 1-12"
  defp get_gpio(pin), do: Enum.at(@gpios, pin - 1)

  def handle_info({:gpio_interrupt, gpio, direction}, state) do
    Logger.info "Received Message '#{direction}' from #{gpio}"
    case state.direction do
      :both -> send_msg(state.callback, gpio, direction)
      ^direction -> send_msg(state.callback, gpio, direction)
      _ -> nil
    end
    {:noreply, state}
  end

  defp send_msg(to, gpio, direction) do
    Kernel.send to, {:pin_state, get_pin(gpio), direction }
  end

  defp get_pin(gpio) do
    case Enum.find_index(@gpios, fn(x) -> x == gpio end) do
      nil -> 0
      pos -> pos + 1
    end
  end
end
