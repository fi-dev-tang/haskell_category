/*
4. 
(a) 阶乘是 pure 
(b) std::getchar() 不是 pure
(c) 产生了输出，不是 pure
(d) y 是 static, 不是 pure

从程序运行的观测现象来看，确实 memoize 不能达到大部分程序的需求
例如 (b) 无法处理多次从键盘读取字符，(c) 无法每次运行都产生 "Hello World" 的输出
     (d) 无法做到多次相加后达到对 static 变量的累加 
*/
use std::rc::Rc;
use std::cell::RefCell;
use std::hash::Hash;
use std::collections::HashMap;
use std::fmt::Display;

fn memoize<A,B>(
    f: impl Fn(A) -> B + 'static,
) -> impl Fn(A) -> B
where A: Eq + Hash + Clone + 'static,
      B: Clone + 'static + Display,
{
    let cache = Rc::new(RefCell::new(HashMap::<A, B>::new()));

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

// (a) 用例，测试阶乘
// 遇到一个 bug, 30! 对于 u64 类型的整数确实会导致栈溢出
fn a_factorial(n: u64) -> u64 {
    let mut result = 1;

    for i in 2..=n{
        result *= i;
    }
    return result;
}

use std::io;
use std::io::Read;
// (b) 用例，测试类似 c++ 的 std::getchar()
fn b_getchar(_: ()) -> char {
    let mut buffer = [0 ; 1];       // 先建立一个长度为 1 的数组，存储元素为 0

    io::stdin()
    .read_exact(&mut buffer)
    .expect("Getting character failed!");

    let character = buffer[0] as char;
    return character;
}

// (c) 用例，测试一个带有输出打印的程序
fn c_f(_:()) -> bool {
    println!("Hello!");
    return true;
}

// (d) 带有 static int 类型
static mut Y: u64 = 0;
fn d_f(x: u64) -> u64 {
    unsafe {
        Y += x; 
        return Y;
    }
}

// 为了测试我们程序的正确性，每个程序运行 10 次，观测执行效果
fn calculate<A, B>(
    f: impl Fn(A) -> B + 'static,
    x: A,
) 
 where A: Eq + Hash + Clone + 'static,
       B: Clone + 'static + Display,
{
    let memoize_function = memoize(f);

    for i in 1..=10 {
        let result = memoize_function(x.clone());
        println!("The {}th execution, result {}", i, result.clone());
    }
}

fn main(){
    // 测试多次运行是否会产生相同的执行效果
    println!("Test (a): factorial");
    calculate(a_factorial, 20);

    println!("\nTest (b): getchar!");
    calculate(b_getchar, ());

    println!("\nTest (c): bool with output!");
    calculate(c_f, ());

    println!("\nTest (d): static int with value!");
    calculate(d_f, 1);
}

/*
输出结果:
Test (a): factorial
The 1th execution, result 2432902008176640000
The 2th execution, result 2432902008176640000
The 3th execution, result 2432902008176640000
The 4th execution, result 2432902008176640000
The 5th execution, result 2432902008176640000
The 6th execution, result 2432902008176640000
The 7th execution, result 2432902008176640000
The 8th execution, result 2432902008176640000
The 9th execution, result 2432902008176640000
The 10th execution, result 2432902008176640000

Test (b): getchar!
b
The 1th execution, result b
The 2th execution, result b
The 3th execution, result b
The 4th execution, result b
The 5th execution, result b
The 6th execution, result b
The 7th execution, result b
The 8th execution, result b
The 9th execution, result b
The 10th execution, result b

Test (c): bool with output!
Hello!
The 1th execution, result true
The 2th execution, result true
The 3th execution, result true
The 4th execution, result true
The 5th execution, result true
The 6th execution, result true
The 7th execution, result true
The 8th execution, result true
The 9th execution, result true
The 10th execution, result true

Test (d): static int with value!
The 1th execution, result 1
The 2th execution, result 1
The 3th execution, result 1
The 4th execution, result 1
The 5th execution, result 1
The 6th execution, result 1
The 7th execution, result 1
The 8th execution, result 1
The 9th execution, result 1
The 10th execution, result 1
*/