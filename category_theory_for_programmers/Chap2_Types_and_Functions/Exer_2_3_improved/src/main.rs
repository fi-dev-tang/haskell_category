/*
观察一种 standard 的实现方式，其中的 rand 是通过闭包来定义的
let random_number = || rand::random::<u32>();
|| 表示闭包没有参数
rand::random::<u32>()
闭包体内的表达式，调用了 rand crate 中的 random 函数，指定了返回类型为 u32。

2. “记忆化” 能够实现记忆 random 函数
回答: 对于这种使用 rand::random 这样的随机数生成器或其他有副作用的函数，记忆化是无意义的。
尝试记忆化这样的函数会导致每次调用都返回相同的“随机”值，因为缓存阻止了函数的重复调用。
和我自己实现的写法类似，使用一个实际没有被调用的 _value 和使用单元类型 `()` 作为无参函数的输入
[一个比较好的 trick]: 针对要求 f: impl Fn(A) -> B 类型的函数而言，
如果函数没有实际的参数，可以传入 ()

3. 对比 2:
直接对 rand::random() 进行记忆化不是有效的，因为它是非确定性的，每次调用应返回不同结果，但记忆化后返回相同结果，因为输入始终相同
使用种子的随机数生长器: 函数 `seeded_random_number` 使用种子生成随机数，记忆化后对于相同的种子返回相同的结果，
对于不同的种子可以返回不同的结果。这种情况下，记忆化是有效的
*/
use std::collections::HashMap;
use std::hash::Hash;
use std::cell::RefCell;
use std::rc::Rc;

fn memoize<A, B>(
    f: impl Fn(A) -> B + 'static,
) -> impl Fn(A) -> B 
where A: Eq + Hash + Clone + 'static,
      B: Clone + 'static,
{
    let cache = Rc::new(RefCell::new(HashMap::<A,B>::new()));
    move |x : A| {
        let mut cache = cache.borrow_mut();
        if let Some(result) = cache.get(&x) {
            return result.clone();
        }
        let result = f(x.clone());
        cache.insert(x, result.clone());
        result
    }
}

fn seed_random_number(seed: u64) -> u32 {
    use rand::{SeedableRng, Rng};
    use rand::rngs::StdRng;

    let mut rng = StdRng::seed_from_u64(seed);
    rng.gen()
}

fn main(){
    let random_number = |()| rand::random::<u32>();
    let memoize_random_number = memoize(random_number);

    println!("random: {}", memoize_random_number(()));  // 用 () 作为无参数函数的输入
    println!("random: {}", memoize_random_number(()));

    let memoize_seed_random_number = memoize(seed_random_number);

    println!("random: {}", memoize_seed_random_number(42));  
    println!("random: {}", memoize_seed_random_number(42));
}