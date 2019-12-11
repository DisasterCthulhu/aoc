Benchee.run(%{
  "part1" => fn -> Day10.part1("prod") end,
  "part2" => fn -> Day10.part2("prod", 200) end
} )
