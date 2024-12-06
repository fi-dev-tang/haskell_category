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