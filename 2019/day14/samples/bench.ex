Benchee.run(%{
  "part1" => fn -> Day14.part1("prod") end,
  "part2 - 1T" => fn -> Day14.part2("prod", 1_000_000_000_000) end,
  "part2 - 1B" => fn -> Day14.part2("prod", 1_000_000_000) end,
  "part2 - 1M" => fn -> Day14.part2("prod", 1_000_000) end
} )
