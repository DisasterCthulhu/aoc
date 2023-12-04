defmodule Day19Test do
  use ExUnit.Case
  doctest Day19

  test "part 1" do
    assert Day19.part1() == 131
  end

  test "part 2" do
    assert Day19.part2() == 15_231_022
  end
end
