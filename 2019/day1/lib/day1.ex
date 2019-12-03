defmodule Day1 do
  @moduledoc """
  Documentation for Day1.
  """

  def masses do
    {:ok, contents} = File.read("dat/prod")
    contents |> String.trim |> String.split("\n") |> Enum.map(&String.to_integer/1)
  end

  def full_solution do
    Enum.sum(Enum.map(masses(), &recur_fuel/1))
  end

  def naive_solution do
    Enum.sum(Enum.map(masses(), &naive_fuel/1))
  end

  def naive_fuel(mass) do
    div(mass, 3) - 2
  end

  def recur_fuel(mass) do
    fuel_mass = naive_fuel(mass)
    cond do
      fuel_mass <= 0 -> 0
      fuel_mass > 0 -> fuel_mass + recur_fuel(fuel_mass)
    end
  end
end
