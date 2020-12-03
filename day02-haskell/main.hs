import Data.List.Split

main = do
  passwords <- map ((\[low, high, c, s] -> (read low, read high, head c, s)) . filter (not . null) . splitOneOf "-: ") . lines <$> readFile "input.txt"

  putStrLn $ "P1:"
  print . length $ filter part1 passwords
  putStrLn $ "P2:"
  print . length $ filter part2 passwords

countelems c s = length $ filter (== c) s

part1 (low, high, c, s) =
  let n = countelems c s
   in n >= low && n <= high

part2 (low, high, c, s) = ((s !! (low - 1)) == c) /= ((s !! (high - 1)) == c)
