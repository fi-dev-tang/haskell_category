{-
写在最前: 在 Haskell 中实现 quicksort 是一个非常 elegant 的例子，quicksort被用来展示 Haskell 的优雅之处

The main algorithm:
a sorted list is a list that has all the values smaller than(or equal to) the head of the list in front
(and those values are sorted), 
then comes the head of the list in the middle and then come all the values that are bigger than the head(they're also sorted).
算法逻辑：
一个已经排序的列表是这样的一个列表:
其中所有比列表头部值小（或等于）的值都在前面（并且这些值是已排序的)，
接着是列表的头部值位于中间，
然后是所有比头部值大的值（这些值也是已排序的）

Haskell实现过滤: list 中所有比 head 小的元素， list 中所有比 head 大的元素 => List comprehension
-}
{-
[Example 1]. 自己实现 QuickSort
-}
myQuickSort:: (Ord a) => [a] -> [a]
myQuickSort [] = []
myQuickSort (x: xs) = left_sorting_list ++ [x] ++ right_sorting_list
    where left_sorting_list = myQuickSort ([v | v <- xs, v <= x])
          right_sorting_list = myQuickSort([v | v <- xs , v > x])
{-
[Example 1]. 官方实现的 QuickSort
-}
quickSort :: (Ord a) => [a] -> [a]
quickSort [] = []
quickSort (x: xs) = 
    let smallerSorted = quickSort [a | a <- xs, a <= x]
        biggerSorted = quickSort [a | a <- xs, a > x]
    in smallerSorted ++ [x] ++ biggerSorted

{-
recursive 的trick
1. 边界条件是否 apply, 比如 empty list, adding 0, multiply 1
2. break apart the parameters of the function
把参数改小，之后看在参数的哪一部分可以使用 recursive call
-}