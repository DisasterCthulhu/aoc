defmodule Day18 do
  @moduledoc """
  Advent of Code == Day 18
  """

  def init do
    if :ets.whereis(:routes) == :undefined do
      :ets.new(:routes, [:named_table])
    else
      :ets.delete_all_objects(:routes)
    end
  end

  def input(file) do
    {:ok, contents} = File.read("dat/" <> file)
    contents |> String.trim()
  end

  def memo_or_bfs(start, search, _keys, board) do
    cache = :ets.lookup(:routes, {start, search})

    case cache do
      [] ->
        result = bfs(board, start, fn_goal(search))

        if result do
          {_found, path} = result
          {distance, doors} = path_reduce(path, board)
          [pos] = Map.keys(path)
          :ets.insert(:routes, {{start, search}, {pos, distance, doors}})
          {pos, distance, doors}
        else
          :ets.insert(:routes, {{start, search}, nil})
        end

      [{_, {pos, distance, doors}}] ->
        {pos, distance, doors}

      [{_, nil}] ->
        nil
    end
  end

  def keys_for_doors?(keys, doors) do
    needed_keys =
      doors
      |> Enum.map(fn door -> String.downcase(door) end)
      |> MapSet.new()

    MapSet.subset?(needed_keys, keys)
  end

  def search_is_possible?({_pos, _dist, doors}, keys) do
    keys_for_doors?(keys, doors)
  end

  def possible_move(start, search, keys, board) do
    possible_route = memo_or_bfs(start, search, keys, board)

    if is_tuple(possible_route) && search_is_possible?(possible_route, keys) do
      {pos, dist, _doors} = possible_route
      {pos, MapSet.put(keys, search), dist}
    end
  end

  def update_state(state, moves) do
    moves
    |> Stream.with_index()
    |> Enum.reduce(state, fn {move, i}, {robots, keys, dist} ->
      if move do
        {pos, keyset, steps} = move
        robots = List.replace_at(robots, i, pos)
        {robots, keyset, dist + steps}
      else
        {robots, keys, dist}
      end
    end)
  end

  def memo_search(targets, robots, steps, keys, board) do
    targets
    |> Stream.map(fn search ->
      moves =
        robots
        |> Enum.map(fn start ->
          possible_move(start, search, keys, board)
        end)

      if Enum.any?(moves) do
        {robots, keys, dist} = update_state({robots, keys, steps}, moves)
        {{robots, keys}, dist}
      end
    end)
    |> Enum.filter(fn x -> x end)
    |> Enum.into(%{})
  end

  def board_search(board, state, all_keys) do
    state
    |> Stream.map(fn {{start, found}, dist} ->
      MapSet.difference(all_keys, found)
      |> memo_search(start, dist, found, board)
    end)
    |> Enum.reduce(%{}, fn x, acc ->
      Map.merge(x, acc, fn _k, v1, v2 -> min(v1, v2) end)
    end)
  end

  def part1, do: part1("prod")

  def part1(file) do
    init()

    board =
      input(file)
      |> parse_board()
      |> Enum.into(%{})

    objects =
      board
      |> objects
      |> Enum.into(%{})

    robots =
      objects
      |> Enum.filter(fn {_pos, icon} -> icon == "@" end)
      |> Enum.map(fn {pos, _icon} -> pos end)

    all_keys =
      objects
      |> Map.values()
      |> Enum.filter(fn v ->
        v != "@" && String.downcase(v) == v
      end)
      |> MapSet.new()

    state = %{{robots, MapSet.new()} => 0}

    {{_, _}, moves} =
      all_keys
      |> Enum.reduce(state, fn _, state ->
        board_search(board, state, all_keys)
      end)
      |> Enum.min_by(fn {{_pos, _found}, dist} -> dist end)

    moves
  end

  def part2 do
  end

  def fn_goal(search) do
    fn _g, _seen, head, _key, val ->
      if search == val do
        {:halt, {search, head}}
      else
        {:cont, nil}
      end
    end
  end

  def parse_board(map) do
    map
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, y}, acc ->
      row
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {col, x}, acc ->
        Map.put(acc, {y, x}, col)
      end)
    end)
  end

  def objects(board) do
    board |> Enum.filter(fn {_pos, icon} -> icon not in ["#", "."] end)
  end

  def move('N', {y, x}), do: {y - 1, x}
  def move('E', {y, x}), do: {y, x + 1}
  def move('S', {y, x}), do: {y + 1, x}
  def move('W', {y, x}), do: {y, x - 1}
  def dirs, do: ['N', 'S', 'W', 'E']

  def adjacent(pos) do
    dirs()
    |> Enum.map(fn d -> move(d, pos) end)
  end

  def path_reduce(path, board) do
    Stream.cycle(0..0)
    |> Enum.reduce_while({path, 0, MapSet.new()}, fn _, {p, d, doors} ->
      if p == nil do
        {:halt, {d - 1, doors}}
      else
        [key] = Map.keys(p)
        v = Map.get(board, key)

        doors =
          if v not in [".", "@"] && String.capitalize(v) == v,
            do: MapSet.put(doors, v),
            else: doors

        {:cont, {p |> Map.values() |> hd, d + 1, doors}}
      end
    end)
  end

  def q_neighbors(g, q, parent, seen) do
    [key] = Map.keys(parent)

    Enum.reduce(adjacent(key), {q, seen}, fn pos, {q, seen} ->
      if Map.get(g, pos) != "#" && pos not in seen do
        {q ++ [%{pos => parent}], MapSet.put(seen, pos)}
      else
        {q, seen}
      end
    end)
  end

  def bfs(g, start, goal), do: bfs(g, start, goal, fn _head -> nil end)
  def bfs(g, start, goal, :deep), do: bfs(g, start, goal, fn head -> head end)

  def bfs(g, start, goal, fail) do
    q = []
    seen = MapSet.new([start])
    q = q ++ [%{start => nil}]
    bfs_search(g, q, seen, goal, fail)
  end

  def bfs_search(_g, [], _seen, _goal, _fail) do
    nil
  end

  def bfs_search(g, q, seen, goal, fail) do
    [head | tail] = q
    [key] = Map.keys(head)

    {status, resp} = goal.(g, seen, head, key, g[key])

    if status == :halt do
      resp
    else
      {q, seen} = q_neighbors(g, tail, head, seen)
      bfs_search(g, q, seen, goal, fail) || fail.(head)
    end
  end
end
