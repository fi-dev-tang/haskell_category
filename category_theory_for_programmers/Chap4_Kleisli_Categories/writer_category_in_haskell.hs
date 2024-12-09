{-
Haskell 中实现 Writer 要比 cpp 中更加简洁：
下面将完成: 1. Writer 的 类型别名，2. Writer 涉及到的复合运算声明和定义
           3. Writer 涉及到的 identity 4. 一个具体的复合例子，参照 cpp 版本的 toUpper 和 toWords
-}
import Data.Char(toUpper)
type Writer a = (a, String)

-- fish operator(compose)
(>=>) :: (a -> Writer b) -> (b -> Writer c) -> (a -> Writer c)
m1 >=> m2 = \x -> 
            let (y, s1) = m1 x 
                (z, s2) = m2 y 
            in (z, s1 ++ s2)

-- identity
return :: a -> Writer a 
return x = (x, "")

upCase :: String -> Writer String
upCase s = (map toUpper s, "Upcase ")

toWords :: String -> Writer[String]
toWords s = (words s, "toWords[String] ")

process :: String -> Writer[String]
process = upCase >=> toWords