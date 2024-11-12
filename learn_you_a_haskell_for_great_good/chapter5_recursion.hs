{-
Recursion is important to Haskell because unlike imperative languages,
you do computations in Haskell by declaring what something is instead of
declaring how you get it.
That's why there are no while loops or for loops in Haskell and instead we many times have to use
recursion to declare what something is.
-}

{-
[Example 1. Maximum]
⭐⭐⭐ (强推这个例子来理解 Haskell 和命令式语句的区别)
之前在命令式语言中编写 Maximum 函数的时候，会设置变量，然后不断 for loop
找到最大的变量，
在 Haskell 中 Maximum 的写法可以通过 recursion 来进行
-}
maximum' :: (Ord a) => [a] -> a
maximum' [] = error "Empty list error!"
maximum' [x] = x
maximum' (x: xs) 
    | x > maxTail = x
    | otherwise = maxTail
    where maxTail = maximum' xs

{-
[Example 1. Follow up]
更简化上面的写法，用 max 替代 where maxTail = maximum' xs
-}
maximum'' :: (Ord a) => [a] -> a
maximum'' [] = error "Empty list error!"
maximum'' [x] = x
maximum'' (x : xs) = max x (maximum'' xs)

{-
[Example 2. Replicate]
given two integers, replicate it many times.
这里使用的是 guard | 而不是 pattern match, 是因为用 boolean condition 做测试 (n <= 0).
-}
replicate' :: (Num i, Ord i) => i -> a -> [a]
replicate' n x 
    | n <= 0 = [] 
    | otherwise = x : replicate' (n - 1) x

{-
[Example 3. Take]
take 3 [5,4,3,2,1] return [5,4,3]
-}
take' :: (Num i, Ord i) => i -> [a] -> [a]
take' n [] = []
take' n [x] = if n >= 1 then [x] else [] {- 这一行也不需要，递归定义已经给出了 -}
take' n (x: xs) 
    | n <= 0 = []
    {- 原来写法出错的部分， n <= 0 = xs
    实际上不应该返回 xs, 而是返回空列表
    -}
    | otherwise = x: take' (n - 1) xs

{-
[Example 3. Take formal]
上面是自己的写法，下面是课程里的官方标准写法
-}
takeF :: (Num i, Ord i) => i -> [a] -> [a]
takeF n _ 
    | n <= 0 = [] 
takeF _ [] = [] 
takeF n (x: xs) = x : takeF (n - 1) xs

{-
[Example 4. reverse]
-}
reverse' :: [a] -> [a]
reverse' [] = []
reverse' (x: xs) = (reverse' xs) ++ [x]

{-
[Example 5. repeat]
repeat 接受一个元素，并返回包含这个元素的无限列表，
在 haskell允许无限列表的情况下，可以定义没有边界条件的递归
-}
repeat' :: a -> [a]
repeat' x = x : repeat' x

{-
[Example 6. zip]
zip [1, 2, 3] [2, 3] -> [(1,2), (2,3)]
zip 方法按照更短一些的列表来进行使用
解释边界条件: zip [1,2,3] ['a','b']
最后得到 zip [3] 和 [], 与边界条件匹配
-}
zip' :: [a] -> [b] -> [(a,b)]
zip' _ [] = [] 
zip' [] _ = []
zip' (x: xs) (y: ys) = (x, y) : zip' xs ys

{-
[Example 7. 'elem']
see some element is contained in list or not.
-}
elem' :: (Eq a) => a -> [a] -> Bool
elem' a [] = False
elem' a (x : xs)
    | a == x = True
    | otherwise = elem' a xs