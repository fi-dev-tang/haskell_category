removeNonUppercase :: [Char] -> [Char]
removeNonUppercase st = [c | c <- st, c `elem` ['A'..'Z']]

addThree :: Int -> Int -> Int -> Int  
addThree x y z = x + y + z 

factorial :: Integer -> Integer
factorial n = product [1..n]

circumference :: Float -> Float
circumference r = 2 * pi * r 

circumference' :: Double -> Double
circumference' r = 2 * pi * r 

{-
Type variables
head function: takes a list of any type and returns the first element.
head :: [a] -> a
1. Types are written in capital case, so it can't be a type.
2. It is not in capital case, it's actually a type variable. => a can be of any type. Much like generics in other languages.
3. !!! Functions that have type variables are called polymorphic functions. !!!
-}
