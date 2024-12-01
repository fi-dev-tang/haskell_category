// 定义的 higher_order function, 其中 f 是一个纯函数
// 似乎不太明确应该怎么把这个数存下来
// 这个实现其实没有实现对相同参数调用的一次存储
// 解决方案: 定义一个哈希表，存储访问过的参数和结果
fn memoize<A, B>(
    f: impl Fn(A) -> B,
) -> impl Fn(A) -> B {
    move |x| f(x)
}

fn example_f(x: i32) -> i32 {
    x + 1
}

fn main(){
    let initial_value = 1;
    let composed_example_f = memoize(example_f);

    println!("The result of composed_example_f : {}", composed_example_f(initial_value));
}