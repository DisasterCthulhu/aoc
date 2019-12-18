defmodule Day16Test do
  use ExUnit.Case
  doctest Day16

  test "part 1 - sample 1" do
    assert Day16.part1("sample1", 4) == "01029498"
  end

  test "part 1 - sample 2" do
    assert Day16.part1("sample2", 100) |> String.slice(0, 8) == "24176176"
  end

  test "part 1 - sample 3" do
    assert Day16.part1("sample3", 100) |> String.slice(0, 8) == "73745418"
  end

  test "part 1 - sample 4" do
    assert Day16.part1("sample4", 100) |> String.slice(0, 8) == "52432133"
  end

  test "part 1" do
    assert Day16.part1("prod", 100) |> String.slice(0, 8) == "58100105"
  end

  test "part 2 - sample 5" do
    assert Day16.part2("sample5", 100) |> String.slice(0, 8) == "84462026"
  end

  test "part 2 - sample 6" do
    assert Day16.part2("sample6", 100) |> String.slice(0, 8) == "78725270"
  end

  test "part 2 - sample 7" do
    assert Day16.part2("sample7", 100) |> String.slice(0, 8) == "53553731"
  end

  test "part 2" do
    assert Day16.part2("prod", 100) |> String.slice(0, 8) == "41781287"
  end
end
