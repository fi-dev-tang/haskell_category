{-
patterns are a way of making sure a value conforms to some form and deconstructing it,
guards are a way of testing whether some property of a value(or several of them) are true or false.
guards 类似于在 pattern match 上进行条件判断
-}

{-
[example 1]. bmi tell
1. guards are indicated by pipes that follow a function's name and its parameters.
guards 通过在函数和参数之后加 | , 作为管道进行条件过滤
-}
bmiTell1 :: (RealFloat a) => a -> String
bmiTell1 bmi
    | bmi <= 18.0 = "You're underweight!"
    | bmi <= 25.0 = "You're normal!"
    | bmi <= 30.0 = "You're overweight!"
    | otherwise = "You're a whale!"

{-
the last guard is otherwise. otherwise = True
patterns check if the input satisfies a pattern but guards check for boolean conditions.
If all the guards of a function evaluate to False(and we haven't provided an otherwise catch-all guard),
evaluation falls through to the next pattern.
That's how patterns and guards play nicely together.
-}

{-
[example 2]. modify the function, so that it takes a height and weight and calculates it for us.
Attention: there is no = right after the function name and its parameters
-}
bmiTell2 :: (RealFloat a) => a -> a -> String
bmiTell2 weight height
    | weight / height ^ 2 <= 18.5 = "You're underweight!"
    | weight / height ^ 2 <= 24.5 = "You're normal!"    
    | weight / height ^ 2 <= 30.5 = "You're fat!"
    | otherwise = "You're a whale!"

{-
[example 3]. Your own max function
-}
max' :: (Ord a) => a -> a -> a
max' a b 
    | a >= b = a 
    | otherwise = b

{-
[example 4]. Implement our own compare using guards
we can define function using backticks.Sometimes it's easier to read that way.
-}
compare' :: (Ord a) => a -> a -> Ordering 
a `compare'` b 
    | a > b = GT
    | a == b = EQ
    | a < b = LT