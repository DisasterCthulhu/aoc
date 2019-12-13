defmodule Day12Test do
  use ExUnit.Case
  doctest Day12

  test "part1 - sample 1" do
    assert Day12.part1("sample1") == 179
  end

  test "part1 - sample 2" do
    assert Day12.part1("sample2") == 1940
  end

  test "part1" do
    assert Day12.part1() == 13500
  end

  test "part2 - sample1" do
    assert Day12.part2("sample1") == 2772
  end

  test "part2 - sample2" do
    assert Day12.part2("sample2") == 4686774924
  end

  test "part2" do
    assert Day12.part2() == 278013787106916
  end
end
