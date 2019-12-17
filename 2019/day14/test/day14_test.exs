defmodule Day14Test do
  use ExUnit.Case
  doctest Day14

  test "part1" do
    assert Day14.part1() == 1_065_255
  end

  test "part1 sample 1" do
    assert Day14.part1("sample1") == 31
  end

  test "part1 sample 2" do
    assert Day14.part1("sample2") == 165
  end

  test "part1 sample 3" do
    assert Day14.part1("sample3") == 13_312
  end

  test "part1 sample 4" do
    assert Day14.part1("sample4") == 180_697
  end

  test "part1 sample 5" do
    assert Day14.part1("sample5") == 2_210_736
  end

  test "part2 sample 3" do
    assert Day14.part2("sample3") == 82_892_753
  end

  test "part2 sample 4" do
    assert Day14.part2("sample4") == 5_586_022
  end

  test "part2 sample 5" do
    assert Day14.part2("sample5") == 460_664
  end

  test "part 2 -- known" do
    assert Day14.part2("prod", 1_065_255) == 1
  end

  test "part 2 - actual" do
    assert Day14.part2() == 1_766_154
  end
end
