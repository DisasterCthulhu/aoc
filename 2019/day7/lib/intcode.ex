defmodule Intcode do
  @moduledoc """
  Intcode computer
  Day 7 edition
  """

  def parse(str) do
    str |> String.trim() |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1)
  end

  def read_args(args, state) do
    {mem, stack_ptr, _io_in, _io_out} = state
    modes = op_modes(state)

    Enum.map(args, fn arg_pos ->
      ref = Enum.at(mem, stack_ptr + arg_pos)
      if Enum.at(modes, arg_pos - 1, 0) == 0, do: Enum.at(mem, ref), else: ref
    end)
    |> List.to_tuple()
  end

  def op_modes(state) do
    {mem, stack_ptr, _io_in, _io_out} = state

    Enum.at(mem, stack_ptr)
    |> Integer.digits()
    |> Enum.reverse()
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

    if io_in == [] do
      {:halt, state}
    else
      [read | tail] = io_in
      store_ptr = Enum.at(mem, stack_ptr + 1)
      mem = List.replace_at(mem, store_ptr, read)
      {:cont, {mem, stack_ptr + 2, tail, io_out}}
    end
  end

  def cout(state) do
    {mem, stack_ptr, io_in, io_out} = state
    {val} = params(1, state)
    {mem, stack_ptr + 2, io_in, io_out ++ [val]}
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

  def instruction(1, state), do: {:cont, add(state)}
  def instruction(2, state), do: {:cont, mul(state)}
  def instruction(3, state), do: cin(state)
  def instruction(4, state), do: {:cont, cout(state)}
  def instruction(5, state), do: {:cont, jumptrue(state)}
  def instruction(6, state), do: {:cont, jumpfalse(state)}
  def instruction(7, state), do: {:cont, cmpl(state)}
  def instruction(8, state), do: {:cont, cmpeql(state)}
  def instruction(99, state), do: {:halt, state}

  def tick(_step, state) do
    op = opcode(state)
    instruction(op, state)
  end

  def run(state, io_in) do
    {mem, pos, _io_in, _io_out} = state
    state = {mem, pos, io_in, []}

    Stream.cycle(0..0)
    |> Enum.reduce_while(state, fn step, acc -> tick(step, acc) end)
  end

  def prog(code), do: prog(code, [])

  def prog(code, io_in) do
    mem = code |> parse()
    state = {mem, 0, [], []}
    run(state, io_in)
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
