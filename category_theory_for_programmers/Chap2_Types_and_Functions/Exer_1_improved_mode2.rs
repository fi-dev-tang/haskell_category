// 关于 1 中问题的单线程解法, 一个官方的单线程写法，其中 RefCell 管理编译时不可变，运行时可变的结构，Rc 表示多个所有者所有权共享，引用计数进行所有权共享管理
use std::collections::HashMap;
use std::hash::Hash;
use std::rc::Rc;         // 管理多个所有者之间的共享所有权
use std::cell::RefCell;  // 内部可变性: 提供编译时不可变，运行时可变的访问

fn memorize<A,B>(
    f: impl Fn(A) -> B + 'static,
) -> impl Fn(A) -> B
where
    A: Eq + Hash + Clone + 'static,
    B: Clone + 'static,
{
    let cache = Rc::new(RefCell::new(HashMap::<A,B>::new()));

    move | arg: A| {
        let mut cache = cache.borrow_mut();
        if let Some(result) = cache.get(&arg){
            return result.clone();
        }
        let result = f(arg.clone());
        cache.insert(arg, result.clone());
        result
    }
}

fn slow_fib(n: u64) -> u64{
    if n == 0 {
        0
    } else if n == 1{
        1
    } else {
        slow_fib(n - 1) + slow_fib(n - 2)
    }
}

fn main(){
    let memorize_fib = memorize(slow_fib);
    println!("FIbonacci(40): {}", memorize_fib(40));
    println!("FIbonacci(40): {}", memorize_fib(40));
}