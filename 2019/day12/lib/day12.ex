defmodule Day12 do
  @moduledoc """
  Advent of Code -- Day 12:
  """

  def input(file) do
    {:ok, contents} = File.read("dat/" <> file)

    contents |> String.trim() |> parse()
  end

  def parse(file) do
    file
    |> String.split("\n")
    |> Enum.map(fn line ->
      [px, py, pz] =
        Regex.scan(~r{<x=([-0-9]*), y=([-0-9]*), z=([-0-9]*)}, line)
        |> hd
        |> Enum.slice(1, 3)
        |> Enum.map(&String.to_integer/1)

      {px, 0, py, 0, pz, 0}
    end)
  end

  def dv(self, other) do
    cond do
      self > other -> -1
      self < other -> 1
      true -> 0
    end
  end

  def gravity(body, bodies) do
    bodies
    |> Enum.reduce(body, fn {x, _, y, _, z, _}, {px, vx, py, vy, pz, vz} ->
      {px, vx + dv(px, x), py, vy + dv(py, y), pz, vz + dv(pz, z)}
    end)
  end

  def process(bodies) do
    bodies
    |> Enum.map(fn body -> body |> gravity(bodies) end)
    |> Enum.map(fn {px, vx, py, vy, pz, vz} ->
      {px + vx, vx, py + vy, vy, pz + vz, vz}
    end)
  end

  def energy(bodies) do
    bodies
    |> Enum.map(fn {px, vx, py, vy, pz, vz} ->
      (abs(px) + abs(py) + abs(pz)) * (abs(vx) + abs(vy) + abs(vz))
    end)
    |> Enum.sum()
  end

  def part1("sample1"), do: part1("sample1", 10)
  def part1("sample2"), do: part1("sample2", 100)
  def part1, do: part1("prod", 1000)

  def part1(file, max) do
    start = input(file)

    Stream.cycle(1..max)
    |> Enum.reduce_while(start, fn step, bodies ->
      bodies = process(bodies)

      if step == max do
        {:halt, bodies}
      else
        {:cont, bodies}
      end
    end)
    |> energy()
  end

  def check(res, bodies, step) do
    bodies
    |> Enum.reduce([[], [], []], fn {_, vx, _, vy, _, vz}, [x, y, z] ->
      [[vx == 0 | x], [vy == 0 | y], [vz == 0 | z]]
    end)
    |> Enum.with_index()
    |> Enum.map(fn {steps, i} ->
      Enum.at(res, i) || (Enum.all?(steps) && step)
    end)
  end

  def part2, do: part2("prod")

  def part2(file) do
    start = input(file)

    {_step, _bodies, [x, y, z]} =
      Stream.cycle(0..0)
      |> Enum.reduce_while({0, start, [nil, nil, nil]}, fn _, {step, bodies, res} ->
        bodies = process(bodies)
        step = step + 1
        res = check(res, bodies, step)

        if res |> Enum.all?() do
          {:halt, {step, bodies, res}}
        else
          {:cont, {step, bodies, res}}
        end
      end)

    2 * lcm(lcm(x, y), z)
  end

  def gcd(a, 0), do: a
  def gcd(0, b), do: b
  def gcd(a, b), do: gcd(b, rem(a, b))

  def lcm(0, 0), do: 0
  def lcm(a, b), do: div(a * b, gcd(a, b))
end
