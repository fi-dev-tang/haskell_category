# Chapter 2. Types and Functions
# 要点

# 2.1 谁需要类型?
动态类型语言中，类型不匹配的问题会在运行时被发现，而强类型检查且静态的语言中，类型不匹配会在编译时被发现。

类型检查器(Typechecker)的作用更进一步:
一旦 Romeo 被声明为一个人类，他就不会长出叶子或者用他强大的引力场捕获光子。

# 2.2 类型和复合密切相关
语言的类型系统越强，这种匹配就能被更好地描述和机械地验证。
关于用单元测试来替代强类型的观点，考虑一下在强类型语言中的常见重构实践:
如果想要修改函数的某个特定参数类型，在强类型的语言中，只需要修改该函数的声明，然后修复所有的构建错误即可。
而在弱类型语言中，函数现在期望不同数据这一事实无法传播到调用点，(需要手动添加)，弱类型需要更多的手动改测试。

实际上，单元测试(概率性)并不能完全替代强类型。

### 强类型
Haskell 里面不需要过多的修改

```haskell
add:: Int -> Int -> Int
add x y = x + y

add:: Double -> Double -> Double
add x y = x + y
```

### 弱类型
Python 里面是类型推断，如果直接在调用的时候还是传递原来的 int 类型参数， print(add(1, 2)), 程序实际无法检测出现在需要传入 double / float 类型。
需要在更改程序的时候加入更多的手动限制:

```python
def add(x, y):
    return x + y

def add(x, y):
    if not (isinstance(x, float) and isinstance(y, float)):
        raise TypeError("Arguments must be of type float")
    return x + y
```

# 2.3 什么是类型？
Set 范畴: 对象是集合(type 可以被看成是值的集合)，态射是函数

有些涉及递归的计算可能永远不会终止，我们不能简单地禁止 Haskell 中的非终止函数。区分终止和非终止是不可判定的，
需要通过在每个类型中添加一个特殊的值来扩展类型系统 -> bottom _ | _
对应一个非终止的计算。
bottom 属于任何类型，类型系统扩展之后，通过引入 bottom，Haskell 的类型系统能够处理非终止运算和运行时错误。

```haskell
f :: Bool -> Bool
f x = undefined

g :: a -> b
g x = undefined
```

# 2.4 我们为什么需要一个数学模型?
在指称语义(denotational semantics)中，每个编程构造被赋予了数学解释，有了这种解释，如果你想要证明程序的属性，只需要证明一个定理。

范畴论的作用：之前的指称语义用于处理类似数学上的函数。从键盘上读取字符或者通过网络发送数据包的数学模型很难定义？
似乎指称语义并不适合处理许多编写有用程序所需的重要任务，而这些任务用操作语义(operational semantics)可以更容易地解决。

Eugenio Moggi 发现计算效应可以被映射到 monads。monad 能够让我们只使用纯函数来建模各种 effect, 不会因为限制在数学函数而损失任何东西。

拥有编程的数学模型的优势：进行软件正确性的正式证明。

# 2.5 纯函数和非纯函数
纯函数：对相同的输入产生相同的输出，不产生副作用。
> functions that always produce the same result given the same input and have no side effects are called pure functions.

# 2.6 Types 的例子
+ 没有元素的集合: Haskell 中定义成 Void, Haskell 中理论上存在，但永远无法调用的函数（定义在 Void 之上）
因为 Void(uninhabited) 没有任何值的类型，无法提供一个 Void 类型的值。

```haskell
absurd::Void -> a
```

+ 单元素集合: () 取了一个只有一个实例的虚拟值，所以我们不必明确提到它。

```haskell
f44 :: () -> Integer
f44 () = 44

{- calling -}
f44 ()
```

通过讨论函数(箭头) 来替换显式提及的元素。
从单元类型() 到任意类型 A 的函数与该集合的元素一一对应
```haskell
() -> 44  44 {- f44 -}
() -> 88  88 {- f88 -}
```