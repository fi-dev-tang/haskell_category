// 不考虑 bottom 的 undefined(Haskell) 情况，从 bool 到 bool 应该有 4 种
fn bool_function_1(input_para: bool) -> bool {
    match input_para {
        true => true,
        false => true,
    }
}

fn bool_function_2(input_para: bool) -> bool {
    match input_para {
        true => true,
        false => false,
    }
}

fn bool_function_3(input_para: bool) -> bool {
    match input_para {
        true => false,
        false => true,
    }
}

fn bool_function_4(input_para: bool) -> bool {
    match input_para {
        true => false,
        false => false,
    }
}

fn display_all_results(
    f: impl Fn(bool) -> bool,
) 
{
    println!("The result of true is: {} and The result of false is: {}", f(true), f(false));
}

fn main(){
    println!("enumerate all results.");
    display_all_results(bool_function_1);
    display_all_results(bool_function_2);
    display_all_results(bool_function_3);
    display_all_results(bool_function_4);
}