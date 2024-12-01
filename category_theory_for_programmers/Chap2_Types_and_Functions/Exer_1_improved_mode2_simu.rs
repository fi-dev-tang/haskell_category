// 单线程版本，关于给定一个纯函数 f, 存储执行过程中的值，遇到相同调用参数时直接返回
use std::collections::HashMap;
use std::hash::Hash;
use std::rc::Rc;                // Reference count 引用计数
use std::cell::RefCell;

/*
[为什么 A 和 B 必须要实现 Clone Trait]:
关于 Clone 的说明: 在闭包中，x 的所有权会被转移给 f(x), 导致 x 在闭包的作用域里不再有效，
后续的 cache.insert(x, result) 无法编译，因为 x 已经被移动了
*/
fn memoize<A, B>(
    f: impl Fn(A) -> B + 'static,
) -> impl Fn(A) -> B
    where A: Eq + Hash + 'static + Clone + Copy,
          B: 'static + Clone + Copy,

{
    let cache = Rc::new(RefCell::new(HashMap::<A,B>::new()));

    move |x : A| {
        let mut cache = cache.borrow_mut();

        if let Some(result) = cache.get(&x) {
            return result.clone();
        }

        let result = f(x);
        cache.insert(x, result.clone());
        return result;
    }
}

fn slow_fibonnaic(n : u64) -> u64{
    if n == 0 {
        return 0;
    }else if n == 1{
        return 1;
    }else{
        return slow_fibonnaic(n - 1) + slow_fibonnaic(n - 2);
    }
}

fn main(){
    let memoize_slow_fibonnaic = memoize(slow_fibonnaic);

    println!("The result of fibonnaic(45) = {}", memoize_slow_fibonnaic(45));
    println!("The result of fibonnaic(45) = {}", memoize_slow_fibonnaic(45));
}