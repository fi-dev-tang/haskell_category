# Chapter 4. Kleisli Categories
# 要点
前半部分举的例子非常经典，所以单独作为一个 .md 进行介绍。

## negate 例子的引入
之前将 Types 和纯函数建模成一个 category, 在范畴论中，有一种方法可以建模副作用，或者非纯函数。
这里举一个例子: 记录或跟踪其执行函数 SoC 的例子。

在一般的命令式编程中，log 的写法如下，将会修改一个全局变量:

```c++
string logger;

bool negate(bool b){
    logger += "Not so! ";
    return !b;
}
```
现代编程语言中，尝试避免全局可变状态，因为全局可变状态对并发问题来说非常困难: 竞态条件、死锁、活锁、优先级反转等。

## 第一次尝试：将 negate 写成纯函数
```c++
pair<bool, string> negate(bool b, string logger){
    return make_pair(!b, logger + "Not so! ");
}
```
完整的版本:
```c++
#include<utility>
#include<string>

std::pair<bool, std::string> negate(bool b, const std::string& log){
    std::string updateLog = log + "Not so! ";
    return std::make_pair(!b, updateLog);
}
```

这里确实对于相同的输入，产生了相同的输出。问题在于，memorize 需要存的输入信息过多，同时不利于写成库函数的接口，因为需要用户显式传入一个 字符串 logger。

## 分离关注点
分离关注点：在这个例子里， negate 函数的主要目的是将一个布尔值转换为另一个。日志记录是次要的，尽管所记录的消息是特定于该函数的。
但是将这些消息汇总成一个连续的日志是一个独立的关注点。（Separation of Concern）
仍然希望函数生成一个字符串，但是希望减少它生成日志的负担。

## 转向一个更实际的例子
第一部分是一个字符串大小写转换的程序：
```c++
string toUpper(string s){
    string result;
    int (*toupperp)(int) = &toupper;
    transform(begin(s), end(s), back_inserter(result), toupperp);
    return result;
}
```
> 补充一部分关于实现的内容:
1. int(*toupperp)(int) 是一个函数指针，获取 toupper 标准库中的函数地址，像普通函数一样被调用来转换字符。
这里函数指针的用法被认为是出于历史兼容性。
2. back_inserter: 创建一个 back_inserter_iterator 的迭代器，末尾插入元素

第二部分是一个将字符串拆分成单词的例子，原本的字符串按照空格分隔成动态的字符数组:

```c++
vector<string> toWords(string s){
    return words(s);
}

vector<string> words(string s){
    vector<string> result = {""};

    for(auto i = begin(s); i != end(s); ++i){
        if(isspace(*i)){
            result.push_back("");
        }
        else{
            result.back() += *i;
        }
    }

    return result;
}
```
> 补充一部分关于实现的内容：
1. begin(s) 返回一个迭代器 std::string::iterator 指向字符串 s 的第一个字符。
*i 对迭代器 i 进行解引用操作，返回迭代器指向的元素
2. 关于 result.back() 获取整个 result 中的最后一个单词， result.back() += *i; 将该字符追加到最后一个字符串里。
关于 result.push_back("") 添加一个新的空字符串到 result 末尾。

## 实际例子的迭代修改
对 toUpper 和 toWards 进行修改，在返回常规返回值的基础上附加消息字符串。

## 核心实现部分
将这两个函数组合成另一个修饰的函数，将一个字符串大写并分成单词，同时生成这些动作的日志。

```c++
template<class A>
using Writer = pair<A, string>;

Writer<string> toUpper(string s){
    string result;
    int (*toupperp) (int) = &toupper;
    transform(begin(s), end(s), back_insert(result), toupperp);
    return make_pair(result, "toUpper ");
}

Writer<vector<string>> toWords(string s){
    return make_pair(words(s), "toWords ");
}

// 一个整合过程，直接传递一个字符串，先将其拆分为单词，然后大写，同时在执行过程中记录执行日志
Writer<vector<string>> process(string s){
    auto p1 = toUpper(s);
    auto p2 = toWords(p1.first);
    return make_pair(p2.first, p1.second + p2.second);
}
```
日志的聚合不再是各个函数所关注的问题。它们生成自己的消息，然后从外部连接到一个更大的日志中。
而这种 Writer 的抽象，属于范畴论的问题，其抽象层次不是简单的封装。