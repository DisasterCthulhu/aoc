defmodule Day13Test do
  use ExUnit.Case
  doctest Day13

  test "part 1" do
    assert Day13.part1() == 296
  end

  test "part 2" do
    assert Day13.part2("prod", false) == 13_824
  end
end
