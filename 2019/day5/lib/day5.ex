defmodule Day5 do
  @moduledoc """
  Advent of Code 2019 - Day 5
  Sunny with a Chance of Asteroids
  """

  def input do
    {:ok, contents} = File.read("dat/prod")
    contents
  end

  def part1 do
    input()
    |> Intcode.prog([1])
  end

  def part2 do
    input()
    |> Intcode.prog([5])
  end
end
