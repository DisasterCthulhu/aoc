defmodule Day6 do
  @moduledoc """
  Advent of Code 2019 - Day 6
  """
  def input do
    input("prod")
  end

  def input(file) do
    {:ok, contents} = File.read("dat/" <> file)
    contents
    |> String.trim
    |> String.split("\n", trim: true)
  end

  def map_orbits(list) do
    do_map_orbits(list, %{"COM" => []})
  end
  def do_map_orbits([head | tail], orbits) when is_bitstring(head) do
    [com, satilite] = head |> String.split(")")
    do_map_orbits(tail, Map.put(orbits, com, [satilite | Map.get(orbits, com, [])]))
  end
  def do_map_orbits([], orbits) do
    orbits
  end

  def inverse_orbits(orbits) do
    orbits
    |> Map.to_list
    |> Enum.reduce(%{}, fn {com, sats}, acc ->
      Enum.reduce(sats, acc, fn sat, acc ->
        Map.put(acc, sat, com)
      end)
    end)
  end

  def orbit_depths(orbits) do
    Enum.reduce(orbits, %{}, fn {sat, _}, acc ->
      Map.put(acc, sat, orbit_depth(sat, orbits, acc))
    end)
  end

  def orbit_depth(sat, orbits, acc) do
    com = Map.get(orbits, sat)
    do_orbit_depth(com, orbits, acc, 1)
  end

  def do_orbit_depth(sat, _orbits, _acc, depth) when sat == "COM" do
    depth
  end
  def do_orbit_depth(sat, orbits, acc, depth) do
    com = Map.get(orbits, sat)
    com_depth = Map.get(acc, com)
    if com_depth do
      depth + com_depth + 1
    else
      do_orbit_depth(com, orbits, acc, depth + 1)
    end
  end

  def ancestors(sat, inv) do
    ancestors(sat, [], inv)
  end

  def ancestors(sat, acc, _inv) when sat == "COM" do
    acc
  end
  def ancestors(sat, acc, inv) do
    com = Map.get(inv, sat)
    ancestors(com, [com | acc], inv)
  end

  def distance(you, san) do
    shared = MapSet.intersection(you |>MapSet.new, san|>MapSet.new)
    you_dist = MapSet.difference(MapSet.new(you), shared)|>Enum.count
    san_dist = MapSet.difference(MapSet.new(san), shared)|>Enum.count
    you_dist + san_dist
  end

  def part1 do
    input()
    |> map_orbits
    |> inverse_orbits
    |> orbit_depths
    |> Map.values
    |> Enum.sum
  end

  def part2 do
    inv = input()
    |> map_orbits
    |> inverse_orbits
    you = ancestors("YOU", inv)
    san = ancestors("SAN", inv)
    distance(you, san)
  end
end
