defmodule Day4Test do
  use ExUnit.Case
  doctest Day4

  test "solves part 1" do
    assert Day4.part1() == 1_890
  end

  test "solves part 2" do
    assert Day4.part2() == 1_277
  end

  test "contains duplicates" do
    assert Day4.rule_dupes(111_111) == true
    assert Day4.rule_dupes(223_450) == true
    assert Day4.rule_dupes(121_212) == false
    assert Day4.rule_dupes(123_789) == false
  end

  test "never decreases" do
    assert Day4.rule_gte(111_111) == true
    assert Day4.rule_gte(223_450) == false
    assert Day4.rule_gte(123_789) == true
  end

  test "rule pairs" do
    assert Day4.rule_pairs(111_111) == false
    assert Day4.rule_pairs(112_233) == true
    assert Day4.rule_pairs(123_444) == false
    assert Day4.rule_pairs(111_122) == true
  end
end
