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
      |> Stream.map(fn {col, x} -> space_object(col, x, y) end)
      |> Stream.filter(fn map -> map end)
    end)
    |> Enum.into(%{})
  end

  def space_object("#", x, y), do: {{y, x}, %{}}
  def space_object(_icon, _x, _y), do: nil

  def process(asteroids) do
    asteroids
    |> Map.new(fn {base, _} ->
      {base,
       Enum.map(Map.delete(asteroids, base), fn {other, _} ->
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
         prev = acc[atan2]

         cond do
           !prev -> Map.put(acc, atan2, [{y, x, dist}])
           dist < elem(hd(prev), 2) -> Map.put(acc, atan2, [{y, x, dist} | prev])
           true -> Map.put(acc, atan2, prev ++ [{y, x, dist}])
         end
       end)}
    end)
  end

  def find_nth({targets, nth}), do: find_nth(targets, nth)

  def find_nth(targets, nth) do
    result =
      Enum.reduce_while(targets, {%{}, nth}, fn {atan, lst}, acc ->
        {map, nth} = acc
        nth = nth - 1
        lst = lst |> Enum.sort_by(fn {_y, _x, dist} -> dist end)

        if nth == 0 do
          {:halt, hd(lst)}
        else
          lst = tl(lst)
          map = if lst == [], do: Map.delete(map, atan), else: Map.put(map, atan, lst)
          {:cont, {map, nth}}
        end
      end)

    if tuple_size(result) == 2 && map_size(elem(result, 0)) > 0,
      do: find_nth(result),
      else: result
  end

  def part2("prod"), do: part2("prod", 200)
  def part2("sample1"), do: part2("sample1", 5)

  def part2(file, nth) do
    targets =
      input(file)
      |> visible()
      |> maximize
      |> elem(1)
      |> Enum.sort_by(fn {atan2, _lst} -> atan2 end)

    {y, x, _dist} = find_nth(targets, nth)

    100 * x + y
  end
end
