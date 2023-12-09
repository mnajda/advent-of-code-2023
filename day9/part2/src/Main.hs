module Main (main) where

import System.Environment

findNext :: (Eq c, Num c) => [c] -> c
findNext numbers = if all (== 0) numbers
  then 0
  else last numbers + findNext (zipWith (-) (tail numbers) numbers)

main :: IO ()
main = do
    args <- getArgs
    let file = head args
    content <- readFile file

    let numbers = map (map read . words) (lines content)
    let nextValues = map (findNext . reverse) numbers

    let result = sum nextValues
    print result
