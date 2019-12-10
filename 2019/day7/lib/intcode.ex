defmodule Intcode do
  @moduledoc """
  Intcode computer
  Day 9 edition
  """

  def stack_ptr(state), do: elem(state, 1)

  def stack_ptr(state, delta) do
    put_elem(state, 1, elem(state, 1) + delta)
  end

  def stack_ptr(state, :jump, offset), do: put_elem(state, 1, offset)

  def memory(state, pos, val), do: put_elem(state, 0, put_elem(memory(state), pos, val))
  def memory(state), do: elem(state, 0)

  def parse(str) do
    str |> String.trim() |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1)
  end

  def read_arg(0, false, ref, mem, _base), do: elem(mem, ref)
  def read_arg(0, true, ref, _mem, _base), do: ref
  def read_arg(1, _write, ref, _mem, _base), do: ref
  def read_arg(2, true, ref, _mem, relative_base), do: ref + relative_base
  def read_arg(2, false, ref, mem, relative_base), do: elem(mem, ref + relative_base)

  def read_args(args, state, write) do
    {mem, ptr, relative_base, _io_in, _io_out} = state
    modes = op_modes(state)

    Enum.map(args, fn arg_pos ->
      ref = elem(mem, ptr + arg_pos)
      mode = Enum.at(modes, arg_pos - 1, 0)
      read_arg(mode, write == arg_pos, ref, mem, relative_base)
    end)
    |> List.to_tuple()
  end

  def op_modes(state) do
    {mem, _stack_ptr, _rb, _io_in, _io_out} = state

    elem(mem, stack_ptr(state))
    |> Integer.digits()
    |> Enum.reverse()
    |> Enum.drop(2)
  end

  def params(count, state), do: params(count, state, -1)

  def params(count, state, write) do
    Range.new(1, count)
    |> read_args(state, write)
  end

  def add(state) do
    {lval, rval, sptr} = params(3, state, 3)

    state
    |> memory(sptr, lval + rval)
    |> stack_ptr(4)
  end

  def mul(state) do
    {lval, rval, sptr} = params(3, state, 3)

    state
    |> memory(sptr, lval * rval)
    |> stack_ptr(4)
  end

  def cin(state) do
    {mem, stack_ptr, relative_base, io_in, io_out} = state

    if io_in == [] do
      {:halt, state}
    else
      [read | tail] = io_in
      {pos} = params(1, state, 1)
      mem = put_elem(mem, pos, read)
      {:cont, {mem, stack_ptr + 2, relative_base, tail, io_out}}
    end
  end

  def cout(state) do
    {mem, stack_ptr, rb, io_in, io_out} = state
    {val} = params(1, state)
    {mem, stack_ptr + 2, rb, io_in, io_out ++ [val]}
  end

  def jumptrue(state) do
    {test, far} = params(2, state)

    if test != 0 do
      state |> stack_ptr(:jump, far)
    else
      state |> stack_ptr(3)
    end
  end

  def jumpfalse(state) do
    {test, far} = params(2, state)

    if test == 0 do
      state |> stack_ptr(:jump, far)
    else
      state |> stack_ptr(3)
    end
  end

  def cmpl(state) do
    {lval, rval, sptr} = params(3, state, 3)
    sval = if lval < rval, do: 1, else: 0

    state
    |> memory(sptr, sval)
    |> stack_ptr(4)
  end

  def cmpeql(state) do
    {lval, rval, sptr} = params(3, state, 3)
    sval = if lval == rval, do: 1, else: 0

    state
    |> memory(sptr, sval)
    |> stack_ptr(4)
  end

  def relative_mode(state) do
    {mem, stack_ptr, relative_base, io_in, io_out} = state
    {delta} = params(1, state)
    {mem, stack_ptr + 2, relative_base + delta, io_in, io_out}
  end

  def opcode(state) do
    {mem, stack_ptr, _rb, _io_in, _io_out} = state
    rem(elem(mem, stack_ptr), 100)
  end

  def instruction(1, state), do: {:cont, add(state)}
  def instruction(2, state), do: {:cont, mul(state)}
  def instruction(3, state), do: cin(state)
  def instruction(4, state), do: {:cont, cout(state)}
  def instruction(5, state), do: {:cont, jumptrue(state)}
  def instruction(6, state), do: {:cont, jumpfalse(state)}
  def instruction(7, state), do: {:cont, cmpl(state)}
  def instruction(8, state), do: {:cont, cmpeql(state)}
  def instruction(9, state), do: {:cont, relative_mode(state)}
  def instruction(99, state), do: {:halt, state}

  def tick(_step, state) do
    instruction(opcode(state), state)
  end

  def run(state, io_in) do
    {mem, pos, rb, _io_in, _io_out} = state
    state = {mem, pos, rb, io_in, []}

    Stream.cycle(0..0)
    |> Enum.reduce_while(state, fn step, acc -> tick(step, acc) end)
  end

  def prog(code), do: prog(code, [])

  def prog(code, io_in) do
    mem =
      (parse(code) ++ Enum.map(1..2_000, fn _ -> 0 end))
      |> List.to_tuple()

    state = {mem, 0, 0, [], []}
    run(state, io_in)
  end

  def state_mem(state) do
    {mem, _stack_ptr, _rb, _io_in, _io_out} = state
    mem |> Tuple.to_list() |> Enum.join(",")
  end

  def state_io_out(state) do
    {_mem, _stack_ptr, _rb, _io_in, io_out} = state
    io_out
  end

  def state_stack_ptr(state) do
    {_mem, stack_ptr, _rb, _io_in, _io_out} = state
    stack_ptr
  end
end
