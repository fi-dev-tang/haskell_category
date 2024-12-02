# haskell_category
记录学习haskell和范畴编程的过程

学习教材 《Category Theory for Programmers》Bartosz Milewski

## 第一阶段
学习 Haskell, 

参考教程: Learn You a Haskell for Great Good!

Haskell 的参考是: https://learnyouahaskell.com/

预估 14 章的内容，花费 2 - 3 周, 记录在 learn_you_a_haskell_for_great_good

chapter 1 √

chapter 2 √

chapter 3 √

chapter 4 √

chapter 5 √

从 chapter 5 (Recursion) 这一节开始逐渐体会到 Haskell 的函数式编程语言和其他命令式编程语言的区别，imperative language 主要告诉一个函数: How you get it, 而 Haskell 主要在定义 what it is.

一个目前遇到很典型的例子，用 recursion(递归)的方式来定义 maximum
```haskell
maximum' :: (Ord a) => [a] -> a
maximum' [] = error "Empty list error!"
maximum' [x] = x
maximum' (x: xs)
    | x > maxTail = x
    | otherwise = maxTail
    where maxTail = maximum' xs
```

更经典的是优雅地实现快排，其中比列表的 head 要大或者小的 list 通过 list comprehension 实现
```haskell
quickSort::(Ord a) => [a] -> [a]
quickSort [] = []
quickSort (x: xs) = 
    let smallerSort = quickSort [a | a <- xs, a < x]
        largerSort  = quickSort [a | a <- xs, a >= x]
    in smallerSort ++ [x] ++ largerSort
```

chapter 6

## 第二阶段

和第一阶段同时进行，计划是看完 31 章的 《Category Theory for Programmers》
对于每一章的内容进行总结和习题解答。

Chapter 1. Category: The Essence of Composition √

Chapter 2. Types and Functions √

Chapter 3. Categories Great and Small