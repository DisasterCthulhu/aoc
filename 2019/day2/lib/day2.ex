defmodule Day2 do
  @moduledoc """
  Documentation for Day2.
  """

  def input do
    {:ok, contents} = File.read("dat/prod")
    parse(contents)
  end

  def parse(str) do
    str |> String.trim |> String.split(",") |> Enum.map(&String.to_integer/1)
  end

  def add(mem, pos) do
    lptr = Enum.at(mem, pos + 1)
    rptr = Enum.at(mem, pos + 2)
    lhs = Enum.at(mem, lptr)
    rhs = Enum.at(mem, rptr)
    sptr = Enum.at(mem, pos + 3)
    List.replace_at(mem, sptr, lhs + rhs)
  end

  def mul(mem, pos) do
    lptr = Enum.at(mem, pos + 1)
    rptr = Enum.at(mem, pos + 2)
    lhs = Enum.at(mem, lptr)
    rhs = Enum.at(mem, rptr)
    sptr = Enum.at(mem, pos + 3)
    List.replace_at(mem, sptr, lhs * rhs)
  end

  def tick(mem, pos) do
    op = Enum.at(mem, pos)
    mem = cond do
      op == 1 -> tick(add(mem, pos), pos + 4)
      op == 2 -> tick(mul(mem, pos), pos + 4)
      true -> mem
    end
    mem
  end

  def prog(mem) do
    mem = tick(mem, 0)
    Enum.join(mem, ",")
  end
end
