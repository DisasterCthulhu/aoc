defmodule Day4Test do
  use ExUnit.Case
  doctest Day4

  test "solves part 1" do
    assert Day4.part1() == 1890
  end

  test "solves part 2" do
    assert Day4.part2() == 1277
  end

  test "contains duplicates" do 
    assert Day4.rule_dupes(111111) == true
    assert Day4.rule_dupes(223450) == true
    assert Day4.rule_dupes(121212) == false
    assert Day4.rule_dupes(123789) == false
  end

  test "never decreases" do
    assert Day4.rule_gte(111111) == true
    assert Day4.rule_gte(223450) == false
    assert Day4.rule_gte(123789) == true
  end

  test "rule pairs" do
    assert Day4.rule_pairs(111111) == false
    assert Day4.rule_pairs(112233) == true
    assert Day4.rule_pairs(123444) == false
    assert Day4.rule_pairs(111122) == true
  end
end
