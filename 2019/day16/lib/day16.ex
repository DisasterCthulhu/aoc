defmodule Day16 do
  @moduledoc """
  Documentation for Day16.
  """

  def input(file) do
    {:ok, contents} = File.read("dat/" <> file)
    contents |> String.trim() |> String.codepoints() |> Enum.map(&String.to_integer/1)
  end

  def part1(file, phases) do
    signal = input(file)

    1..phases
    |> Enum.reduce(signal, fn _, signal ->
      process_phase(signal)
    end)
    |> signal_to_string
  end

  def part2(file, phases) do
    signal = input(file)
    offset = signal |> signal_to_string |> String.slice(0, 7) |> String.to_integer()

    signal =
      Stream.cycle(signal)
      |> Stream.drop(offset)
      |> Enum.take(length(signal) * 10_000 - offset)

    1..phases
    |> Enum.reduce(signal, fn _, signal ->
      process_partial_sum(signal)
    end)
    |> signal_to_string
  end

  def process_partial_sum(signal) do
    [0 | signal]
    |> Stream.scan(Enum.sum(signal), fn sig, acc ->
      acc - sig
    end)
    |> Stream.map(&abs/1)
    |> Enum.map(&rem(&1, 10))
  end

  def signal_to_string(signal) do
    signal |> Enum.map(&Integer.to_string(&1, 10)) |> List.to_string()
  end

  def process_phase(signal) do
    offset_signal = [0 | signal]

    signal
    |> Stream.with_index()
    |> Enum.map(fn {_sig, round} ->
      round = round + 1

      offset_signal
      |> Stream.chunk_every(round)
      |> Stream.drop_every(2)
      |> Stream.with_index()
      |> Stream.map(fn {chunk, j} ->
        process(chunk, rem(j, 2))
      end)
      |> Enum.sum()
      |> abs
      |> rem(10)
    end)
  end

  def process(chunk, 1) do
    -Enum.sum(chunk)
  end

  def process(chunk, 0) do
    Enum.sum(chunk)
  end
end
