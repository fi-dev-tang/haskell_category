/*
5. 确认执行情况是 4 种
学了一种用 impl Fn(A) -> B  的方式进行枚举，不过打印的时候发现相对来说很笨拙
希望能够提供一种功能，进行函数名称的相对打印

(1) Vec<fn(bool) -> bool> 包含函数指针
(2) 使用 for f in functions, 如果直接遍历 functions, 会将每个函数指针移动出来，意味着 functions 在第一次迭代后为空，元素已经被移走
只是想借用 functions 中的元素，&functions, 在执行完成后还想使用
(3) &input 是将引用传递后的部分解引用
类比
for f in &functions
    for input in &inputs
后面的两个 &functions 和 &inputs 是为了保证数组所有权，在执行之后functions 和 inputs 的内容不会被取出
对于 &input 再加上一个解引用，表示使用的就是 布尔值，不是布尔值的引用

for f in &functions
    for &input in &inputs

[psNote] 最后总结:
for f in &functions: 使用引用传递是为了借用 functions 中的函数指针，而不是将它们移走，从而保持 functions 的完整性
for &input in &inputs: 使用解引用传递，从 inputs 中逐个取出布尔值，并确保传递给函数的是布尔值本身，而不是它的引用。
*/
fn always_false(_: bool) -> bool {
    false
}

fn always_true(_: bool) -> bool {
    true
}

fn identity(x: bool) -> bool {
    x
}

fn not(x: bool) -> bool {
    !x
}

fn main(){
    let functions: Vec<fn(bool) -> bool> = vec![always_false, always_true, identity, not];
    let inputs = [true, false];

    // 使用引用遍历 `functions`, 避免移动函数指针
    for f in &functions {
        // 使用解引用遍历 `inputs`, 获取布尔值本身
        for &input in &inputs {
            println!("f({}) = {}", input, f(input));
        }
        println!("=======================");
    }
}