# Chapter 5. Products and Coproducts
# 要点
如果我们想在某个范畴中找出一个特定的对象，我们就只能通过描述它与其他对象（及自身）的关系模式来做到这一点，这些关系由态射定义。

common 的 pattern 会导致大量的匹配，对这些匹配进行排序。

# 5.1 初始对象
有序范畴中，存在一个从范畴的一端到另一端的总体箭头流向。

> 初始对象是指在范畴中，到任何一个对象 **有且只有一个态射** 的对象。

这不能保证初始对象的唯一性，但能保证同构下的唯一性。

在集合和函数的范畴中，初始对象是空集。absurd::Void -> a
absurd 中 Void 到其他类型的唯一多态函数，使其成为类型范畴中的初始对象。

# 5.2 终止对象
> 终止对象(the terminal object)**从范畴中的任何对象到它，有且只有一个态射。**

对范畴论中，终止对象是 singleton(单元素集)的理解:
singleton 是单元素集，因此从任何集合到单元素集的态射就只有一个。将该集合的所有元素都映射到那个单元素上：
任何元素被映射到的像只有一个选择: ()

```haskell
unit:: a -> ()
unit _ = ()
```

# 5.3 对偶性
定义初始对象和终止对象之间存在对称性。两者唯一的区别在于态射的方向。
对任何范畴C，我们可以通过反转所有箭头来定义一个相反的范畴 Cop,重新定义组合(composition)。
f: a -> b, g: b -> c 组合成 h: a -> c,  且 h = g ● f
反转后的态射 fop: b -> a, gop: c -> b 将会组合成 hop: c -> a, hop = fop ● gop。

在 opposite category 中的构造通常以 "co" 作为前缀。在相反范畴中终止对象就是初始对象。

# 5.4 同构性(isomorphisms)
直观上说，同构对象看起来是一样的，它们有相同的形状。
同构需要找到两个对象之间一一对应的关系。同构是一种可逆的态射，或者一对态射，其中一个是另一个的逆。

在唯一同构意义下的唯一性：
1. 同构: 在范畴论中，如果存在两个态射 f: A -> B 和 g: B -> A,
使得 g ● f = idA, f ● g = idB, 那么我们说对象 A 和 B 是同构的，并且 f 和 g 互为逆态射。
2. 初始对象: 对范畴论中的其他对象 x, 恰好存在唯一的态射从初始对象到 x。
假设有两个初始对象 i1 和 i2, 从 i1 到 i2 和 i2 到 i1 各有一个唯一态射。

3. 唯一同构: 考虑两个初始对象 i1 和 i2,
i1 到 i2 有一个唯一的态射 f: i1 -> i2
i2 到 i1 有一个唯一的态射 g: i2 -> i1
而 idi1 和 idi2 是 i1 到 i1, i2 到 i2 的唯一态射，所以
g ● f = idi1, f ● g = idi2

4. 同构的唯一性
f是唯一的，g是唯一的
在唯一的同构意义下的唯一性。
前面强调: 初始对象和终端对象分别是有且只有一个态射指向其他对象，有且只有一个态射指向它自己。
这里的 initial object 不仅在同构意义下是唯一的，并且同构映射也是唯一的。

这样的有且只有一个一方面可以和函数定义吻合，Haskell 中的 Void 和 (), 一方面能够验证唯一的同构

# 5.5 Products 乘积
考虑笛卡尔积和组成集合之间的关系。
```haskell
fst::(a, b) -> a
fst (x, y) = x

snd::(a, b) -> b
snd (x, y) = y
```
在 C++ 中的实现:
```c++
template<class A, class B>
A fst(pair<A,B> const &p){
    return p.first;
}
```
在集合范畴中定义一个对象和态射的模式，引导我们构建两个集合 a 和 b 的乘积。
universal construction 的另一个组成部分: 排序。需要能够比较两个候选对象的投影。

```haskell
p::c -> a
q::c -> b
```

看待这些方程的方式是: m 分解了 p' 和 q'，其中点号表示乘法，m 是 p'和 q' 的一个公因数。

![product](/category_theory_for_programmers/Chap5_Products_and_Coproducts/product.png)

正面的推导过程:(Int, Bool) 和 fst,snd 是 Int 与 Bool 的乘积最好的选择。
1. 一方面，Int 与 (Int,Int, Bool) 都能找到这样的态射 m
2. 另一方面，验证其余无法恢复出 fst, snd 或者态射 m 不唯一。

给定任意类型 c 和两个投影 p, q, 存在一个从 c 到笛卡尔积(a,b) 的唯一态射 m, 它能够分解这两个投影。

理解 projection(投影): 投影是指从乘积对象到其组成对象的态射。
> 两个对象 a 和 b 的乘积是对象 c, 它配备了两个投影态射 p 和 q, 使得对于任何其他配备有两个投影态射的对象 c', 
存在一个从 c' 到 c 的唯一态射 m,该态射能够分解或（重构）那些投影态射。

定义范畴中两个对象 a 和 b 的乘积，是一种通用的最佳选择。

```haskell
factorizer::(c -> a) -> (c -> b) -> (c -> (a, b))
factorizer p q = \x -> (p x, q x)
```
由 c 到 (a,b) 的映射 m 构成: factorizer p q = \x -> (p x, q x)
由 p,q 得到 m, 由 p' q' 得到分解它们的函数 m。

# 5.6 Coproduct
> 两个对象 a 和 b 的 coproduct 是对象c, 它配备了两个注入映射，使得对于任何其他配备有两个注入态射的对象 c',
存在一个从 c 到 c' 的唯一态射 m, 能够分解那些注入态射。

Coproduct 在 C++ 中可以认为是带标签的 union。
带标签的联合称为变体(variant)。C++中的 boost::variant 有通用的变体实现。

```c++
struct Contact{
    enum{isPhone, isEmail} tag;
    union{int PhoneNum; char const *emailAddr;};
};

Contact PhoneNum(int n){
    Contact c;
    c.tag = isPhone;
    c.PhoneNum = n;
    return c;
}
```
在 Haskell 中可以使用竖条分隔符分隔数据构造函数，将任何数据类型组合到一个带有标记的联合中。
coproduct 的规范实现是一种名为 Either 的数据类型。从 i' 和 j' 中恢复出 m, 根据 Either 的选择分别作用: (a, b) -> C

```haskell
data Contact = PhoneNum Int | EmailAddr String

helpdesk::Contact;
helpdest = PhoneNum 2222222

Either a b = Left a | Right b

factorizer :: (a -> c) -> (b -> c) -> Either a b -> c
factorizer i j (Left a) = i a
factorizer i j (Right b) = j b
```
