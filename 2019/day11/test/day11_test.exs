defmodule Day11Test do
  use ExUnit.Case
  doctest Day11

  test "part1" do
    assert Day11.part1() == 1964
  end

  test "part2" do
    # FKEKCFRK
    assert Day11.part2() ==
             ".####.#..#.####.#..#..##..####.###..#..#...........\n.#....#.#..#....#.#..#..#.#....#..#.#.#............\n.###..##...###..##...#....###..#..#.##.............\n.#....#.#..#....#.#..#....#....###..#.#............\n.#....#.#..#....#.#..#..#.#....#.#..#.#............\n.#....#..#.####.#..#..##..#....#..#.#..#...........\n..................................................."
  end
end