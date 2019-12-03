defmodule Day2Test do
  use ExUnit.Case
  doctest Day2

  test "prog(input)" do
    i = Day2.input()
    i = List.replace_at(i, 1, 12)
    i = List.replace_at(i, 2, 2)
    assert List.first(Day2.prog(i) |> String.split(","))  == "3562672"
  end

  test "prog(input)[0] == 19690720" do
    raw = Day2.input()
    [verb, noun] = Enum.reduce(0..99, -1,
      fn x, accx -> 
        if accx == -1 do
          Enum.reduce(0..99, -1,
            fn y, accy -> 
              i = List.replace_at(raw, 1, x)
              i = List.replace_at(i, 2, y)
              cond do
                accy != -1 -> accy
                List.first(Day2.prog(i) |> String.split(",")) == "19690720" -> 
                  IO.puts(Enum.join(["Part 2 is", x, y], ","))
                  [x, y]
                true -> accx
              end
            end
          )
        else
          accx
        end
      end
    )
    assert 100 * verb + noun == 8250
  end

  test "sample1" do
    assert Day2.prog(Day2.parse("1,0,0,0,99")) == "2,0,0,0,99"
  end

  test "sample2" do
    assert Day2.prog(Day2.parse("2,3,0,3,99")) == "2,3,0,6,99"
  end

  test "sample3" do
    assert Day2.prog(Day2.parse("2,4,4,5,99,0")) == "2,4,4,5,99,9801"
  end

  test "sample4" do
    assert Day2.prog(Day2.parse("1,1,1,4,99,5,6,0,99")) == "30,1,1,4,2,5,6,0,99"
  end

end
