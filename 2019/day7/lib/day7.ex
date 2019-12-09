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
      outputs = run(prog, [io_in, 0]) |> Intcode.state_io_out()
      [io_in | tail] = tail
      outputs = run(prog, [io_in | outputs]) |> Intcode.state_io_out()
      [io_in | tail] = tail
      outputs = run(prog, [io_in | outputs]) |> Intcode.state_io_out()
      [io_in | tail] = tail
      outputs = run(prog, [io_in | outputs]) |> Intcode.state_io_out()
      [io_in | _tail] = tail
      run(prog, [io_in | outputs]) |> Intcode.state_io_out()
    end)
    |> Enum.max()
    |> List.first()
  end

  def feedback(acc) do
    {signal, progs} =
      Enum.reduce(0..4, acc, fn i, acc ->
        {initial, progs} = acc
        p = Intcode.run(Enum.at(progs, i), initial)
        signal = p |> Intcode.state_io_out()
        {signal, List.replace_at(progs, i, p)}
      end)

    if signal == [] do
      {:halt, acc}
    else
      {:cont, {signal, progs}}
    end
  end

  def part2, do: part2("prod")

  def part2(file) do
    prog = input(file)

    Enum.map(permutations([5, 6, 7, 8, 9]), fn perm ->
      progs =
        Enum.map(perm, fn n ->
          run(prog, [n])
        end)

      {signal, _} = Enum.reduce_while(1..20, {[0], progs}, fn _, acc -> feedback(acc) end)
      signal
    end)
    |> Enum.max()
    |> List.first()
  end

  def permutations([]), do: [[]]

  def permutations(list),
    do: for(elem <- list, rest <- permutations(list -- [elem]), do: [elem | rest])
end
