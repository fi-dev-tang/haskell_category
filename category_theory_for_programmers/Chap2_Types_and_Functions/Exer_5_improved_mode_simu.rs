// 模仿实现, 发现 Vec<> 的更强功能，使用函数指针 Vec<fn(bool) -> bool>
fn always_true(_: bool) -> bool {true}
fn always_false(_:bool) -> bool {false}
fn same_value(x: bool) -> bool {x}
fn not(x:bool) -> bool {!x}

fn main(){
    let function_pointer: Vec<fn(bool) -> bool> = vec![always_true, always_false, same_value, not];
    let input_array = [true, false];

    for f in &function_pointer {
        for &input in &input_array {
            println!("f({}) = {}", input, f(input));    // 解引用之后(&input) 可以直接使用 input
        }                                               // 能够解引用，并且将解引用后的值 bool 绑定到 input 变量上
        println!("========================");
    }
}