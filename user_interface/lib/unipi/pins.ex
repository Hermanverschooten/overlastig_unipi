defmodule Unipi.Pins do
  require Logger
  use GenServer
  if Mix.env == :dev do
    alias DummyGpioRpi, as: GpioRpi
  end

  @doc """
  Register to be notified of events on the 12 GPIO pins of the UniPi.

  Unipi.Pins.start_link [1,2,10], :falling, fn(pin, _direction) -> IO.puts pin end

  It will call the function for the :falling event for pins 1,2 and 10.
  You can also register for :rising, or :both

  """

  @gpios [4, 17, 27, 23, 22, 24, 11, 7, 8 , 9, 25, 10]

  def start_link(pins, direction, callback) do
    GenServer.start_link(__MODULE__, %{pins: pins, callback: callback, direction: direction},  name: __MODULE__)
  end

  def init(%{pins: pins, callback: _callback, direction: direction} = opts) do
    for pin <- pins do
      gpio = get_gpio(pin)
      Logger.info "Listening to #{pin} -> GPIO#{gpio}"
      {:ok, _pid } = GpioRpi.start_link(gpio, :input, mode: :up, interrupt: direction)
      # GpioRpi.set_int(pid, direction)
      # GpioRpi.set_mode(pid, :up)
    end
    {:ok, opts}
  end

  defp get_gpio(pin) when pin < 1 or pin > 12, do: raise "#{pin} is out of range 1-12"
  defp get_gpio(pin), do: Enum.at(@gpios, pin - 1)

  def handle_info({:gpio_interrupt, gpio, direction}, state) do
    pin = get_pin(gpio)
    state = case Map.get(state, gpio) do
      true ->
        Logger.info "Received Message '#{direction}' from #{pin}"
        case state.direction do
          :both -> state.callback.(pin, direction)
          ^direction -> state.callback.(pin, direction)
          _ -> nil
        end
        state
      _ ->
        Logger.info "Ignoring received Message from #{pin}"
        Map.put(state, gpio, true)
    end
    {:noreply, state}
  end

  defp get_pin(gpio) do
    case Enum.find_index(@gpios, fn(x) -> x == gpio end) do
      nil -> 0
      pos -> pos + 1
    end
  end
end
