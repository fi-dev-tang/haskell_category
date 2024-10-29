{-
A typeclass is a sort of [interface] that [defines some behavior].
If a type is a part of a typeclass, that means that is supports and implements the behavior the typeclass describes.
kind of as Java interfaces, only better.

=> symbol: [a class constraint].
(==) :: Eq a => a -> a -> Bool
the equality function takes any two values that are of the same type and returns a Bool.
The type of those two values must be a member of the Eq class(this was the class constraint.)

Another way, we can use explicit type annotations.
Type annotations are a way of explicitly saying what the type of an expression should be.
[adding ::] at the expression and then specifying a type.
-}
value5 :: Int
value5 = read "5" :: Int

{-
minBound :: (Bounded a) => a
In a sense they are polymorphic constants.
-}
minvalueInt :: Int
minvalueInt = minBound :: Int

{-
Num is a numeric typeclass. Its member have the property of being able to act like numbers.
The whole number are polymorphic constants. They act like any type that's a member of the Num typeclass.
:t 20
20 :: (Num t) => t
[psNote]: 这个观点比较新奇，第一次见到在函数里面定义多态常量。举的两个适用场景:
1. 最大值和最小值 minBound 和 maxBound 的类型定义是 minBound :: Bounded a => a 
对应不同类型的 minBound ::Int, minBound :: Char, minBound ::(Bool, Char)
2. 每个数字都可以看成是多态常量，例如 20 :: Num a => a 
20 可以对应看成 Float, Double, Int, Integer, 所以写成 
20 :: Int, 20 :: Double, 20 :: Int, 20 :: Integer 
-}
value20 :: Integer
value20 = 20 :: Integer

value20' :: Float
value20' = 20 :: Float 