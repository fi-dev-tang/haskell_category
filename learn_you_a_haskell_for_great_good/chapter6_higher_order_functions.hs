{-
正式理解 Higher-order function 的概念，从 Chapter 6 开始进入函数式编程的核心部分。
写在最前:
1. Haskell functions can take functions as parameters and return functions as return values
2. Higher order functions are the Haskell experience
3. If you want to define computations by defining what stuff is instead of defining steps that change some state
and maybe looping them, higher order functions are indispensbale
-}

{-
[Example 1]. usage of curried function
柯里化的一个重要标志就是，我们可以传递给一个函数部分参数，
得到一个部分实现的函数, partial function, 之后可以给这个 partial function 传递新的剩余参数，或者作为新的函数来使用
-}
multThree :: (Num a) => a -> a -> a -> a
multThree x y z = x * y * z

multTwoWithNine:: (Num a) => a -> a -> a
multTwoWithNine = multThree 9

multWithEighteen :: (Num a) => a -> a
multWithEighteen = multTwoWithNine 2

{-
[Example 2]. create new functions : calling functions with too few parameters
这里原本的写法是 compareWithHundred x = compare 100 x
由于 x 都在函数的右侧，所以省略掉 x 的使用 : Notice that the x is on the right hand side on both sides of the equation
-}
compareWithHundred:: (Num a, Ord a) => a -> Ordering
compareWithHundred = compare 100

{-
[Exmaple 3].Infix function
使用中缀函数来进行柯里化和 Partial function, 用括号包围，只在一侧提供参数
-}
dividedByTen:: (Floating a) => a -> a
dividedByTen = (/ 10)

{-
[Example 4].a character supplied to it is an uppercase letter
-}
isUpperAlphanum :: Char -> Bool
isUpperAlphanum = (`elem` ['A'..'Z'])