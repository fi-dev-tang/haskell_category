listComprehensionDouble :: [Integer]
listComprehensionDouble = [x * 2 | x <- [1..10]]

{-
add a condition(or a predicate) to that comprehension.
Predicates go after the binding parts and are separated from them by a comma.
-}
listComprehensionPredicate :: [Integer]
listComprehensionPredicate = [x * 2 | x <-[1..10], 2 * x >= 12]

listComprehensionRemainder :: [Integer]
listComprehensionRemainder = [x | x <- [50..100], x `mod` 7 == 3]

{-
list-comprehension 
[Q1]: function
replaces each odd number greater than 10 with "BANG!",
each odd number less than 10 with "BOOM"
isn't odd, throw it out of our list
=====================================================================
Ex1: This is how I wrote it buf failed.
bangboomList xs = [
    string | x <- xs,
    if x `mod` 2 == 0 then string =  ""
                      else if x >= 10 then string = "BANG!"
                           else string = "BOOM!"]
I did not know how to represent a value in a predicate.
=====================================================================
standard:
bangboomList xs = [if x > 10 then "BANG!" else "BOOM" | x <- xs, odd x]
-}
bangboomList :: [Integer] -> [[Char]]
bangboomList xs = [if x > 10 then "BANG!" else "BOOM" | x <- xs, odd x]

{- [Q2] all numbers from 10 to 20 that are not 13, 15 or 19-}
filterList :: [Integer]
filterList = [x | x <- [10..20], x /= 13, x/=15, x/= 19]

{-[Q3] product of two lists -}
productList :: [Integer] -> [Integer] -> [Integer]
productList xs ys = [x * y | x <- xs, y <- ys]

{-[Q4] product of two lists'-}
productList' :: [Integer] -> [Integer] -> [Integer]
productList' xs ys = [x * y | x <- xs, y <- ys, x * y > 50]

nouns :: [[Char]]
nouns = ["hobo", "frog", "pope"]
adjectives :: [[Char]]
adjectives = ["lazy", "grouchy", "scheming"]

{-[Q5] combines a list of adjectives and a list of nouns -}
combineList :: [[Char]] -> [[Char]] -> [[Char]]
combineList ns adj = [ adject ++ " " ++ noun | noun <- ns, adject <- adj]

{-[Q6] list comprehension version of length -}
length' :: Num a => [t] -> a
length' xs = sum [1 | _ <- xs]

{-[Q7]: list comprehension on string -}
removeNonUppercase :: String -> String 
removeNonUppercase xs = [x | x <- xs, x `elem` ['A'..'Z']]

{-[Q8]: list comprehension on nested lists -}
nestedLists:: [[Integer]] -> [[Integer]]
nestedLists xxs = [ [ x | x <- xs, even x  ] | xs <- xxs]