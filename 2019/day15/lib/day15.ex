defmodule Day15 do
  @moduledoc """
  Advent of Code -- Day 15
  """

  def input(file) do
    {:ok, contents} = File.read("dat/" <> file)
    contents |> String.trim()
  end

  def part1 do
    board =
      input("prod")
      |> Intcode.prog()
      |> dfs_robot

    bfs(board, {0, 0}, 2)
    |> path_depth
  end

  def part2 do
    board =
      input("prod")
      |> Intcode.prog()
      |> dfs_robot

    [start] = bfs(board, {0, 0}, 2) |> Map.keys()

    bfs(board, start, 5)
    |> path_depth
  end

  def go('N'), do: [1]
  def go('E'), do: [4]
  def go('S'), do: [2]
  def go('W'), do: [3]

  def move('N', {y, x}), do: {y - 1, x}
  def move('E', {y, x}), do: {y, x + 1}
  def move('S', {y, x}), do: {y + 1, x}
  def move('W', {y, x}), do: {y, x - 1}

  def dirs, do: ['N', 'S', 'W', 'E']

  def path_depth(path) do
    Stream.cycle(0..0)
    |> Enum.reduce_while({path, 0}, fn _, {p, d} ->
      if p == nil do
        {:halt, d - 1}
      else
        {:cont, {p |> Map.values() |> hd, d + 1}}
      end
    end)
  end

  def adjacent(pos) do
    dirs()
    |> Enum.map(fn d -> move(d, pos) end)
  end

  def q_neighbors(g, q, parent, seen) do
    [key] = Map.keys(parent)

    Enum.reduce(adjacent(key), {q, seen}, fn pos, {q, seen} ->
      if Map.get(g, pos) && pos not in seen do
        {q ++ [%{pos => parent}], MapSet.put(seen, pos)}
      else
        {q, seen}
      end
    end)
  end

  def bfs(g, start, goal) do
    q = []
    seen = MapSet.new([start])
    q = q ++ [%{start => nil}]
    bfs_search(Map.put(g, 0, 0), q, seen, goal)
  end

  def bfs_search(_g, [], _seen, _goal) do
    nil
  end

  def bfs_search(g, q, seen, goal) do
    [head | tail] = q
    [key] = Map.keys(head)

    if Map.get(g, key) == goal do
      head
    else
      g = Map.put(g, 0, Map.get(g, 0) + 1)
      {q, seen} = q_neighbors(g, tail, head, seen)
      # deepest node
      bfs_search(g, q, seen, goal) || head
    end
  end

  def dfs_robot(state), do: dfs_robot(state, {0, 0}, %{{0, 0} => 3})

  def dfs_robot(state, pos, board) do
    Enum.reduce(dirs(), board, fn d, board ->
      if Map.get(board, move(d, pos)) do
        board
      else
        state = Intcode.run(state, go(d))
        resp = state |> Intcode.state_io_out() |> hd

        if resp in [1, 2] do
          pos = move(d, pos)
          dfs_robot(state, pos, Map.put(board, pos, resp))
        else
          board
        end
      end
    end)
  end
end
