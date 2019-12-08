defmodule Day8Test do
  use ExUnit.Case
  doctest Day8

  test "part 1" do
    assert Day8.part1() == 1474
  end

  test "part 1 - sample 1" do
    assert Day8.part1("sample1") == 1
  end

  test "part 1 - sample 2" do
    assert Day8.part1("sample2") == 1
  end

  test "part 2" do
    assert Day8.part2() == "..██..██..███...██..███..\n...█.█..█.█..█.█..█.█..█.\n...█.█....█..█.█....███..\n...█.█....███..█....█..█.\n█..█.█..█.█.█..█..█.█..█.\n.██...██..█..█..██..███.."
  end

  test "part 2 - sample 1" do
    assert Day8.part2("sample1") == "█83\n456"
  end

  test "part 2 - sample 2" do
    assert Day8.part2("sample2") == ".█\n█."
  end

  test "update canvas" do
    assert Day8.update_canvas("1212", ["1", "1", "2", "2"]) == ["1", "1", "1", "2"]
  end
end
