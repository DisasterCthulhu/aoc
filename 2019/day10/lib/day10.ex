defmodule Day10 do
  @moduledoc """
  Advent of Code 2019 - Day 10
  """
  alias :math, as: Math

  def input(file) do
    {:ok, contents} = File.read("dat/" <> file)

    contents
    |> String.split("\n", trim: true)
    |> asteroids
    |> process
  end

  def asteroids(lines) do
    lines
    |> Stream.with_index()
    |> Stream.flat_map(fn {row, y} ->
      row
      |> String.codepoints()
      |> Stream.with_index()
      |> MapSet.new(fn {col, x} -> space_object(col, x, y) end)
      |> Stream.filter(fn map -> map end)
    end)
    |> Enum.into(%{})
  end

  def space_object("#", x, y), do: {{y, x}, %{}}
  def space_object(_icon, _x, _y), do: nil

  def process(asteroids) do
    asteroids
    |> MapSet.new(fn {base, _} ->
      {base,
       MapSet.new(Map.delete(asteroids, base), fn {other, _} ->
         asteroid_relation(base, other)
       end)}
    end)
  end

  def asteroid_relation(base, other) do
    {base_y, base_x} = base
    {other_y, other_x} = other

    {other,
     %{
       atan2: -Math.atan2(other_x - base_x, other_y - base_y),
       dist: abs(base_x - other_x) + abs(base_y - other_y)
     }}
  end

  def maximize(enum), do: enum |> Enum.max_by(fn {{_y, _x}, v} -> map_size(v) end)

  def part1(file) do
    best =
      input(file)
      |> visible()
      |> maximize

    {y, x} = elem(best, 0)
    {x, y, elem(best, 1) |> map_size()}
  end

  def visible(asteroids) do
    asteroids
    |> Stream.map(fn {{y, x}, v} ->
      {{y, x},
       v
       |> Enum.reduce(%{}, fn {{y, x}, %{atan2: atan2, dist: dist}}, acc ->
         p = acc[atan2]
         if !p || dist < elem(p, 2), do: Map.put(acc, atan2, {y, x, dist}), else: acc
       end)}
    end)
  end

  def part2("prod"), do: part2("prod", 200)
  def part2("sample1"), do: part2("sample1", 5)

  def part2(file, nth) do
    {_atan2, {y, x, _dist}} =
      input(file)
      |> visible()
      |> maximize
      |> elem(1)
      |> Enum.sort_by(fn {atan, {_y, _x, _dist}} -> atan end)
      |> Enum.at(nth - 1)

    100 * x + y
  end
end
