# Chapter 1. Category: The Essence of Composition
# 要点
# 1.1 把箭头看成函数
范畴的定义: 范畴由对象和它们之间的箭头(态射 morphisms)组成。
可以把态射想象成具体的函数，复合的顺序 g ● f 是从右向左的

在进程间通信(IPC) 管道的例子里，例如首先列举所有打开的文件，再搜索包含 "Chrome"的文本:
```bash
lsof | grep Chrome
```

# 1.2 复合的性质
1. 复合满足结合律
(h ● g) ● f = h ● (g ● f)
2. 复合对单位元恒等

在 C++ 里，恒等函数只是简单地返回其参数，这种实现对每个类型都是相同的，属于多态函数，可以用模板实现
```c++
template<Class T>T id(T x) {return x;}
```

恒等函数的用处：作为高阶函数的参数或者返回值变得非常方便，高阶函数使得函数的符号操作成为可能，是**函数的代数**。

# 1.3 复合是编程的核心
composition 的重要原因：program 的一个核心想法是，将大问题拆分为小问题，写小问题的代码。但如果我们没法将小问题组合起来，将无法解决问题。
(put the pieces back together).

合适的程序的标准：表面积的增长小于体积的增长。