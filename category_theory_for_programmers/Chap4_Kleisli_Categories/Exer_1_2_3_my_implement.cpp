/*
【目前为止最像 Rust 的一集】
练习提要:定义了一个模板类 optional,可以处理有值或者没有值的状态
定义了 safe_root 函数
在此基础上: 
Q1. 构造 partial funcion(没有为其参数的所有可能值定义函数) 的 Kleisli 范畴
Q2. 实现装饰后的 safe_reciprocal
Q3. 复合 safe_root 和 safe_reciprocal 构造 sqrt(1/x)
*/
// 以下为原本封装的 optional 题干定义
#include<iostream>
#include<functional>
#include<cmath>
using namespace std;

template<class A> class optional {
    bool _isValid;      // 内部存储的值是否有效
    A _value;           // 内部具体存储的值

public:
    optional() : _isValid(false) {}                 // 公共构造函数，不接受参数，将 _isValid 初始化为 false
    optional(A v) : _isValid(true), _value(v){}     // 公共构造函数，接受一个类型为 A 的参数 v, 表示包含一个有效的值
    bool isValid() const { return _isValid; }       // 常量成员函数，判断返回的值是否有效
    A value() const {return _value; }               // 常量成员函数，需要先调用 isValid()
};

optional<double> safe_root(double x){
    if(x >= 0) return optional<double>{sqrt(x)};        //  C++ 11 引入的大括号初始化语法
    else return optional<double>{};                     
}

// 以下为自己实现的部分
/*
1. 回答第一部分的 Kleisli 范畴，认为这里的
态射: A -> Option<B>
compose: A -> Option<B>, B -> Optional<C>, 复合之后成为 A -> Optional<C>
identity: 调用成员构造函数中的 optional(A v)
*/
template<class A, class B, class C>
function<optional<C>(A)> compose(function<optional<B>(A)> m1, function<optional<C>(B)> m2){
    return [m1,m2](A x) {
        auto result_1 = m1(x);
        if(result_1.isValid() == true){
            auto result_2 = m2(result_1.value());
            if(result_2.isValid() == true){
                return optional<C>{result_2.value()};  // 调用 true 情况
            }else{
                return optional<C>{};       // 调用 false 情况
            }
        }else{
            // 说明在 m1 的过滤下就不是有效的
            return optional<C>{};           // 调用 false情况
        }
    };
}

template<class A>
optional<A> identity(A x){
    return optional<A>{x};
}

/*
2. 回答第二部分: 实现有效的倒数
*/
optional<double> safe_reciprocal(double x){
    if(x == 0) { return optional<double>{};}
    else{
        return optional<double>{1.0/x};
    }
}

/*
3. 回答第三部分，实现复合 safe_root_reciprocal
*/
optional<double> safe_root_reciprocal(double x){
    return compose<double, double, double>(safe_root, safe_reciprocal)(x);
}

template<class A>
void print_optional(optional<A> x){
    std::cout << "\nThis time's compose start " << std::endl;
    if(x.isValid() == false){ 
        std::cout << "Invalid value" << std::endl;
    }else{
        std::cout << "correct: " << x.value() << std::endl;
    }
}

int main(){
    print_optional(safe_root_reciprocal(12.3));
    print_optional(safe_root_reciprocal(0));
    print_optional(safe_root_reciprocal(-8));
    print_optional(safe_root_reciprocal(15.978));
    print_optional(safe_root_reciprocal(23.14));
    print_optional(safe_root_reciprocal(4));
    print_optional(safe_root_reciprocal(16));
}