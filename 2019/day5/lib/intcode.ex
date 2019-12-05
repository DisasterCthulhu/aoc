defmodule Intcode do
  @moduledoc """
  Intcode computer
  Day 5 edition
  """

  def parse(str) do
    str |> String.trim |> String.split(",") |> Enum.map(&String.to_integer/1)
  end

  def read_args(args, state) do
    {mem, stack_ptr, _io_in, _io_out} = state
    modes = op_modes(state)
    Enum.map(args, fn arg_pos ->
      ref = Enum.at(mem, stack_ptr + arg_pos)
      if Enum.at(modes, arg_pos - 1, 0) == 0, do: Enum.at(mem, ref), else: ref
    end)
    |> List.to_tuple
  end

  def op_modes(state) do
    {mem, stack_ptr, _io_in, _io_out} = state
    Enum.at(mem, stack_ptr)
    |> Integer.digits
    |> Enum.reverse
    |> Enum.drop(2)
  end

  def params(count, state) do
    Range.new(1, count)
    |> read_args(state)
  end

  def add(state) do
    {mem, stack_ptr, io_in, io_out} = state
    {lval, rval} = params(2, state)
    store_ptr = Enum.at(mem, stack_ptr + 3)
    mem = List.replace_at(mem, store_ptr, lval + rval)
    {mem, stack_ptr + 4, io_in, io_out}
  end

  def mul(state) do
    {mem, stack_ptr, io_in, io_out} = state
    {lval, rval} = params(2, state)
    store_ptr = Enum.at(mem, stack_ptr + 3)
    mem = List.replace_at(mem, store_ptr, lval * rval)
    {mem, stack_ptr + 4, io_in, io_out}
  end

  def cin(state) do
    {mem, stack_ptr, io_in, io_out} = state
    store_ptr = Enum.at(mem, stack_ptr + 1)
    mem = List.replace_at(mem, store_ptr, io_in)
    {mem, stack_ptr + 2, io_in, io_out}
  end

  def cout(state) do
    {mem, stack_ptr, io_in, _io_out} = state
    {val} = params(1, state)
    {mem, stack_ptr + 2, io_in, val}
  end

  def jumptrue(state) do
    {mem, stack_ptr, io_in, io_out} = state
    {test, far} = params(2, state)
    far = if test != 0, do: far, else: stack_ptr + 3
    {mem, far, io_in, io_out}
  end

  def jumpfalse(state) do
    {mem, stack_ptr, io_in, io_out} = state
    {test, far} = params(2, state)
    far = if test == 0, do: far, else: stack_ptr + 3
    {mem, far, io_in, io_out}
  end

  def cmpl(state) do
    {mem, stack_ptr, io_in, io_out} = state
    {lval, rval} = params(2, state)
    store_ptr = Enum.at(mem, stack_ptr + 3)
    sval = if lval < rval, do: 1, else: 0
    mem = List.replace_at(mem, store_ptr, sval)
    {mem, stack_ptr + 4, io_in, io_out}
  end

  def cmpeql(state) do
    {mem, stack_ptr, io_in, io_out} = state
    {lval, rval} = params(2, state)
    store_ptr = Enum.at(mem, stack_ptr + 3)
    sval = if lval == rval, do: 1, else: 0
    mem = List.replace_at(mem, store_ptr, sval)
    {mem, stack_ptr + 4, io_in, io_out}
  end

  def opcode(state) do
    {mem, stack_ptr, _io_in, _io_out} = state
    rem(Enum.at(mem, stack_ptr), 100)
  end

  def tick(_step, state) do
    op = opcode(state)
    cond do
      op == 1 -> {:cont, add(state)}
      op == 2 -> {:cont, mul(state)}
      op == 3 -> {:cont, cin(state)}
      op == 4 -> {:cont, cout(state)}
      op == 5 -> {:cont, jumptrue(state)}
      op == 6 -> {:cont, jumpfalse(state)}
      op == 7 -> {:cont, cmpl(state)}
      op == 8 -> {:cont, cmpeql(state)}
      op == 99 -> {:halt, state}
    end
  end

  def prog(code), do: prog(code, nil)
  def prog(code, io_in) do
    mem = code |> parse()
    state = {mem, 0, io_in, []}
    Enum.reduce_while(1..1_000, state, fn step, acc -> tick(step, acc) end)
  end

  def state_mem(state) do
    {mem, _stack_ptr, _io_in, _io_out} = state
    mem |> Enum.join(",")
  end

  def state_io_out(state) do
    {_mem, _stack_ptr, _io_in, io_out} = state
    io_out
  end
end
