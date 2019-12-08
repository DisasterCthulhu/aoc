defmodule Day8 do
  @moduledoc """
  Advent of Code 2019 -- Day 8
  """
  def input, do: input("prod")
  def input(file) do
    {:ok, contents} = File.read("dat/" <> file)
    contents
  end

  def part1, do: part1("prod", 25, 6)
  def part1("sample1"), do: part1("sample1", 3, 2)
  def part1("sample2"), do: part1("sample1", 2, 2)
  def part1(file, wide, tall) do
    layer_size = wide * tall
    dat = input(file) |> String.trim() |> String.codepoints|> Enum.chunk_every(layer_size) |> Enum.map(&Enum.join/1)
    zeros = dat |> Enum.map(fn layer -> layer |> String.codepoints |> Enum.count(fn c -> c == "0" end) end)
    working = Enum.at(dat, Enum.find_index(zeros, fn cnt -> cnt == zeros |> Enum.min end))
    ones = working |> String.codepoints |> Enum.count(fn c -> c == "1" end)
    twos = working |> String.codepoints |> Enum.count(fn c -> c == "2" end)
    ones * twos
  end

  def part2, do: part2("prod", 25, 6)
  def part2("sample1"), do: part2("sample1", 3, 2)
  def part2("sample2"), do: part2("sample2", 2, 2)
  def part2(file, wide, tall) do
    layer_size = wide * tall
    dat = input(file) |> String.trim() |> String.codepoints|> Enum.chunk_every(layer_size) |> Enum.map(&Enum.join/1)
    canvas = Enum.map(Range.new(0, layer_size - 1), fn _ -> "2" end)
    dat = Enum.reduce(dat, canvas, fn layer, acc ->
      update_canvas(layer, acc)
    end)
    render(dat, wide)
  end

  def update_canvas(layer, canvas) do
    layer = layer |> String.codepoints
    canvas |> Enum.with_index |> Enum.map(fn val_idx ->
      {val, idx} = val_idx
      if val == "2", do: Enum.at(layer, idx), else: val
    end)
  end

  def render(img, wide) do
    img = img
    |> Enum.chunk_every(wide)
    |> Enum.map(&Enum.join/1)
    |> Enum.join("\n")
    |> String.replace("0", ".")
    |> String.replace("1", "█")
    |> String.replace("2", " ")
    img |> IO.puts
    img
  end
end
