defmodule Day17Test do
  use ExUnit.Case
  doctest Day17

  test "part1" do
    assert Day17.part1() == 11_140
  end

  test "part2" do
    assert Day17.part2() == 1_113_108
  end
end
