defmodule Day7Test do
  use ExUnit.Case
  doctest Day7

  test "permutations" do
    assert Day7.permutations([0, 1, 2]) == [[0, 1, 2], [0, 2, 1], [1, 0, 2], [1, 2, 0], [2, 0, 1], [2, 1, 0]]
  end

  test "part 1" do
    assert Day7.part1() == 75_228
  end

  test "part 2" do
    assert Day7.part2() == 79_846_026
  end

  test "sample 1" do
    assert Day7.part1("sample1") == 43_210
  end
  test "sample 2" do
    assert Day7.part1("sample2") == 54_321
  end
  test "sample 3" do
    assert Day7.part1("sample3") == 65_210
  end
  test "sample 4" do
    assert Day7.part2("sample4") == 139_629_729
  end
  test "sample 5" do
    assert Day7.part2("sample5") == 18_216
  end

end
