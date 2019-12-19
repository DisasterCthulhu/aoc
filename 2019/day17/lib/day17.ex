defmodule Day17 do
  @moduledoc """
  Advent of Code -- Day 17
  """
  def input(file) do
    {:ok, contents} = File.read("dat/" <> file)
    contents |> String.trim()
  end

  def part1 do
    board =
      input("prod")
      |> Intcode.prog()
      |> Intcode.state_io_out()
      |> parse_board()
      |> classifiable()
      |> Enum.into(%{})

    intersections =
      board
      |> Enum.filter(fn {pos, _icon} ->
        pos |> all_valid?(board)
      end)

    intersections
    |> Enum.reduce(0, fn {{y, x}, _icon}, acc ->
      acc + y * x
    end)
  end

  def part2 do
    bot =
      input("prod")
      |> String.replace("1", "2", global: false)
      |> Intcode.prog()

    board =
      bot
      |> Intcode.state_io_out()
      |> parse_board()
      |> classifiable()
      |> Enum.into(%{})

    path = gen_path(board)
    commands = gen_commands(path)
    formatted = format_commands(commands)

    state =
      Intcode.run(
        bot,
        commands_to_charlist(formatted)
      )

    state |> Intcode.state_io_out() |> List.last()
  end

  def gen_path(board) do
    start = board |> Enum.filter(fn {_pos, icon} -> icon in dirs() end) |> hd

    1..1000
    |> Enum.reduce_while({start, []}, fn _, {{pos, icon}, moves} ->
      {pos, move} =
        if check_move({pos, icon}, board), do: {move(icon, pos), "1"}, else: {pos, nil}

      {icon, move} = if move, do: {icon, move}, else: turn({pos, icon}, board)

      if move do
        {:cont, {{pos, icon}, moves ++ [move]}}
      else
        {:halt, moves}
      end
    end)
  end

  def gen_commands(path) do
    path = path |> to_string
    a = find_shared_prefix(path)

    path =
      path
      |> String.replace(a, "A", global: true)

    b =
      path
      |> String.replace(~r/^[A]*/, "")
      |> find_shared_prefix

    path =
      path
      |> String.replace(b, "B", global: true)

    c =
      path
      |> String.replace(~r/^[AB]*/, "")
      |> find_shared_prefix

    path =
      path
      |> String.replace(c, "C", global: true)

    {path, a, b, c}
  end

  def find_shared_prefix(search) do
    prefix =
      1..String.length(search)
      |> Enum.reduce_while(0, fn check, len ->
        str = String.slice(search, 0, check)

        parts =
          search
          |> String.split(str)
          |> tl
          |> Enum.count()

        if parts > 1 && String.last(str) not in ["A", "B", "C"] do
          {:cont, check}
        else
          {:halt, len}
        end
      end)

    String.slice(search, 0, prefix)
  end

  def format_commands({main, a, b, c}) do
    a = a |> count_ones |> split_commands
    b = b |> count_ones |> split_commands
    c = c |> count_ones |> split_commands
    main = main |> count_ones |> split_commands
    Enum.join([main, a, b, c, "n"], "\n") <> "\n"
  end

  def count_ones(str) do
    12..2
    |> Enum.reduce(str, fn amt, str ->
      str |> String.replace(String.duplicate("1", amt), amt |> to_string)
    end)
  end

  def split_commands(str) do
    str
    |> String.replace("L", ",L,")
    |> String.replace("R", ",R,")
    |> String.replace("A", "A,")
    |> String.replace("B", "B,")
    |> String.replace("C", "C,")
    |> String.replace_leading(",", "")
    |> String.replace_trailing(",", "")
  end

  def commands_to_charlist(commands) do
    commands |> String.to_charlist()
  end

  def valids(pos, board) do
    adjacent(pos)
    |> Enum.filter(fn pos ->
      Map.get(board, pos)
    end)
  end

  def all_valid?(pos, board) do
    adjacent(pos)
    |> Enum.all?(fn pos ->
      Map.get(board, pos)
    end)
  end

  def valid?(pos, board) do
    Map.get(board, pos)
  end

  def turn({{y, x}, icon}, board) do
    opts = valids({y, x}, board)

    moves =
      if icon in ["^", "v"] do
        Enum.filter(opts, fn {my, _mx} ->
          my == y
        end)
      else
        Enum.filter(opts, fn {_my, mx} ->
          mx == x
        end)
      end

    icon_turn(icon, {y, x}, moves)
  end

  def icon_turn(icon, {_y, _x}, []), do: {icon, nil}
  def icon_turn("^", {_, x}, [{_, mx}]), do: if(mx < x, do: {"<", "L"}, else: {">", "R"})
  def icon_turn("v", {_, x}, [{_, mx}]), do: if(mx < x, do: {"<", "R"}, else: {">", "L"})
  def icon_turn("<", {y, _}, [{my, _}]), do: if(my > y, do: {"v", "L"}, else: {"^", "R"})
  def icon_turn(">", {y, _}, [{my, _}]), do: if(my > y, do: {"v", "R"}, else: {"^", "L"})

  def check_move({pos, icon}, board) do
    valid?(move(icon, pos), board)
  end

  def dirs, do: ["^", "v", "<", ">"]
  def move("^", {y, x}), do: {y - 1, x}
  def move(">", {y, x}), do: {y, x + 1}
  def move("v", {y, x}), do: {y + 1, x}
  def move("<", {y, x}), do: {y, x - 1}

  def adjacent(pos) do
    dirs()
    |> Enum.map(fn d -> move(d, pos) end)
  end

  def classifiable(board) do
    board |> Enum.filter(fn {_pos, icon} -> icon in (["#", "X"] ++ dirs()) end)
  end

  def parse_board(map) do
    map
    |> to_string
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
end
