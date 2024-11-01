{-
the syntax for case expressions:
case expression of pattern -> result
                   pattern -> result
                   pattern -> result
-}

{-
example 1.
different versions of head, the one-up uses case expression.
Not only can we evaluate expressions based on the possible cases of the value of a variable,
we can also do pattern matching.
taking a variable, pattern matching it, evaluating pieces of code based on its value
=> pattern matching on parameters in function definitions!

pattern matching on parameters in function definitions are just syntactic sugar for case expressions.

1. the first one uses pattern matches
2. the second one uses case expression
-}
headV1 :: [a] -> a
headV1 [] = error "This is an empty list!"
headV1 (x: _) = x

headV2 :: [a] -> a
headV2 xs = case xs of [] -> error "This is an empty list!"
                       (x:_) -> x

{-
example 2.
case expression can be used anywhere. They are useful for pattern matching against something in the middle of an expression.
using case expression Vs what bindings to a function
-}
describelistv1 :: [a] -> String                                            
describelistv1 xs = "This is an list" ++ case xs of [] -> " :Empty list!"
                                                    [x] -> " :A single element list!"
                                                    xs -> "  :A longer list!"

describelistv2 :: [a] -> String
describelistv2 xs = "This is an list" ++ what xs
                    where what [] = " :Empty list!"
                          what [x] = ":A single element list!"
                          what xs  = ":A longer list!"