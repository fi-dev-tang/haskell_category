{-
定义范畴 a 和 b 的乘积 (product) 和对偶的 (coproduct)
其中范畴的乘积定义为: 
对于任何的乘积 c, 以及对应的投影 (p:: c -> a),(q:: c -> b), 其余的乘积 c'
能够从态射中恢复出 m: c' -> c, c 理解成 (a, b) 也就是 m: c' -> (a, b)

其中范畴的 coproduct 定义为:
对于任何的 coproduct c, 以及对应的 injection (i:: a -> c),(j:: b -> c), 其余的 coproduct c'
能够从态射中恢复出 m: c -> c', c 理解成 (a, b) 也就是 m: (a, b) -> c'
-}
product_factorizer:: (c -> a) -> (c -> b) -> (c -> (a, b))
product_factorizer p q = \x -> (p x, q x)

coproduct_factorizer :: (a -> c) -> (b -> c) -> Either a b -> c
coproduct_factorizer i j (Left a) = i a
coproduct_factorizer i j (Right b) = j b

data Contact = PhoneNum Int | Address String  -- haskell 里面定义的带标签的union, 通过注入函数直接构造得到

help_contacter :: Contact
help_contact = PhoneNum 23333