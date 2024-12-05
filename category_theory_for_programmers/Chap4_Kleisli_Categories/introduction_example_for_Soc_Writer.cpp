/*
最开始引入的例子是:
string logger;
bool negate(bool b){
    logger += "Not so! ";
    return !b;
}
想到一系列取消全局可变变量的写法，一种纯函数的写法如下:
pair<bool, string> negate(bool b, string logger){
    return make_pair(!b, logger + "Not so!");
}
但是这种写法没有分离关注点(Separation of Concern): 实际 "Not so!" 这个字符串信息是特定于函数的，但是将日志聚合起来形成连续的日志信息这个要求，
不是函数的核心关注点
引入新的 Writer 写法，既能够不产生副作用，作为纯函数使用，又可以分离关注点
*/
#include<iostream>
#include<algorithm>
#include<string>
#include<vector>
using namespace std;

vector<string> words(string s){
    vector<string> result = {""};

    for(auto i = begin(s); i != end(s); i++){
        if(isspace(*i)){
            result.push_back("");   // result 新增一个单词，该单词对应的字符串目前为 ""
        }else{
            result.back() += *i;    // result 最末尾的单词对应的字符串新加上 *i, 其中 i 是迭代器类型，*i 表示解引用
        }
    }
    return result;
}

// 正式进入 Writer 部分的定义
template<class A>
using Writer = pair<A, string>;                 // 在原来定义的函数返回值基础上，附加上 string 类型

Writer<string> toUpper(string s){               // 字符串小写转大写
    string result;
    int (*toupperp)(int) = &toupper;
    transform(begin(s), end(s), back_inserter(result), toupperp);  
    return make_pair(result, "toUpper ");
}

Writer<vector<string>> toWords(string s){       // 字符串切分成具有单词的字符串数组
    return make_pair(words(s), "toWords ");
} 

// piggyback 合并上面两个执行动作，先大写字符串，再切分成单词
Writer<vector<string>> process(string s){
    auto p1 = toUpper(s);
    auto p2 = toWords(p1.first);
    return make_pair(p2.first, p1.second + p2.second);
}

int main(){
    string s1 = "category theory for programmers";
    string s2 = "chapter 4. separation of cocern of kleisli category";

    std::cout << "[s1's result]" << std::endl;
    for(const auto& word: process(s1).first){
        std::cout << word << " ";
    }

    std::cout << "\n[s1's logging info]:\n" << process(s1).second << std::endl;

    std::cout << "[s2's result]" << std::endl;
    for(const auto& word: process(s2).first){
        std::cout << word << " ";
    }

    std::cout << "\n[s2's logging info]:\n" << process(s2).second << std::endl;
}