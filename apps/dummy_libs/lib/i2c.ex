defmodule I2c do
  use GenServer

  defstruct register: << 0,0,0,0,0,0,0,0,0,0,0 >>, name: "", address: 0

  def start_link(name, address) do
    GenServer.start_link(__MODULE__, {name, address})
  end

  def write(pid, << register , value >>) do
    GenServer.call(pid, {:write, register - 1 , value})
  end

  def write_read(pid, << register >>, length) do
    GenServer.call(pid, {:write_read, register - 1, length})
  end

  def read(pid, length) do
    GenServer.call(pid, {:write_read, 0, length})
  end

  def init({name, address}) do
    state = %I2c{name: name, address: address}
    {:ok, state}
  end

  defp update_register(register, 0, value) do
    << value >> <> String.slice(register, 0, 11)
  end

  defp update_register(register, pos, value) do
    String.slice(register, 0, pos ) <> << value >> <> String.slice(register, pos, 11)
  end

  def handle_call({:write, register, value}, _from, state) do
    new_state = Map.update!(state, :register, &(update_register(&1, register, value)))
    {:reply, :ok, new_state}
  end

  def handle_call({:write_read, register, length}, _from, state) do
    {:reply, String.slice(state.register, register, length), state}
  end


  def handle_call(_) do
    # unregistered handler
  end
end
