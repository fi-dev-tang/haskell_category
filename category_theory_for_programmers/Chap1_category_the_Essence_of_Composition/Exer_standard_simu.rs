fn identity<T>(x: T) -> T{
    x
}

fn compose<A, B, C>(
    f: impl Fn(A) -> B,
    g: impl Fn(B) -> C,
) -> impl Fn(A) -> C {
    move |x| g(f(x))
}

fn add_one(x: i32) -> i32{
    x + 1
}

fn main(){
    let value = 5;
    let id_value = identity(value);
    println!("value = {}, id_value = {}", value, id_value);

    let identity_then_add_one = compose(identity, add_one);
    let result1 = identity_then_add_one(value);

    let add_one_then_identity = compose(add_one, identity);
    let result2 = add_one_then_identity(value);

    println!("identity_then_add_one : {}, add_one_then_identity: {}", result1, result2);
    assert_eq!(result1, add_one(value));
    assert_eq!(result2, add_one(value));
    println!("All tests passed!");
}