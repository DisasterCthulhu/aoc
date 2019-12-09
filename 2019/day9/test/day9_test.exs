defmodule Day9Test do
  use ExUnit.Case
  doctest Day9

  test "Day9.part1()" do
    assert Day9.part1() |> Intcode.state_io_out() == [3_345_854_957]
  end

  test "sample 1" do
    assert Day9.part1("sample1") |> Intcode.state_io_out() ==
             Day9.input("sample1") |> String.split(",") |> Enum.map(&String.to_integer/1)
  end

  test "sample 2" do
    assert Day9.part1("sample2") |> Intcode.state_io_out() == [1_219_070_632_396_864]
  end

  test "sample 3" do
    assert Day9.part1("sample3") |> Intcode.state_io_out() == [1_125_899_906_842_624]
  end

  test "opcode 9" do
    # IO to 1985, offset changes to output IO
    assert "3,1985,109,2000,109,19,204,-34,99" |> Intcode.prog([999]) |> Intcode.state_io_out() ==
             [999]
  end

  test "Day9.part2()" do
    assert Day9.part2() |> Intcode.state_io_out() == [68_938]
  end
end
