defmodule Day1Test do
  use ExUnit.Case
  doctest Day1

  test "rocket fuel required for masses" do
    assert Day1.naive_fuel(12) == 2
    assert Day1.naive_fuel(14) == 2
    assert Day1.naive_fuel(1969) == 654
    assert Day1.naive_fuel(100756) == 33583
  end

  test "naive solution" do
    assert Day1.naive_solution() == 3315383
  end

  test "recur fuel" do
    assert Day1.recur_fuel(14) == 2
    assert Day1.recur_fuel(1969) == 966
    assert Day1.recur_fuel(100756) == 50346
  end

  test "recur solution" do
    assert Day1.full_solution() == 4970206
  end
end
