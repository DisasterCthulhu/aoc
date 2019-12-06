defmodule Day6Test do
  use ExUnit.Case
  doctest Day6

  test "Day6.part1" do
    assert Day6.part1() == 294_191
  end

  test "Day6.part2" do
    assert Day6.part2() == 424
  end

  test "Day6.sample indirect depths" do
    depths = Day6.input("sample")
    |> Day6.map_orbits
    |> Day6.inverse_orbits
    |> Day6.orbit_depths
    assert depths["D"] == 3
    assert depths["L"] == 7
    assert depths["COM"] == nil
  end

  test "Day6.sample == 42" do
    assert Day6.input("sample")
    |> Day6.map_orbits
    |> Day6.inverse_orbits
    |> Day6.orbit_depths
    |> Map.values
    |> Enum.sum == 42
  end

  test "Day6 sample2" do
    inv = Day6.input("sample2")
    |> Day6.map_orbits
    |> Day6.inverse_orbits
    you = Day6.ancestors("YOU", inv)
    san = Day6.ancestors("SAN", inv)
    assert (Day6.distance(you, san)) == 4
  end
end
