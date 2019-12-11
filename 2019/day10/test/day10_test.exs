defmodule Day10Test do
  use ExUnit.Case
  doctest Day10

  # Sample occulousion
  # lower case letters are blocked by upper case
  # #.........
  # ...A......
  # ...B..a...
  # .EDCG....a
  # ..F.c.b...
  # .....c....
  # ..efd.c.gb
  # .......c..
  # ....f...c.
  # ...e..d..c

  # .7..7
  # .....
  # 67775
  # ....7
  # ...87
  test "sample 1" do
    assert Day10.part1("sample1") == {3, 4, 8}
  end

  test "sample 2" do
    assert Day10.part1("sample2") == {5, 8, 33}
  end

  test "sample 3" do
    assert Day10.part1("sample3") == {1, 2, 35}
  end

  test "sample 4" do
    assert Day10.part1("sample4") == {6, 3, 41}
  end

  test "sample 5" do
    assert Day10.part1("sample5") == {11, 13, 210}
  end

  test "part 1" do
    assert Day10.part1("prod") == {17, 22, 276}
  end

  test "sample 5 - part 2" do
    assert Day10.part2("sample5", 1) == 1112
    assert Day10.part2("sample5", 2) == 1201
    assert Day10.part2("sample5", 3) == 1202
    assert Day10.part2("sample5", 10) == 1208
    assert Day10.part2("sample5", 20) == 1600
    assert Day10.part2("sample5", 50) == 1609
    assert Day10.part2("sample5", 100) == 1016
    assert Day10.part2("sample5", 199) == 906
    assert Day10.part2("sample5", 200) == 802
    assert Day10.part2("sample5", 201) == 1009
    # TODO
    assert Day10.part2("sample5", 299) == 1101
  end

  test "part 2" do
    assert Day10.part2("prod") == 1321
  end
end
