/*
尝试自己实现 memoize 函数，接受一个纯函数 f 输入，返回一个函数
行为和 f 类似，但是对于相同的输入参数，只调用原始 f 一次，之后直接返回存储的执行结果
比较好的方式是建立一个哈希表
hashmap, 先查找该值是否存在，然后返回或者插入哈希表

这个问题的场景多出现在多线程执行情况下，使用 sync 对 hashMap 进行同步加锁设置
对多线程而言，闭包可以获取所有权，但是要求生命周期是最长的 'static 周期，否则对于多线程，可能某个线程的执行在创建它们的上下文之外运行
*/
use std::collections::HashMap;      // 存储值用 HashMap
use std::hash::Hash;
use std::sync::{Arc, Mutex};

fn memoize<A, B>(
    f: impl Fn(A) -> B,
) -> impl Fn(A) -> B
where A: Eq + Hash + 'static + Sync + Send + Clone + Copy,
      B: 'static + Sync + Send + Clone
{
    let cache = Arc::new(Mutex::new(HashMap::<A,B>::new()));

    move |x : A | {
        let mut cache_lock = cache.lock().unwrap();     // 锁应该在闭包中捕获，锁的生命周期仅限于闭包的生命周期

        if let Some(result) = cache_lock.get(&x) {
            return result.clone();
        }

        let result = f(x);
        cache_lock.insert(x.clone(), result.clone());
        return result;
    }
}

fn example_f(x: i32) -> i32 {
    x + 1
}

fn main(){
    let memoize_example_f = memoize(example_f);
    let example = 1;
    println!("example result = {}", memoize_example_f(example));
    println!("example result = {}", memoize_example_f(example));
}