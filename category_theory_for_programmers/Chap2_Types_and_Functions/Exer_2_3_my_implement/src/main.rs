/*
按照第二题的要求，创建一个 rust 标准库中用来生成随机数的函数，
使用第一题中的 memoize 来记录这个程序
1. rust 标准库里没有关于 rand 的随机数函数，可以使用 cargo 包管理工具进行 crate 的依赖引入
2. memoize 的写法按照之前的单线程方式创建，Rc(多个所有者可以引用计数，共享变量), RefCell(编译时不可变，运行时可变的声明)
观测这个程序是否会记住随机数生成器之前生成的随机数
*/
use std::hash::Hash;
use std::cell::RefCell;
use std::rc::Rc;
use std::collections::HashMap;
use rand::Rng;
use rand::SeedableRng; // 种子必须是 [u8: 16] 类型的
use rand::rngs::StdRng;

fn memoize<A, B>(
    f: impl Fn(A) -> B + 'static,
) -> impl Fn(A) -> B 
where A: Eq + Hash + Clone + 'static,
      B: Clone + 'static 
{
    let cache = Rc::new(RefCell::new(HashMap::<A,B>::new()));

    move |x : A| {
        let mut cache = cache.borrow_mut();
        if let Some(result) = cache.get(&x) {
            return result.clone();
        }

        let result = f(x.clone());
        cache.insert(x, result.clone());
        return result;
    }
}

/*
[version_1]:
第一次写成这样，但是报错显示: memorize 程序需要接收一个输入
let simple_rand = rand::thread_rng().gen();
let memorize_simple_rand = memoize(simple_rand);

println!("The first time result {}", memorize_simple_rand());
println!("The Second time result {}", memorize_simple_rand());

认为在上面的执行过程中，第 2 题的实现不能完成，因为 HashMap 需要根据输入的参数来记录索引，普通的 rng.gen() 无法传参
第 3 题的实现: 新增一个随机数种子，认为应该没问题
*/

// 2. 回答: 对于普通的没有 seed 的随机数生成，无法 memoize, 诡异的是经过运行发现也可以
fn ex2_wrapped_no_seed_generator(_value: u32) -> u32 {
    let mut simple_rand = rand::thread_rng();
    simple_rand.gen()
}

// 3. 回答: 自定义一个带有种子的随机数生成函数, bug2: 关于 StdRng 实际需要长度为 32 的种子
fn ex3_wrapped_random_generator(seed: [u8; 32]) -> u32 {
    let mut rng : StdRng = SeedableRng::from_seed(seed);
    rng.gen()
}

fn main(){
    // 测试 2 是否可以 memoize
    let memoize_ex2 = memoize(ex2_wrapped_no_seed_generator);
    println!("The first_time calling memoize_ex2 : {}", memoize_ex2(1));
    println!("The Second_time calling memoize_ex2 : {}", memoize_ex2(1));

    // 测试 3 是否可以 memoize
    let seed: [u8 ; 32] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16,
    17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32];
    let memoize_ex3 = memoize(ex3_wrapped_random_generator);
    println!("The first_time calling memoize_ex3 : {}", memoize_ex3(seed));
    println!("The Second_time calling memoize_ex3 : {}", memoize_ex3(seed));
}