defmodule Day19 do
  @moduledoc """
  Advent of Code -- Day 19: Tractor Beam
  """

  def input(file) do
    {:ok, contents} = File.read("dat/" <> file)
    contents |> String.trim()
  end

  def board(probe), do: board(probe, 0..9, 0..9)

  def board(probe, yrange, xrange) do
    yrange
    |> Enum.flat_map(fn y ->
      xrange
      |> Enum.map(fn x ->
        {{y, x}, Intcode.run(probe, [x, y]) |> Intcode.state_io_out() |> hd}
      end)
    end)
    |> Enum.filter(fn {_, v} -> v > 0 end)
    |> Enum.into(%{})
  end

  def part1 do
    probe = input("prod") |> Intcode.prog()

    board(probe, 0..49, 0..49)
    |> Enum.count()
  end

  def part2 do
    probe = input("prod") |> Intcode.prog()
    board = board(probe, 0..9, 0..9)
    {{hy, hx}, 1} = board |> Enum.max()

    start =
      Stream.cycle(0..0)
      |> Enum.reduce_while({hy * 100, hx * 100}, fn _, {y, x} ->
        {{y, x}, c} = probe(probe, y, x)
        {{_y, x}, d} = probe(probe, y + 1, x)

        if c == 1 && d == 0 do
          {:halt, {y, x}}
        else
          if c == 0 do
            {:cont, {y - 1, x}}
          else
            {:cont, {y + 1, x}}
          end
        end
      end)

    {{_y, _x}, val} =
      Stream.cycle(0..0)
      |> Enum.reduce_while(start, fn _, {y, x} ->
        {{y, x}, a} = probe(probe, y, x)
        {{ly, _lx}, b} = probe(probe, y - 99, x + 99)

        if a == 1 && b == 1 do
          {:halt, {{ly, x}, x * 10_000 + ly}}
        else
          if a == 0 do
            {:cont, {y, x + 1}}
          else
            {:cont, {y + 1, x}}
          end
        end
      end)

    val
  end

  def probe(probe, y, x) do
    {{y, x}, Intcode.run(probe, [x, y]) |> Intcode.state_io_out() |> hd}
  end

  def char(0), do: " "
  def char(1), do: "#"

  def render(img) do
    {{miny, minx}, _} = img |> Enum.min()
    {{maxy, maxx}, _} = img |> Enum.max()

    Enum.map(miny..maxy, fn y ->
      Enum.map(minx..maxx, fn x ->
        char(Map.get(img, {y, x}, 0))
      end)
    end)
    |> Enum.join("\n")
  end
end
