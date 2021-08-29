# Rust Learning

## References

[Getting Started](https://www.rust-lang.org/learn/get-started)

[Official learning books](https://www.rust-lang.org/learn)

:dart:[The Rust Programming Language](https://doc.rust-lang.org/book/title-page.html#the-rust-programming-language)

## Installation

Use `rustup` to install rust related stuffs.

`curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | zsh`

Error will occur in MacBook, [change the cl to](https://stackoverflow.com/questions/45899815/could-not-write-to-bash-profile-when-installing-rust-on-macos-sierra):

`curl https://sh.rustup.rs -sSf | zsh -s -- --no-modify-path `

And run:

`source ~/.cargo/env`

## About cargo

Use cargo to build codes and manage packages (carets).

`cargo new hello_rust` will make a new directory with following structer:

```
hello-rust
|- Cargo.toml
|- src
  |- main.rs
```

`Cargo.toml` is just a configure file containing some metada for this project. At the mean time, a git repository will also be created.

`cargo build` will build the project and create an executable file in `target/debug/`directory.

 `cargo.lock` file will also be generated. This file keeps track of the **exact versions of dependencies** in your project. 

`cargo run` command will compile the codes and then run the executable.

`cargo check` compile the codes without generating binary files. It is faster than build command. Use it periodically to check the codes while working on a project.

`cargo build --release` will generate the release version executables.

Work on an existing project:

```
git clone someproject
cd someproject
cargo build
```

## Basics

### Variables

1. In rust variables are **immutable** by default:

   ```rust
   let x = 5;
   // vs
   let mut x = 5;
   ```

2. Immutable is not equal to **constant**:

   1. Constants must be declared with `const` keyword and the type of value must be annotated.

      ```rust
      const MAX_POINTS: u32 = 100_000;
      ```

   2. Constants may be set only to a constant expression, not the result of a function call or any other value that could only be computed at runtime.

3. Variables **shadowing**:

   Can change a type of a variable with a same name. (Reuse variable names)

   ```rust
   let spaces = "   ";
   let spaces = spaces.len();
   ```

### Data types

1. When there are many types are possible for a declared variable, type annotation must be added:

   ```rust
   let guess: u32 = "42".parse().expect("Not a number!");
   ```

2. Scalar types: integers, floating-point numbers, Booleans, and characters.

3. Compound types: tuples and arrays.

   Tuple:

   ```rust
   fn main() {
       let x: (i32, f64, u8) = (500, 6.4, 1);
       let five_hundred = x.0;
       let six_point_four = x.1;
       let one = x.2;
   }
   ```

   Array:

   ```rust
   let a = [3; 5]; // let a = [3, 3, 3, 3, 3];
   ```

### Functions

1. In function signatures, you *must* declare the type of each **parameter**:

   ```rust
   fn main() {
       another_function(5, 6);
   }
   
   fn another_function(x: i32, y: i32) {
       println!("The value of x is: {}", x);
       println!("The value of y is: {}", y);
   }
   ```

2. :dart:**Expression and statement**: The `6` in the statement `let y = 6;` is an expression that evaluates to the value `6`. Calling a function is an expression. Calling a macro is an expression. The block that used to create new scopes, `{}`, is an expression. Expressions can be part of statements:

   ```rust
   fn main() {
       let x = 5;
       let y = {
           let x = 3;
           x + 1
       };
       println!("The value of y is: {}", y);
   }
   ```

3. Return values: Declare their type after an arrow (`->`). The return value of the function is synonymous with the value of the **final expression** in the block of the body of a function. You can return early from a function by using the `return` keyword and specifying a value:

   ```rust
   fn main() {
       let x = plus_one(5);
   
       println!("The value of x is: {}", x);
   }
   
   fn plus_one(x: i32) -> i32 {
       x + 1  // this is an expression. x+1; will cause an error, because it is a statement
   }
   ```

### Control flow

1. Condition in if **expression** must be a bool. The following codes will cause compiling error:

   ```rust
   fn main() {
       let number = 3;
   
       if number {
           println!("number was three");
       }
   }
   ```

   If can be used in let **statement**:

   ```rust
   fn main() {
       let condition = true;
       let number = if condition { 5 } else { 6 };
   
       println!("The value of number is: {}", number);
   }
   ```

2. Loop: One of the uses of a `loop` is to retry an operation you know might fail, such as checking whether a thread has completed its job. However, you might need to pass the result of that operation to the rest of your code. 

   ```rust
   fn main() {
       let mut counter = 0;
   
       let result = loop {
           counter += 1;
   
           if counter == 10 {
               break counter * 2;
           }
       };
   
       println!("The result is {}", result);
   }
   ```

3. For loop:

   ```rust
   fn main() {
       let a = [10, 20, 30, 40, 50];
   
       for element in a.iter() {
           println!("the value is: {}", element);
       }
   }
   ```

### Comments

Normal comments and documentation comments.

## Ownership

> Tags: safety, no garbage collection, borrowing, slices.

### Overview

1. String types:

   Literal string: `let x = "hello";` is on stack, immutable;

   String: `let s = String::from("hello");` is on heap, and can be mutable:

   ```rust
   let mut s = String::from("hello");
   s.push_str(", world!"); // push_str() appends a literal to a String
   println!("{}", s); // This will print `hello, world!`
   ```

2. The memory is automatically returned once the variable that owns it goes out of scope:

   ```rust
   {
     let s = String::from("hello"); // s is valid from this point forward
   
     // do stuff with s
   } // this scope is now over, and s is no longer valid
   ```

3. Assignment and move:

   Assignment in rust for types like String is equal to "move".

   ```rust
   let s1 = String::from("hello");
   let s2 = s1;
   
   println!("{}, world!", s1);  // error! s1 is invaild
   ```

4. Use clone to realize deep copy:

   ```rust
   let s1 = String::from("hello");
   let s2 = s1.clone();
   println!("s1 = {}, s2 = {}", s1, s2);
   ```

5. Stack only data is deep copied:

   > - All the integer types, such as `u32`.
   > - The Boolean type, `bool`, with values `true` and `false`.
   > - All the floating point types, such as `f64`.
   > - The character type, `char`.
   > - Tuples, if they only contain types that also implement `Copy`. For example, `(i32, i32)` implements `Copy`, but `(i32, String)` does not.

6. Functions and ownership:

   1. Passing a variable to a function will move or copy, just as assignment does. 
   2. Returning values can also transfer ownership. 

### Reference and borrowing

1. Having reference in rust is called borrowing.

   ```rust
   fn calculate_length(s: &String) -> usize { // s is a reference to a String
       s.len()
   } // Here, s goes out of scope. But because it does not have ownership of what
     // it refers to, nothing happens.
   ```

2. Reference is immutable by default:

   ```rust
   fn main() {
       let s = String::from("hello");
   
       change(&s);
   }
   
   fn change(some_string: &String) {
       some_string.push_str(", world");   // error!
   }
   ```

   Change to mutable:

   ```rust
   fn main() {
       let mut s = String::from("hello");
   
       change(&mut s);
   }
   
   fn change(some_string: &mut String) {
       some_string.push_str(", world");
   }
   ```

   Some restrictions to avoid data race:

   1. You can have only one mutable reference to a particular piece of data in a particular scope.
   2. We *also* cannot have a mutable reference while we have an immutable one. 
   3. Reference scope starts from where it is introduced and continues through **the last time** that reference is used.

3. Rust compiler can detect dangling references during compilation time.

### Slice Types

Slice type is like a small version of reference which does not have ownership too. “string slice” is written as `&str`.

```rust
fn first_word(s: &String) -> &str {
    let bytes = s.as_bytes();

    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return &s[0..i];
        }
    }

    &s[..]
}

fn main() {
    let mut s = String::from("hello world");

    let word = first_word(&s);

    s.clear(); // error!

    println!("the first word is: {}", word);
}
```

note for the error: if we have an immutable reference to something, we cannot also take a mutable reference. Because `clear` needs to truncate the `String`, it needs to get a mutable reference. Rust disallows this, and compilation fails.

## Struct

### Basics

1. Define and initialize:

   ```rust
   struct User {
       username: String,
       email: String,
       sign_in_count: u64,
       active: bool,
   }
   
   let mut user1 = User {
     email: String::from("someone@example.com"),
     username: String::from("someusername123"),
     active: true,
     sign_in_count: 1,
   };
   
   user1.email = String::from("anotheremail@example.com");
   ```

   > The entire instance must be mutable; Rust doesn’t allow us to mark only certain fields as mutable.

2. Struct method:

   Define:

   ```rust
   #[derive(Debug)]
   struct Rectangle{
       width: u32,
       height: u32,
   }
   
   impl Rectangle{
       // this a associated **function**
       // no parameters are self
       fn square(size:u32)->Rectangle{
           Rectangle{
               width:size,
               height:size,
           }
       }
     
       // methods
       fn area(&self) -> u32{
           self.width * self.height
       }
       // take self as a parameter.
       // self can be borrowed or taken ownership (which is a rare situation)
       // self can be mut and immut
       fn can_hold(&self, rect:&Rectangle)->bool{
           self.width >= rect.width && self.height >= rect.height
       }
   }
   ```


## Enum

### Key points

1. how to define:

```rust
enum IpAddrKind {
    V4,
    V6,
}
```

2. can be assign types/different types/user defined types:

```rust
enum IpAddr {
  V4(u8, u8, u8, u8),
  V6(String),
}

let home = IpAddr::V4(127, 0, 0, 1);

let loopback = IpAddr::V6(String::from("::1"));
```

3. Can have methods:

```rust
enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(i32, i32, i32),
}
impl Message {
  fn call(&self) {
    // method body would be defined here
  }
}
let m = Message::Write(String::from("hello"));
m.call();
```

4. **Option** enum vs null

Rust doesn't have null. Use Option enum instead

```rust
enum Option<T> {
    Some(T),
    None,
}

// use example:
let some_number = Some(5);
let some_string = Some("a string");
let absent_number: Option<i32> = None;  // None must be indicated types
```

Option\<T\> must firstly be converted to T and then it can be calculated with T types.

### Match and enum

1. What is match

   `match` allows you to compare a value against a series of **patterns** and then execute **code** based on which pattern matches.  If a pattern matches the value, the code associated with that pattern is executed. 

   ```rust
   fn value_in_cents(coin: Coin) -> u8 {
       match coin {
           Coin::Penny => {
               println!("Lucky penny!");
               1
           }
           Coin::Nickel => 5,
           Coin::Dime => 10,
           Coin::Quarter => 25,
       }
   }
   ```

2. Patterns and binded value

   ```rust
   #[derive(Debug)] // so we can inspect the state in a minute
   enum UsState {
       Alabama,
       Alaska,
       // --snip--
   }
   enum Coin {
       Penny,
       Nickel,
       Dime,
       Quarter(UsState),
   }
   fn value_in_cents(coin: Coin) -> u8 {
       match coin {
           Coin::Penny => 1,
           Coin::Nickel => 5,
           Coin::Dime => 10,
           Coin::Quarter(state) => {
               println!("State quarter from {:?}!", state);
               25
           }
       }
   }
   ```

3. Match and Option

   ```rust
   fn plus_one(x: Option<i32>) -> Option<i32> {
     match x {
       None => None,
       Some(i) => Some(i + 1),
     }
   }
   
   let five = Some(5);
   let six = plus_one(five);
   let none = plus_one(None);
   ```

4. Use `if let` to simplify match expression:

   ```rust
   let some_u8_value = Some(0u8);
   match some_u8_value {
     Some(3) => println!("three"),
     _ => (),
   }
   
   // simplify
   let some_u8_value = Some(0u8);
   if let Some(3) = some_u8_value {
     println!("three");
   }
   ```


## Packages, Crates, and Modules

### Definition of packages and crates

1. A crate can be a **binary** or **library**.

2. A package is one or more crates and contain one cargo.toml file.

3. **Rules**: A package *must* contain zero or one library crates, and no more. It can contain as many binary crates as you’d like, but it must contain at least one crate (either library or binary).

4. Crate root: a source file that the Rust compiler starts from and makes up the root module of your crate.

   > - *src/main.rs* is the crate root of a binary crate with the same name as the package. 
   > - the package contains a library crate with the same name as the package, and *src/lib.rs* is its crate root.

### Use Modules

1. Create a lib Crate:

   ```rust
   # cargo new --lib restaurant
   
   mod front_of_house {
       mod hosting {
           fn add_to_waitlist() {}
   
           fn seat_at_table() {}
       }
   
       mod serving {
           fn take_order() {}
   
           fn serve_order() {}
   
           fn take_payment() {}
       }
   }
   
   # module tree:
   crate
    └── front_of_house
        ├── hosting
        │   ├── add_to_waitlist
        │   └── seat_at_table
        └── serving
            ├── take_order
            ├── serve_order
            └── take_payment
   
   ```

   By using modules, we can group related definitions together and name why they’re related.

2. Public and private: see the codes.

3. Nested path:

   ```rust
   use std::cmp::Ordering;
   use std::io;
   // can be changed to
   use std::{cmp::Ordering, io};
   
   use std::io;
   use std::io::Write;
   // can be changed to
   use std::io::{self, Write};
   ```

   

   
