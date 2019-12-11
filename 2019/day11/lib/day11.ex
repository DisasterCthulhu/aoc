defmodule Day11 do
  @moduledoc """
  Advent of Code -- Day 11: Space Police
  """

  def input(file) do
    {:ok, contents} = File.read("dat/" <> file)

    contents |> String.trim()
  end

  def part1 do
    input("prod") |> Intcode.prog() |> robot(0)
  end

  def part2 do
    input("prod") |> Intcode.prog() |> robot(1)
  end

  def face('N', 0), do: 'W'
  def face('N', 1), do: 'E'
  def face('E', 0), do: 'N'
  def face('E', 1), do: 'S'
  def face('S', 0), do: 'E'
  def face('S', 1), do: 'W'
  def face('W', 0), do: 'S'
  def face('W', 1), do: 'N'

  # Y, X
  def move('N', {y, x}), do: {y - 1, x}
  def move('E', {y, x}), do: {y, x + 1}
  def move('S', {y, x}), do: {y + 1, x}
  def move('W', {y, x}), do: {y, x - 1}

  def robot(state, 1), do: render(robot(state, {0, 0}, 'N', %{{0, 0} => 1}))
  def robot(state, 0), do: map_size(robot(state, {0, 0}, 'N', %{{0, 0} => 0}))

  def robot(state, pos, nesw, board) do
    state = Intcode.run(state, [Map.get(board, pos, 0)])

    resp = state |> Intcode.state_io_out()

    if Enum.count(resp) == 2 do
      [color, turn] = resp
      board = Map.put(board, pos, color)
      nesw = face(nesw, turn)
      pos = move(nesw, pos)
      robot(state, pos, nesw, board)
    else
      board
    end
  end

  def char(1), do: "#"
  def char(0), do: "."

  def render(img) do
    Enum.map(0..6, fn y ->
      Enum.map(0..50, fn x ->
        char(Map.get(img, {y, x}, 0))
      end)
    end)
    |> Enum.join("\n")
  end
end
