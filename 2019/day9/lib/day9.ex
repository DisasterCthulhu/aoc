defmodule Day9 do
  @moduledoc """
  Advent of Code 2019 -- Day 9
  """

  def input, do: input("prod")

  def input(file) do
    {:ok, contents} = File.read("dat/" <> file)
    contents |> String.trim()
  end

  def part1, do: part1("prod")

  def part1(file) do
    input(file)
    |> Intcode.prog([1])
  end

  def part2, do: part2("prod")

  def part2(file) do
    input(file)
    |> Intcode.prog([2])
  end
end
