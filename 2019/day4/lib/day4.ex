defmodule Day4 do
  @moduledoc """
  Advent of Code 2019 - Day 4
  Secure Container
  """

  def input do
    {:ok, val} = File.read("dat/prod")
    apply(Range, :new, String.split(val |> String.trim, "-") |> Enum.map(&String.to_integer/1))
  end

  def part1 do
    input()
    |> Enum.filter(&rule_dupes/1)
    |> Enum.filter(&rule_gte/1)
    |> Enum.count
  end

  def part2 do
    input()
    |> Enum.filter(&rule_pairs/1)
    |> Enum.filter(&rule_gte/1)
    |> Enum.count
  end

  def rule_length do
    6
  end

  # TODO: which one is faster? disjoint is acceptable with the gte rule
  def rule_disjoint_dupes(val) do
    Integer.digits(val)
    |> MapSet.new
    |> MapSet.size < rule_length()
  end

  def rule_dupes(val) do
    {valid, _} = Integer.digits(val)
    |> Enum.reduce({false, -1}, fn val, acc ->
      {valid, carry} = acc
      valid = valid || val == carry
      {valid, val}
    end)
    valid
  end

  def rule_pairs(val) do
    {runs, _, _} = Integer.digits(val)
    |> Stream.with_index
    |> Enum.reduce({[], -1, 0}, fn val_idx, acc ->
      {val, idx} = val_idx
      {runs, prev, cnt} = acc
      runs = if cnt > 0 && prev != val do
        runs ++ [{prev, cnt}]
      else
        runs
      end
      cnt = if prev == val do
        cnt + 1
      else
        1
      end
      runs = if idx == rule_length() - 1 do
        runs ++ [{val, cnt}]
      else
        runs
      end
      {runs, val, cnt}
    end)
    runs |> Enum.reduce(false, fn run, acc ->
      {_val, cnt} = run
      acc || cnt == 2
    end)
  end

  def rule_gte(val) do
    {valid, _high} = Integer.digits(val)
    |> Enum.reduce({true, 0}, fn val, acc ->
      {valid, lhs} = acc
      valid = valid && val >= lhs
      {valid, max(val, lhs)}
    end)
    valid
  end
end
