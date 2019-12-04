defmodule Day3 do
  @moduledoc """
  Advent of Code 2019 - Day 3
  Crossed Wires
  """

  def part1 do
    input()
    |> wires
    |> key_set
    |> Enum.reduce(&MapSet.intersection/2)
    |> min_dist
  end

  def part2 do
    ins = input()
      |> wires
      |> map_intersections
    ins |> Enum.min
  end

  def key_set(wires) do
    Enum.map(wires, fn wire ->
      wire |> Map.keys |> MapSet.new
    end)
  end

  def input do
    {:ok, contents} = File.read("dat/prod")
    contents
  end

  def point(val) do
     if val == 0 do
       [0, 0]
     else
       val
     end
  end

  def mdist(lhs, rhs) do
     lhs = point(lhs)
     rhs = point(rhs)
     uddiff = abs(List.first(lhs) - List.first(rhs))
     lrdiff = abs(List.last(lhs) - List.last(rhs))
     uddiff + lrdiff
  end

  def dir_tuple(str) do
    {
      binary_part(str, 0, 1),
      elem(Integer.parse(binary_part(str, 1, String.length(str) - 1)), 0)
    }
  end

  def step(direction, {x, y}) do
    case direction do
      "U" -> {x, y + 1}
      "D" -> {x, y - 1}
      "L" -> {x - 1, y}
      "R" -> {x + 1, y}
    end
   end

  def walk(directions) do
    elem(Enum.reduce(directions, {%{}, {0, 0}, 0}, fn move, acc ->
      {visited, pos, moves} = acc
      {direction, mag} = move
      Enum.reduce(mag..1, {visited, pos, moves}, fn _, acc ->
        {map, pos, moves} = acc
        pos = step(direction, pos)
        {Map.merge(map, %{pos => moves + 1}), pos, moves + 1}
      end)
    end), 0)
  end

  def intersections(list) do
    MapSet.intersection(List.first(list), List.last(list))
  end

  def map_intersections(wires) do
    lhs = List.first(wires)
    rhs = List.last(wires)
    keys = Enum.map(wires, fn wire ->
      wire  |> Map.keys |> MapSet.new
    end)
    ins = MapSet.intersection(List.first(keys), List.last(keys))
    Enum.map(ins, fn ins ->
      Map.get(lhs, ins) + Map.get(rhs, ins)
    end)
  end

  # String of [UDLR][0-9]+ -> [MapSet([points])]
  def wires(str) do
    lines = str
    |> String.trim
    |> String.split("\n")
    directions = Enum.map(lines, fn line ->
      line
      |> String.split(",")
      |> Enum.map(&dir_tuple/1)
    end)
    Enum.map(directions, &walk/1)
  end

  def min_dist(intersections) do
    Enum.reduce(intersections, 9999, fn ins, acc ->
      {x, y} = ins
      test = mdist(0, [x, y])
      acc = if test < acc do
        test
      else
        acc
      end
    end)
  end
end
