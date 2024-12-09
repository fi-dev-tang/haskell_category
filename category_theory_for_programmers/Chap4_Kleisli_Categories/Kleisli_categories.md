# Chapter 4. Kleisli categories
# 要点
这种通过修饰一组函数的返回类型来附加额外功能的想法证明是非常有效的。
将保持类型作为对象不变，但重新定义我们的态射为这些被修饰的函数。

# 4.1 Writer Category
Writer 范畴: 对象还是 Types 类型，态射是修饰返回值的，额外带有附加信息的函数。

## 定义一个复合的例子: isEven = negate ● isOdd
```c++
pair<bool,string> isEven(int n){
    return make_pair(n % 2 == 0, "isEven ");
}

pair<bool, string> negate(bool b){
    return make_pair(!b, "Not so! ");
}

pair<bool, string> isOdd(int n){
    pair<bool, string> p1 = isEven(n);
    pair<bool, string> p2 = negate(p1.first);
    return make_pair(p2.first, p1.second + p2.second);
}
```
在这种范畴的定义下：（由于输入/输出并不完全匹配 ）复合形如:
1. 执行与第一个态射相对应的修饰函数 p1 = f1(x)
2. 提取结果对的第一个部分，传递到与第二个态射相对应的修饰函数  p2 = f2(p1.first)
3. 拼接第一个结果的第二个部分和第二个结果的第二个部分    make_pair <p2.first, p1.second + p2.second>
4. 返回一个新的 pair

## 定义复合模板
模板由三个类型参数化，这三个类型对应于我们范畴中的三个对象
```c++
template<class A, class B, class C>
// 认为这里定义的函数接收参数 A, 返回值类型是 Writer<C> 或者说实际上是 Writer<C, std::string>

function<Writer<C>(A)> compose(function<Writer<B>(A)> m1, function<Writer<C>(B)> m2){
    return [m1, m2](A x) {
        auto p1 = m1(x);
        auto p2 = m2(p1.first);
        return make_pair(p2.first, p1.second + p2.second);
    }
}
```
按照上述复合，直接将 toUpper 和 toWords 进行复合
```c++
Writer<vector<string>> process(string s){
    return compose<string, string, vector<string>>(toUpper, toWords)(s);
}
```

如果使用 C++ 14 特性，可以自动推导函数的类型和返回值
```c++
auto const compose = [](auto m1, auto m2){
    return [m1, m2](auto x){
        auto p1 = m1(x);
        auto p2 = m2(p1.first);
        return make_pair(p2.first, p1.second + p2.second);
    };
};
// 新定义的写法
Writer<vector<string>> process(string s){
    return compose(toUpper, toWords)(s);
}
```

## 定义 Writer 范畴中的 identity
这种范畴中的 identity 定义成从 type A 到 type A 的态射，同时满足修饰函数的形式。
```c++
Writer<A> identity(A);

template<class A> Writer<A> identity(A x){
    return make_pair(x, "");
}
```
这一构造可以推广到任意的 monoid，而不只是 string monoid。
我们可以在 compose 中使用 mappend 代替 +，在 identity 中使用 mempty 代替 "", 
logging 库的写法更加general，唯一的限制是要求 log 具有 monoidal 性质。

# 4.2 Haskell 中的 Writer
Haskell 中定义 Writer 成为一个类型别名。
态射是从任意类型 a 到某个 Writer 类型的映射
映射的复合使用 fish operator(>=>)
```haskell
type Writer a = (a, string)
-- 态射: a -> Writer b

-- 类型的复合: fish operator
-- 对类型的定义使用 lambda 表达式
(>=>) :: (a -> Writer b) -> (b -> Writer c) -> (a -> Writer c)
m1 >=> m2 = \x ->
            let (y, s1) = m1 x
                (z, s2) = m2 y
            in (z, s1 ++ s2)
```
结果是一个接受一个参数 x 的 lambda 函数。Haskell 中的 lambda 函数是一种创建匿名函数的方式，即没有具体名称的函数。
反斜杠 \ 用来表示 lambda，后面跟参数列表和箭头 -> 再后面是函数体

C++里的 accessor(访问器)是类成员函数 getter, setter 等。提供了一种控制对象内部状态的访问方式，有助于实现封装这一原则。
Haskell 由于纯函数特性，通常不会直接使用类似C++中的 getter 和 setter 来访问或修改数据结构的字段。
Haskell 更多依赖于不可变的数据结构和模式匹配来结构数据，对于可变状态，Haskell提供了诸如 State Monad 的抽象来处理状态变化。

```haskell
-- 范畴中的 identity
return :: a -> Writer a
return x = (x, "")

-- 下面实现之前提到的 toUpper 和 toWords
upCase :: String -> Writer String
upCase s = (map toUpper s, "upCase ")

toWords :: String -> Writer [String]
toWords s = (words s, "toWords ")

-- 最后复合
process :: String -> Writer [String]
process = upCase >=> toWords
```

# 4.3 Kleisli 范畴
这是一个 Kleisli 范畴，是基于 Monad 的范畴。
一个 Kleisli 范畴的对象是底层编程语言的类型，从类型 A 到类型 B 的态射是那些从 A 到通过某种装饰(embellishment) 从 B 派生出的类型的函数。
每个 Kleisli 范畴定义了自己组合这些态射的方式，以及相对于这种组合的 identity 态射。
不精确的术语 embellishment 对应于范畴中的一个概念 ———— 内函子(endofunctor)。

Writer Monad 是一个更通用机制的例子，该机制可以在纯计算中嵌入 effect。
之前看到用集合范畴建模编程语言的类型和函数。这里将模型扩展到了一个稍微不同的范畴。
一个态射由装饰后的函数表示，它们的组合不仅是将一个函数的输出传递给另一个函数的输入，而是多了一个可以操作的自由度，组合本身。
composition 带来的自由度是使得指称语义成为可能的自由度。