use std::collections::HashMap;  // 提供哈希映射的数据结构，用于存储键值对
use std::hash::Hash;            // trait: 要求类型必须能够被哈希化才能作为 HashMap 的键
use std::sync::{Arc, Mutex};    // 多线程环境下的安全共享和同步访问。Arc 是原子引用计数指针，允许在多个所有者之间共享数据；
                                // Mutex 是互斥锁，确保同一时间只有一个线程可以访问受保护的数据

fn memoize<A,B>(                                // f 是实现 Fn trait 的闭包，接收类型为 A 的参数，返回类型为B 的结果。
    f: impl Fn(A) -> B + 'static + Send + Sync, // 1. 'static: 闭包没有借用任何在其生命周期之外的数据 2. Send 和 Sync 表明闭包可以在不同线程间安全传递和共享
) -> impl Fn(A) -> B + Send + Sync
where
    A: Eq + Hash + Clone + Send + 'static,
    B: Clone + Send + 'static,
{
    let cache = Arc::new(Mutex::new(HashMap::<A, B>::new()));

    move |x : A| {                                      // 闭包动态捕获环境中的变量(cache), 闭包拥有变量的所有权，将闭包传递给其他线程非常重要
        let mut cache_lock = cache.lock().unwrap();     // 尝试获取锁，返回一个可变引用 cache_lock

        if let Some(result) = cache_lock.get(&x) {  
            return result.clone();
        }

        let result = f(x.clone());
        cache_lock.insert(x, result.clone());
        result
    }
}

fn example_f(x: i32) -> i32 {
    x + 1
}

fn main(){
    let initial_value = 1;
    let composed_example_f = memoize(example_f);

    println!("The result of composed_example_f : {}", composed_example_f(initial_value));
}