/*
一种更加标准的实现方式，使用rust 满足下面的三个要求:
1. 恒等函数
2. 复合函数，接收两个函数，并返回一个函数，其中这个函数是它们的复合
3. 测试复合函数满足恒等性质
*/
fn identity<T>(x: T) -> T {
    x
}

// move 关键字: 确保所捕获的变量被移动到闭包内部，而不是借用它们
fn compose<A, B, C> (
    f: impl Fn(B) -> C,
    g: impl Fn(A) -> B,
) -> impl Fn(A) -> C {
    move |x| f(g(x))
}

// 测试例子
fn add_one(x: i32) -> i32 {
    x + 1
}

fn multiply_by_two(x: i32) -> i32 {
    x * 2
}

fn main(){
    let value = 5;

    let id = identity(value);
    println!("Identity of {}: {}", value, id);

    let add_one_then_id = compose(identity, add_one);
    let result1 = add_one_then_id(value);
    println!("Add one then identity of {}: {}", value, result1);

    let id_then_add_one = compose(add_one, identity);
    let result2 = id_then_add_one(value);
    println!("Identity then add one of {}: {}", value, result2);

    assert_eq!(result1, add_one(value));
    assert_eq!(result2, add_one(value));

    println!("All tests passed!");
}

/*
4. World-wide-web: 不一定能，缺少唯一的身份态射，链接不一定能组合，A 网站没有直接的链接到 C
5. 不是
6. 
a. 每个节点都有一个身份态射(自环)，图中的每个顶点都存在从该顶点到自身的边
b. 边满足结合律， A -> B, B -> C, 有 A -> C
*/