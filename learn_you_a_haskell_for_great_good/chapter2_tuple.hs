{-
can't write a general function to append an element to a tuple
-> write a function for appending to a pair, one function for appending to a triple, one function for appending to a 4-tuple. 
-}
someNameAge :: ([Char], [Char], Integer)
someNameAge = ("Christopher", "Walken", 55)

{-
[problem]: combines tuples and list comprehensions:
which right triangle that has integers for all sides 
and all sides equal to or smaller than 10 has a perimeter of 24.
-}
triangle :: [(Integer, Integer, Integer)]
triangle = [(a,b,c)| a <-[1..10], b <-[1..10], c <-[1..10], a + b + c == 24, a + b > c, a + c > b, b + c > a,
     a * a + b * b == c * c || b * b + c * c == a * a || a * a + c * c == b * b]