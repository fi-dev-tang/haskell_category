doubleMe :: Num a => a -> a
doubleMe x = x + x

doubleUs :: Num a => a -> a -> a
doubleUs x y = doubleMe x + doubleMe y

doubleSmallNumber :: (Ord a, Num a) => a -> a
doubleSmallNumber x = if x > 100
                        then x
                        else x * 2

doubleSmallNumber' :: (Ord a, Num a) => a -> a
doubleSmallNumber' x = (if x > 100 then x else x * 2) + 1

conanO'Brien :: [Char]
conanO'Brien = "It's a-me, Canon O'Brien!"

b :: [[Integer]]
b = [[1, 2, 3, 4], [5, 3, 3, 3], [1,2, 2, 3, 4], [1, 2, 3]]

firstTwentyFourOfThirteen :: [Integer]
firstTwentyFourOfThirteen = take 24 [13, 26..]

{-
List comprehension begin
A basic comprehension for a set is : S = { 2 * x | x <= 10, x is Integer}
1. [the output function]: the part before the pipe
2. [the input set]: Integer
3. [predicate]: x <= 10, an expression that returns boolean values

the output function is the set contains the value of input set that satisfy the predicate.
-}

firstTenNaturalNumber :: [Integer]
firstTenNaturalNumber = [x * 2 | x <- [1..10]]