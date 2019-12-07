defmodule Day7 do
  @moduledoc """
  Advent of Code 2019 -- Day 7: Amplification Circuit
  """
  def input, do: input("prod")
  def input(file) do
    {:ok, contents} = File.read("dat/" <> file)
    contents
  end

  def run(prog, io_in) do
    prog
    |> Intcode.prog(io_in)
  end

  def part1, do: part1("prod")
  def part1(file) do
    prog = input(file)
    Enum.map(permutations([0, 1, 2, 3, 4]), fn perm ->
      [io_in | tail] = perm
      outputs = run(prog, [io_in, 0]) |> Intcode.state_io_out
      [io_in | tail] = tail
      outputs = run(prog, [io_in | outputs]) |> Intcode.state_io_out
      [io_in | tail] = tail
      outputs = run(prog, [io_in | outputs]) |> Intcode.state_io_out
      [io_in | tail] = tail
      outputs = run(prog, [io_in | outputs]) |> Intcode.state_io_out
      [io_in | tail] = tail
      outputs = run(prog, [io_in | outputs]) |> Intcode.state_io_out
    end)
    |> Enum.max
    |> List.first
  end

  def feedback(n, acc) do
    {initial, progs} = acc
    [p | progs] = progs
    p = Intcode.resume(p, initial)
    signal = p |> Intcode.state_io_out
    done = [p]
    [p | progs] = progs
    p = Intcode.resume(p, signal)
    signal = p |> Intcode.state_io_out
    done = done ++ [p]
    [p | progs] = progs
    p = Intcode.resume(p, signal)
    signal = p |> Intcode.state_io_out
    done = done ++ [p]
    [p | progs] = progs
    p = Intcode.resume(p, signal)
    signal = p |> Intcode.state_io_out
    done = done ++ [p]
    [p | progs] = progs
    p = Intcode.resume(p, signal)
    signal = p |> Intcode.state_io_out
    done = done ++ [p]
    if signal == [] do
      {:halt, initial}
    else
      {:cont, {signal, done}}
    end
  end

  def part2, do: part2("prod")
  def part2(file) do
    prog = input(file)
    Enum.map(permutations([5, 6, 7, 8, 9]), fn perm ->
      progs = Enum.map(perm, fn n ->
        run(prog, [n])
      end)
      Enum.reduce_while(1..20, {[0], progs}, fn n, acc ->
        feedback(n, acc)
      end)
    end)
    |> Enum.max
    |> List.first
  end

  def permutations([]), do: [[]]
  def permutations(list), do: for elem <- list, rest <- permutations(list -- [elem]), do: [elem|rest]
end
