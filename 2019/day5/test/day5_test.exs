defmodule Day5Test do
  use ExUnit.Case
  doctest Day5

  test "Day5.part1" do
    assert Day5.part1() |> Intcode.state_io_out() |> List.last() == 5_577_461
  end

  test "Day5.part2" do
    assert Day5.part2() |> Intcode.state_io_out() |> List.last() == 7_161_591
  end

  test "1101,100,-1,4,0" do
    assert "1101,100,-1,4,0"
           |> Intcode.prog()
           |> Intcode.state_mem()
           |> String.starts_with?("1101,100,-1,4,99")
  end

  test "1002,4,3,4,33" do
    assert "1002,4,3,4,33"
           |> Intcode.prog()
           |> Intcode.state_mem()
           |> String.starts_with?("1002,4,3,4,99")
  end

  test "day2 sample1" do
    assert "1,0,0,0,99"
           |> Intcode.prog()
           |> Intcode.state_mem()
           |> String.starts_with?("2,0,0,0,99")
  end

  test "day2 sample2" do
    assert "2,3,0,3,99"
           |> Intcode.prog()
           |> Intcode.state_mem()
           |> String.starts_with?("2,3,0,6,99")
  end

  test "day2 sample3" do
    assert "2,4,4,5,99,0"
           |> Intcode.prog()
           |> Intcode.state_mem()
           |> String.starts_with?("2,4,4,5,99,9801")
  end

  test "day2 sample4" do
    assert "1,1,1,4,99,5,6,0,99"
           |> Intcode.prog()
           |> Intcode.state_mem()
           |> String.starts_with?("30,1,1,4,2,5,6,0,99")
  end

  test "output input" do
    assert "3,0,4,0,99" |> Intcode.prog([9]) |> Intcode.state_io_out() == [9]
  end

  test "pos mode, input == 8: 3,9,8,9,10,9,4,9,99,-1,8" do
    assert "3,9,8,9,10,9,4,9,99,-1,8" |> Intcode.prog([8]) |> Intcode.state_io_out() == [1]
    assert "3,9,8,9,10,9,4,9,99,-1,8" |> Intcode.prog([0]) |> Intcode.state_io_out() == [0]
  end

  test "pos mode, input le 8: 3,9,7,9,10,9,4,9,99,-1,8" do
    assert "3,9,7,9,10,9,4,9,99,-1,8" |> Intcode.prog([7]) |> Intcode.state_io_out() == [1]
    assert "3,9,7,9,10,9,4,9,99,-1,8" |> Intcode.prog([8]) |> Intcode.state_io_out() == [0]
  end

  test "imm mode, input == 8: 3,3,1108,-1,8,3,4,3,99" do
    assert "3,3,1108,-1,8,3,4,3,99" |> Intcode.prog([8]) |> Intcode.state_io_out() == [1]
    assert "3,3,1108,-1,8,3,4,3,99" |> Intcode.prog([0]) |> Intcode.state_io_out() == [0]
  end

  test "imm mode, input le 8: 3,3,1107,-1,8,3,4,3,99" do
    assert "3,3,1107,-1,8,3,4,3,99" |> Intcode.prog([7]) |> Intcode.state_io_out() == [1]
    assert "3,3,1107,-1,8,3,4,3,99" |> Intcode.prog([8]) |> Intcode.state_io_out() == [0]
  end

  test "je/jne" do
    assert "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9"
           |> Intcode.prog([0])
           |> Intcode.state_io_out() == [0]

    assert "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9"
           |> Intcode.prog([1])
           |> Intcode.state_io_out() == [1]
  end

  test "larger example" do
    prog =
      "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99"

    assert prog |> Intcode.prog([7]) |> Intcode.state_io_out() == [999]
    assert prog |> Intcode.prog([8]) |> Intcode.state_io_out() == [1000]
    assert prog |> Intcode.prog([9]) |> Intcode.state_io_out() == [1001]
  end
end
