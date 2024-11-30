/*
1. 用最喜欢的语言实现恒等函数
*/
fn identity<T>(x: T) -> T {
    x
}

/*
2. 实现函数的复合，使用两个函数作为参数，并返回它们的复合
[似乎 rust 没法直接把函数当成参数]?
这里随便写两个函数，然后写一个 g_after_f

3. 测试复合函数满足恒等条件
*/

// f: 第一个函数，接收一个静态字符，返回一个字符串
fn f(x: &str) -> String{
    x.to_string()
}

// g: 第二个函数，接收一个 String, 返回一个 Vec<String>, 似乎不能直接创建就返回，加生命周期注释 ? (但是这里我没加也过了)
fn g(x: String) -> Vec<String>{
    let mut new_vec = Vec::new();
    new_vec.push(x);
    new_vec
}

// g_after_f: 复合这两个函数
fn g_after_f(x: &str) -> Vec<String>{
    g(f(x))
}

// 测试恒等条件
fn main(){
    // test 1. g_after_f ● id_{&str} == id_{Vec<String>} ● g_after_f
    let str_1 = "hello category";
    let str_2 = "hello category";

    let result_1 = g_after_f(identity(str_1));
    let result_2 = identity(g_after_f(str_2));

    assert_eq!(result_1, result_2);
}

/*
4. world-wide web 是范畴，超链接可以满足态射，结合律，恒等律

5. 认为 facebook 不是一个范畴，因为不满足态射，A 和 B 是好友，B 和 C 是好友，不代表 A 和 C 是好友

6. 有向图是范畴的条件: 每个顶点有指向自己的单位箭头，有向图是完全图，并且方向一致
*/