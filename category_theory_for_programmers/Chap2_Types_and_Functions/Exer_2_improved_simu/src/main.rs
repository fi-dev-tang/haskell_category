// 使用 rand::random::<u32>() 的闭包来构造 记忆化随机数，无参部分用单元类型表示
use std::rc::Rc;
use std::cell::RefCell;
use std::collections::HashMap;
use std::hash::Hash;

fn memoize<A, B>(
    f: impl Fn(A) -> B + 'static,
) -> impl Fn(A) -> B
where A: Eq + Hash + Clone + 'static,
      B: Clone + 'static,
{
    let cache = Rc::new(RefCell::new(HashMap::<A, B>::new()));

    move |x: A| {
        let mut cache = cache.borrow_mut();
        if let Some(result) = cache.get(&x) {
            return result.clone();
        }

        let result = f(x.clone());
        cache.insert(x, result.clone());
        return result;
    }
}

fn main(){
    let random_func = |()| rand::random::<u32>();
    let memoize_random_func = memoize(random_func);

    println!("memoize_random_func: {}", memoize_random_func(()));
    println!("memoize_random_func: {}", memoize_random_func(()));
}   