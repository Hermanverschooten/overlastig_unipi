defmodule I2cTest do
  use ExUnit.Case

  setup do
    {:ok, pid} = I2c.start_link("i2c-1", 0x20)
    {:ok, i2c: pid}
  end

  test "reading all registers", %{i2c: i2c} do
    assert <<0,0,0,0,0,0,0,0,0,0,0>> == I2c.read(i2c, 11)
  end

  test "reading a single register", %{i2c: i2c} do
    assert <<0>> == I2c.write_read(i2c, << 0 >> ,1)
  end

  test "writing a register", %{i2c: i2c} do
    assert :ok == I2c.write(i2c, << 0x09, 0x10>>)
    assert << 0x10 >> == I2c.write_read(i2c, << 0x09 >>, 1)
  end
end
