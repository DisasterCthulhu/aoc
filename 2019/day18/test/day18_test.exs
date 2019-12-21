defmodule Day18Test do
  use ExUnit.Case
  doctest Day18

  test "part1 - sample1" do
    assert Day18.part1("sample1") == 86
  end

  test "part1 - sample2" do
    assert Day18.part1("sample2") == 132
  end

  test "part1 - sample3" do
    assert Day18.part1("sample3") == 136
  end

  test "part1 - sample4" do
    assert Day18.part1("sample4") == 81
  end

  test "part1" do
    assert Day18.part1() == 5262
  end

  test "part2 - don't trust the method name" do
    assert Day18.part1("part2") == 2136
  end
end
