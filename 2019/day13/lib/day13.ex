defmodule Day13 do
  @moduledoc """
  Advent of Code -- Day 13: Care Package
  """

  def input(file) do
    {:ok, contents} = File.read("dat/" <> file)

    contents |> String.trim()
  end

  def part1, do: part1("prod")

  def part1(file) do
    input(file)
    |> Intcode.prog()
    |> Intcode.state_io_out()
    |> to_img
    |> render
    |> String.codepoints()
    |> Enum.count(fn x -> x == "%" end)
  end

  def part2, do: part2("prod", true)

  def part2(file, display) do
    state =
      input(file)
      |> String.replace("1", "2", global: false)
      |> Intcode.prog([0])

    if display,
      do: Stream.interval(1) |> robot(state, display),
      else: Stream.cycle(0..0) |> robot(state, display)
  end

  def robot(enum, state, display) do
    enum
    |> Enum.reduce_while({state, %{}}, fn _, {state, board} ->
      board = state |> Intcode.state_io_out() |> to_img(board)
      score = Map.get(board, {0, -1})
      ball = Map.get(board, {-1, 0})
      paddle = Map.get(board, {-1, -1})

      if display do
        board |> render |> IO.puts()
        IO.puts(inspect(score))
      end

      if has_blocks(board) do
        {_, bx} = ball
        {_, px} = paddle
        {:cont, {Intcode.run(state, [move(px, bx)]), board}}
      else
        {:halt, score}
      end
    end)
  end

  def move(px, bx) do
    cond do
      bx > px -> 1
      bx < px -> -1
      true -> 0
    end
  end

  def to_img(list), do: to_img(list, %{})

  def to_img(list, board) do
    list
    |> Enum.chunk_every(3)
    |> Enum.reduce(board, fn [x, y, c], acc ->
      acc = if c == 3, do: Map.put(acc, {-1, -1}, {y, x}), else: acc
      acc = if c == 4, do: Map.put(acc, {-1, 0}, {y, x}), else: acc
      Map.put(acc, {y, x}, c)
    end)
  end

  def has_blocks(board) do
    Map.values(board) |> Enum.any?(fn x -> x == 2 end)
  end

  def char(0), do: " "
  def char(1), do: "#"
  def char(2), do: "%"
  def char(3), do: "_"
  def char(4), do: "*"

  def render(img) do
    Enum.map(0..24, fn y ->
      Enum.map(0..50, fn x ->
        char(Map.get(img, {y, x}, 0))
      end)
    end)
    |> Enum.join("\n")
  end
end
