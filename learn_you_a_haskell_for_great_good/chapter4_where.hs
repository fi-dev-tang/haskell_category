{-
[example 1].
avoid repeat ourselves three times.
Using where function.

We put the keyword where after the guards(usually it's best to indent it as much as the pipes are indented)
and then we define several names or functions.
-}
bmiTell1 :: (RealFloat a) => a -> a -> String
bmiTell1 weight height 
    | bmi <= 18.5 = "You're underweight!"
    | bmi <= 24.5 = "You're superisingly normal!"
    | bmi <= 30.5 = "You're overweight!"
    | otherwise = "You're a whale!"
    where bmi = weight / height^2

{-
[example 2]. Make sure that the variables we defined in where can be visible to guards
-}
bmiTell2 :: (RealFloat a) => a -> a -> String
bmiTell2 weight height
    | bmi <= skinny = "You're underweight!"
    | bmi <= normal = "You're superisingly normal!"
    | bmi <= fatty = "You're fat!"
    | otherwise = "You're a whale!"
    where bmi = weight / height ^ 2
          skinny = 18.5
          normal = 24.5
          fatty = 30.5

{-
[example 3].
Use the where bindings to the pattern match
-}
bmiTell3 :: (RealFloat a) => a -> a -> String
bmiTell3 weight height
        | bmi <= underweight = "You're underweight!"
        | bmi <= normal = "You're supersingly normal!"
        | bmi <= overweight = "You're overweight!"
        | otherwise = "You're a whale!"
        where bmi = weight / height ^ 2
              (underweight, normal, overweight) = (18.5, 24.5, 30.5)

{-
[example 4].
Another example of use where bindings in pattern match --> pattern match use () parensis
-}
initialName :: String -> String -> String
initialName firstname lastname  = "The name is " ++ [f] ++ "." ++ [l]
    where (f: _) = firstname
          (l: _) = lastname

{-
[example 5].
where can also be used to bind functions
Just like we've defined constants in where blocks, you can also define functions.
-}
bmiTell4 :: (RealFloat a) => [(a, a)] -> [a]
bmiTell4 xs = [bmi w h | (w, h) <- xs]
    where bmi weight height = weight / height^2

{-
[Let it be]
[example 6].
Very similar to where bindings are let bindings.
Where bindings are a syntactic construct that let you bind to variables at the end of a function and the whole function can see them,
including all the guards.
Let bindings let you bind to variables anywhere and are expressions themselves, but are very local.
Just like any construct in Haskell that is used to bind values to names, let bindings can be used for pattern matching!

calculate cylinder's surface

1. let <bindings> in <expressions>.
    The names that you define in the let part are accessible to the expression after the in part.
2. let bindings are expressions themselves, where bindings are just syntactic constructs.
-}
cylinder :: (RealFloat a) => a -> a -> a
cylinder r h = 
    let sideArea = 2 * pi * r * h
        topArea = pi * r^ 2
    in sideArea + 2 * topArea

{-
[example 7].
if are expressions.
-}
bindingsIf :: [String]
bindingsIf = [if 5 > 3 then "Boo" else "Woo", if 'a' > 'b' then "Five" else "Six", let a = "Hello" in a ++ " Haskell"]

{-
[example 8].
Let can also be used to introduce functions in a local scope.
-}
localFunction :: (Integral a) => [(a, a, a, a, a)]
localFunction = [ let square x = x * x in (square 1, square 2, square 3, square 4, square 5)  ]

{-
[example 9].
let bind multiple variables, use semicolons ;
-}
multipleLet :: (Integer, String)
multipleLet = ( let a = 100; b = 200; c = 300 in a * b * c, let foo = "Hey "; bar = "there!" in foo ++ bar )

{-
[example 10].
Use let bindings in our list comprehension
You can also put let bindings inside list comprehension. 
use a let inside a list comprehension instead of defining an auxiliary function with a where
-}
bmiTell5 :: (RealFloat a) => [(a, a)] -> [a]
bmiTell5 xs = [ bmi | (w, h) <- xs, let bmi = w / h^ 2]

{-
[example 11].
let bindings in list comprehension
The names definded in a let inside a list comprehension are visible to the output function
(the part before the |) and all predicates and sections that come after of the binding.
So we could make our function return only the BMIs of fat people.
-}
bmiTell6 :: (RealFloat a) => [(a, a)] -> [a]
bmiTell6 xs = [bmi | (w, h) <- xs, let bmi = w / h^2 , bmi >= 25.0]