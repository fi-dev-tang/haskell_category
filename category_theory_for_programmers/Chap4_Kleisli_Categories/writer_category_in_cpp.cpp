/*
定义一个 Writer 范畴：
其中范畴的对象还是 Types, 但是其中的态射是修饰过的函数返回值，这里都是 Writer<A, string> 类型，附加额外信息的函数
需要:
1. 定义修饰后的 Writer 类型函数，附近额外的 String log 信息
2. 定义新范畴中态射的复合, compose 模板
3. 定义新范畴中的恒等映射, identity
*/
#include<utility>
#include<functional>
#include<iostream>
#include<string>
#include<vector>
#include<algorithm>
using namespace std;

template <class A>
using Writer = pair<A, string>;

// 传统的两组函数，第一组: toUpper 和 toWords
Writer<string> toUpper(string s){
    string result;
    int (*toupperp)(int) = &toupper;
    transform(begin(s), end(s), back_inserter(result), toupperp);
    return make_pair(result, "toUpper ");
}

Writer<vector<string>> toWords(string s){
    vector<string> result = {""};
    for(auto i = begin(s); i != end(s); i++){
        if(isspace(*i)){
            result.push_back("");
        }else{
            result.back() += *i;
        }
    }
    return make_pair(result, "toWords ");
}

// 第二组: negate 和 isEven
namespace my_namespace{     // 这里发现 negate 和标准库里某个结构体定义冲突了，新定义自己的一个 namespace
    Writer<bool> negate(bool b){
        return make_pair(!b, "Not so! ");
    }
}

Writer<bool> isEven(int n){
    return make_pair(n % 2 == 0, "isEven ");
}

// 定义 Writer 范畴的第一个运算: compose 复合运算
// 需要加入标准库中的 #include<functional>
template<class A, class B, class C>
function<Writer<C>(A)> compose(function<Writer<B>(A)> m1, function<Writer<C>(B)> m2){
    return [m1 , m2](A x){
        auto p1 = m1(x);
        auto p2 = m2(p1.first);
        return make_pair(p2.first, p1.second + p2.second);      // 这里的 + 使用了 String moniod 中的 mappend (字符串拼接)
    };
}

// 定义 Writer 范畴的第二个运算: identity
template<class A>
Writer<A> identity(A x){
    return make_pair(x, "");                                   // 这里的 "" 使用了 String moniod 中的 mempty("") 
}

// 定义第一组复合: compose(toUpper, towords)
Writer<vector<string>> process(string s){
    return compose<string, string, vector<string>>(toUpper, toWords)(s);
}

// 定义第二组复合: compose(negate, isEven)
Writer<bool> isOdd(int n){
    return compose<int, bool, bool>(isEven, my_namespace::negate)(n); 
}

int main(){
    string s1 = "writer category in cpp";
    for(auto word: process(s1).first) {
        std::cout << word << " ";
    }
    std::cout << std::endl;
    std::cout << process(s1).second << std::endl;

    int number = 13; 
    std::cout << "first part: " << isOdd(number).first << " log info: " << isOdd(number).second << std::endl;

    std::cout << "identity(int) first part: " << identity(s1).first << "\nlog info: " << identity(s1).second << std::endl;
    std::cout << "identity(string) first part: " << identity(number).first << "\nlog info: " << identity(number).second << std::endl;
}