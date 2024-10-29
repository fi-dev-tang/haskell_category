{-
Pattern matching
非常喜欢的一个语法结构，在 Rust 里面见到了异曲同工的效果
Pattern matching consists of specifying patterns to which some data should conform and then checking to see if it does
and deconstructing the data according to those patterns.

define separate function bodies for different patterns. => neat code that's simple and readable.
-}
lucky :: (Eq a, Num a) => a -> String
lucky 7 = "LUCKY NUMBER SEVEN!"
lucky x = "Sorry, you're out of luck, pal!"

sayMe :: (Integral a) => a -> String
sayMe 1 = "One!"
sayMe 2 = "Two!"
sayMe 3 = "Three!"
sayMe 4 = "Four!"
sayMe 5 = "Five!"
sayMe x = "Not between 1 and 5"

{-
recursively!
saying the factorial of 0 is 1, the factorial of any positive integer is that integer multiplied by the factorial of its predecessor.
order is important when specifying patterns and it's always best to specify the most specific ones first and then the more general ones later.
-}
factorial :: (Integral a) => a -> a
factorial 0 = 1
factorial n = n * factorial(n - 1)

charName :: Char -> String
charName 'a' = "Albert"
charName 'b' = "Broseph"
charName 'c' = "Cecil"
charName  x = "Other"

{-
Pattern matching not used in Vector adding
-}
addVectors :: (Num a) => (a, a) -> (a, a) -> (a, a)
addVectors a b = (fst a + fst b , snd a + snd b)

{- Use pattern matching -}
addVectors' :: (Num a) => (a, a) -> (a, a) -> (a, a)
addVectors' (x1, y1) (x2, y2) = (x1 + x2, y1 + y2)

{- self define triple tuple's get function -}
first :: (a, b, c) -> a
first (x, _, _) = x  

second :: (a, b, c) -> b
second (_, y, _) = y 

third :: (a, b, c) -> c
third (_, _, z) = z  

{-
pattern matching in list comprehension
一个没处理过的例子，在 List comprehension 中进行模式匹配
从包含二元 pair 的 list 里面得到分量 a 和 b, 将二元的 pair 变成单个元素的 list
-}
addResult :: (Num a) => [(a, a)] -> [a]
addResult xs = [ a + b | (a, b) <- xs]

{-
list is the syntactic sugar 
[1: 2: 3] <=> 1: 2: 3: []
A pattern like x:xs will bind the head of the list to x and the rest of it to xs, 
even if there's only one element so xs ends up being an empty list.
这里出错: (x: xs) 括号用于模式匹配
Notice that if you want to bind to several variables(even if one of them is just _ and doesn't bind at all),
we have to surround them in parentheses.
-}
head' :: [a] -> a
head' [] = error "This is an empty list!"
head' (x: _) = x

{-
trivial function that tells us some of the first elements of the list in convenient English form
-}
tell :: Show a => [a] -> String
tell [] = "This is an empty set!"
tell (x:[]) = "This is an one element set " ++ show x
tell (x: y: []) = "This is an two element set " ++ show x ++ " " ++ show y
tell (x: y: z: []) = "This is an three element set " ++ show x ++ " " ++ show y ++ " " ++ show z
tell (x: y: z: _) = "A long string" 

{-
Write our own length function, with pattern matching and a little recursion.
-}
length' :: Num b => [a] -> b
length' [] = 0
length' (_: xs) = 1 + length' xs

sum' :: Num a => [a] -> a
sum' [] = 0
sum' (x: xs) = x + sum xs

{-
There's also a thing called as patterns.
Those are a handy way of breaking something up according to a pattern and binding it to names whilst still keeping a reference
to the whole thing.
putting a name and an @ in front of a pattern.
the pattern xs@(x:y:ys). match exactly the same thing as x:y:ys but you can easily get the whole list via xs instead of repeating yourself by
typing out x:y:ys
-}
capital :: String -> String
capital "" = "This is an empty string"
capital all@(x:_) = "The first letter of " ++ all ++ " is " ++ [x]