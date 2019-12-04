defmodule Day3Test do
  use ExUnit.Case
  doctest Day3

  test "manhattan distance" do
    assert Day3.mdist(0, [2, 1]) == 3
    assert Day3.mdist(0, [1, 2]) == 3
    assert Day3.mdist(0, [1, 1]) == 2
    assert Day3.mdist(0, [1, 0]) == 1
    assert Day3.mdist(0, [0, 1]) == 1
  end

  test "simple wires" do
    assert Day3.wires("R2,U2") |> Day3.key_set == [MapSet.new([{1, 0}, {2, 0}, {2, 1}, {2, 2}])]
  end

  test "sample fin 1" do
    assert Day3.min_dist(Day3.intersections(Day3.wires("""
R75,D30,R83,U83,L12,D49,R71,U7,L72
U62,R66,U55,R34,D71,R55,D58,R83
""") |> Day3.key_set)) == 159
    end

    test "sample fin 2" do
    assert Day3.min_dist(Day3.intersections(Day3.wires("""
R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
U98,R91,D20,R16,D67,R40,U7,R15,U6,R7
""") |> Day3.key_set)) == 135
  end

  test "part 1" do
    assert Day3.part1 == 489
  end

  test "part 2" do
    assert Day3.part2 == 93654
  end
end
