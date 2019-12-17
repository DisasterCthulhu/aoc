defmodule Day14 do
  @moduledoc """
  Documentation for Day14: Space Stoichiometry
  """
  def input(file) do
    {:ok, contents} = File.read("dat/" <> file)
    contents |> String.trim() |> parse()
  end

  def parse_line(line) do
    [input, [cnt, what]] =
      line |> String.split(" => ") |> Enum.map(fn s -> String.split(s, ~r{(, | )}) end)

    {{what, String.to_integer(cnt)},
     input
     |> Enum.chunk_every(2)
     |> Enum.map(fn [cnt, what] -> {what, String.to_integer(cnt)} end)}
  end

  def parse(file) do
    file
    |> String.split("\n")
    |> Enum.map(fn line ->
      parse_line(line)
    end)
    |> Enum.into(%{})
  end

  def process_reaction(_reactions, {"ORE", amt}, _required), do: {"ORE", amt}

  def process_reaction(reactions, key, required) do
    {what, cnt} = key
    ratio = ceil(required / cnt)

    reactions[{what, cnt}]
    |> Enum.map(fn {what, cnt} -> {what, cnt * ratio} end)
    |> Enum.into(%{})
  end

  def find_reaction(reactions, output, required) do
    if output == "ORE" do
      [{"ORE", required}]
    else
      reactions |> Map.keys() |> Enum.filter(fn {what, _cnt} -> what == output end)
    end
  end

  def reduce_needed_by_excess(excess, needed) do
    Enum.reduce(excess, needed, fn {k, v}, acc ->
      cond do
        k == "ORE" -> acc
        v < 0 -> Map.put(acc, k, Map.get(acc, k, 0) - v)
        true -> acc
      end
    end)
  end

  def filter_negative_excess(excess) do
    Enum.reduce(excess, %{}, fn {k, v}, acc ->
      cond do
        k == "ORE" -> Map.put(acc, k, v)
        v > 0 -> Map.put(acc, k, v)
        true -> acc
      end
    end)
  end

  def find_materials(reactions, needed) do
    excess = %{}

    Stream.cycle(0..0)
    |> Enum.reduce_while({needed, excess}, fn _, {needed, excess} ->
      want = needed |> Map.keys() |> hd
      use = needed[want]
      [key] = find_reaction(reactions, want, use)
      {what, cnt} = key
      ratio = ceil((use - Map.get(excess, want, 0)) / cnt)
      required = ratio * cnt
      inputs = process_reaction(reactions, key, required)
      excess = Map.put(excess, what, Map.get(excess, what, 0) + required - use)

      excess =
        Enum.reduce(inputs, excess, fn {what, amt}, acc ->
          Map.put(acc, what, Map.get(acc, what, 0) - amt)
        end)

      needed = Map.delete(needed, what)

      needed = reduce_needed_by_excess(excess, needed)

      excess = filter_negative_excess(excess)

      if map_size(needed) > 0 do
        {:cont, {needed, excess}}
      else
        {:halt, {needed, excess}}
      end
    end)
  end

  def part1, do: part1("prod")

  def part1(file) do
    reactions = input(file)
    {_needed, excess} = find_materials(reactions, %{"FUEL" => 1})
    -excess["ORE"]
  end

  def stepping(ore, target, up, fuel, step) do
    cond do
      !up && ore <= target && step == 1 -> {:halt, {false, fuel, step}}
      up && ore <= target -> {:cont, {true, fuel * 10, fuel}}
      ore > target -> {:cont, {false, fuel - step, step}}
      !up && ore < target -> {:cont, {false, fuel + step, (step / 10) |> floor}}
    end
  end

  def part2, do: part2("prod")
  def part2(file), do: part2(file, 1_000_000_000_000)

  def part2(file, amt) do
    reactions = input(file)

    Stream.cycle(0..0)
    |> Enum.reduce_while({true, 10, 1}, fn _, {up, fuel, step} ->
      {_needed, excess} = find_materials(reactions, %{"FUEL" => fuel})
      stepping(-Map.get(excess, "ORE", 0), amt, up, fuel, step)
    end)
    |> elem(1)
    |> floor()
  end
end
