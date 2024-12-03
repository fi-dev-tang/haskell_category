# Chapter 3. Categories Great and Small
# 要点
# 3.1 没有对象的范畴

# 3.2 简单图
free category: 这样的范畴被称为由给定图生成的自由范畴。它是自由构造(free construction)的一个例子，即通过扩展给定的结构并添加最少数量的元素以满足其定律
(在这里是范畴的定律)的过程。

# 3.3 序关系
考虑这样一个范畴，其中的态射是对象之间的关系。

## preorder:
1. 恒等态射
2. 满足复合性，如果 a <= b 且 b <= c, 则 a <= c
3. 复合是结合的
在 preorder 定义的范畴中，循环是被允许的

## partial order:
额外条件: 如果 a <= b 且 b <= a 则 a 必须与 b 相同
循环是不被允许的

## linear order/total order:
任何两个对象都以某种方式相关联

对于排序算法来说，quicksort, bubble sort, merge sort 都必须在 total order 上。
partial order 可以用于拓扑排序

## Hom-set
在范畴 C 中一组从对象 a 到对象 b 的态射被称为 hom-set， 写成 C(a, b)(有时是 HomC(a,b))

# 3.4 Monoid 作为集合
**monoid: 是带有二元运算的集合，其中二元运算满足结合律和单位元**

Haskell 中可以定义这样的 monoid, 需要定义单位元，和其上具体的二元运算
Haskell 本身无法表达 mempty 和 mappend 的 monoidal 性质，mempty 是单位的，mappend 满足结合性

Haskell 的类不像 C++ 的类那样有很强的侵入性，当你新定义一个类型的时候，不需要提前制定它的类。
可以自由地拖延，在稍后声明某个类型是某个类的实例

```haskell
class Monoid m where
    mempty :: m
    mappend :: m -> m -> m

instance Monoid String where
    mempty  = ""
    mappend = (++)

{- 补充一个实现的程序 -}
import Data.Monid
main::IO()
main = do
    let str1 = "Hello"
    let str2 = "World"
    print(str1 `mappend` str2)
    print(mempty::String)
```
与此同时 C++ 的实现方式
```c++
template<class T>
struct mempty;

template<class T>
T mappend(T, T) = delete;
// delete 的用法: C++ 11 新特性，显示禁止生成该函数的任何实例，说明 Monoid 的默认实现被删除，如果不为某个类型提供具体的 mappend 实现，会出现报错

// concept: C++ 20 的概念定义约束，编译时约束，限制模板参数必须满足某些条件
template<class M>
concept Monoid = requires (M m) {
    {mempty<M>::value()} -> std::same_as<M>;
    {mappend(m, m)} -> std::same_as<M>;
}

template<>
struct mempty<std::string>{
    static std::string value() {return "";}
}

template<>
std::string mappend(std::string s1, std::string s2){
    return s1 + s2;
}
```

# 3.5 Monoid 作为范畴(目前为止最抽象的一集)
在范畴论中，我们尝试摆脱集合及其元素，而是讨论对象及其态射。把二元运算符看作是在集合中“移动”或“转移”事物的过程。

monoid 作为只有单一对象的范畴，其态射是加法函数 adder
mappend m -> (m -> m)
把 monoid 中的一个元素映射到作用在这个集合上的函数

```haskell
newtype Adder = Adder {runAdder :: Int -> Int}
import Data.Monoid
instance Monoid Adder where 
mempty = Adder id
mappend (Adder f) (Adder g) = (Adder f g)
```

你或许会问，是否每个范畴论中的 Monoid(即只有一个对象的范畴)都能定义一个唯一的带有二元运算的集合 Monoid。
我们总是可以从一个单一对象的范畴中提取一个集合，这个集合就是对象的态射集 
{Natural number} -> {adder_1, adder_2, ..., adder_n}

提取的过程：
范畴 M 中，我们有单个对象 m 的 Hom-Set_M(m, m)
在这个集合上可以很容易地定义一个二元运算。
两个 Hom-Set_M(m, m) 中的元素，分别对应于态射 f 和 g, 那么它们的乘积将对应于态射 g ● f
存在性是由于它们的源和目的都是同一起点的（同一个对象）。

我们总是可以从一个范畴 monoid 恢复出一个集合 monoid。
Hom-Set 中的元素既可以被看成态射(满足复合条件)，也可以看成集合中的点。M 中的 morphisms 复合可以看成 M(m, m)中的 monoidal 乘积。