-- 第一部分: 自定义一个 monoid, 满足运算的结合律和单位元
{- 
class Monoid m where 
    mempty :: m
    mappend :: m -> m -> m

instance Monoid String where 
    mempty = ""
    mappend = (++)
-}
import Data.Monoid

main::IO()
main = do 
    let str1 = "Hello"
    let str2 = "World"
    print (str1 `mappend` str2)
    print (mempty::String)