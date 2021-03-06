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

Slice type is like a small version of reference which does not have ownership too. ???string slice??? is written as `&str`.

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

   > The entire instance must be mutable; Rust doesn???t allow us to mark only certain fields as mutable.

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

3. **Rules**: A package *must* contain zero or one library crates, and no more. It can contain as many binary crates as you???d like, but it must contain at least one crate (either library or binary).

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
    ????????? front_of_house
        ????????? hosting
        ???   ????????? add_to_waitlist
        ???   ????????? seat_at_table
        ????????? serving
            ????????? take_order
            ????????? serve_order
            ????????? take_payment
   
   ```

   By using modules, we can group related definitions together and name why they???re related.

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

## Collections

### vector

1. Create and update a vector

   ```rust
   let vet: Vec<i32> = Vec::new();  // the "traditional" way
   
   let vet2 = vec![1,2,3] // use vec! macro, rust compiler can infer the type
   
   let mut vet3 = Vec::new();  // new and push
   vet.push(1);
   vet.push(2);
   //...
   ```

2. Read the elements

   ```rust
   let v = vec![1,2,3];
   let third: &i32 = &v[2] // use reference to borrow
                           // program will crash if out-of-boundary
   match v.get(2) {
     Some(third) => println!("The third element is {}", third),
     None => println!("There is no third element."),
   }                       // handle none to avoid program crash
   ```

3. The borrow rule

   ```rust
   let mut v = vec![1, 2, 3, 4, 5];
   let first = &v[0];
   v.push(6);
   println!("The first element is: {}", first);
   ```

   > Adding a new element onto the end of the vector might require allocating new memory and copying the old elements to the new space, if there isn???t enough room to put all the elements next to each other where the vector currently is. In that case, the reference to the first element would be pointing to deallocated memory. The borrowing rules prevent programs from ending up in that situation.

4. Iterate

   ```rust
   let v = vec![100, 32, 57];
   for i in &v {
     println!("{}", i);
   }                          // read only
   
   let mut v = vec![100, 32, 57];
   for i in &mut v {
     *i += 50;
   }                          // changeable
   ```

### Strings

1. What are strings? String from std and string slices.

2. Create a string

   ```rust
   let mut s1 = String::new();
   
   let s2 = "hello".to_string();
   let s3 = String::from("world");
   ```

3. Update

   ```rust
   let mut s = String::from("foo");
   s.push_str("bar");
   ```

   > The `push_str` method takes a string slice because we don???t necessarily want to take ownership of the parameter. 

   ```rust
   let s1 = String::from("tic");
   let s2 = String::from("tac");
   let s3 = String::from("toe");
   
   let s = s1 + "-" + &s2 + "-" + &s3;  // note s1 has been moved here and can no longer be used
   ```

   Add function signature:

   ```rust
   fn add(self, s: &str) -> String {
   ```

4. Rust string does not support indexing. (Utf8 reason)

### HashMap

1. Create

   ```rust
   use std::collections::HashMap;    // is a must
   let mut scores = HashMap::new();
   scores.insert(String::from("Blue"), 10);
   scores.insert(String::from("Yellow"), 50);
   ```

   ```rust
   use std::collections::HashMap;
   let teams = vec![String::from("Blue"), String::from("Yellow")];
   let initial_scores = vec![10, 50];
   // use iterators and the collect method on a vector of tuples
   let mut scores: HashMap<_, _> =
   teams.into_iter().zip(initial_scores.into_iter()).collect();
   ```

2. Ownership

   ```rust
   use std::collections::HashMap;
   let field_name = String::from("Favorite color");
   let field_value = String::from("Blue");
   let mut map = HashMap::new();
   map.insert(field_name, field_value);
   // field_name and field_value are invalid at this point, try using them and
   // see what compiler error you get!
   ```

   > For types that implement the `Copy` trait, like `i32`, the values are copied into the hash map. For owned values like `String`, the values will be moved and the hash map will be the owner of those values

3. Get values

   ```rust
   use std::collections::HashMap;
   let mut scores = HashMap::new();
   scores.insert(String::from("Blue"), 10);
   scores.insert(String::from("Yellow"), 50);
   let team_name = String::from("Blue");
   let score = scores.get(&team_name);
   ```

4. Update

   ```rust
   // overwrite
   use std::collections::HashMap;
   let mut scores = HashMap::new();
   scores.insert(String::from("Blue"), 10);
   scores.insert(String::from("Blue"), 25);
   println!("{:?}", scores);
   // insert if it does not exist
   use std::collections::HashMap;
   let mut scores = HashMap::new();
   scores.insert(String::from("Blue"), 10);
   scores.entry(String::from("Yellow")).or_insert(50);
   scores.entry(String::from("Blue")).or_insert(50);
   println!("{:?}", scores);
   ```

   ## Error handling
   
   Rust has no exceptions, just unrecoverable errors (panic!) and recoverable errors(Result\<T, E\>) instead.
   
   1. Get the backtrace after panic arose:
   
      ```bash
      $ RUST_BACKTRACE=1 cargo run # debug mode is a must
      ```
   
   2. Handle recoverable errors
   
      Use Result enum:
   
      ```rust
      enum Result<T, E> {
          Ok(T),
          Err(E),
      }
      ```
   
      Use match to "catch" (different) errors:
   
      ```rust
      use std::fs::File;
      use std::io::ErrorKind;
      
      fn main() {
          let f = File::open("hello.txt");
      
          let f = match f {
              Ok(file) => file,
              Err(error) => match error.kind() {
                  ErrorKind::NotFound => match File::create("hello.txt") {
                      Ok(fc) => fc,
                      Err(e) => panic!("Problem creating the file: {:?}", e),
                  },
                  other_error => {
                      panic!("Problem opening the file: {:?}", other_error)
                  }
              },
          };
      }
      ```
   
      Use helper functions: unwrap and expect:
   
      > - If the `Result` value is the `Ok` variant, `unwrap` will return the value inside the `Ok`. If the `Result` is the `Err` variant, `unwrap` will call the `panic!` macro for us.
   
      ```rust
      use std::fs::File;
      
      fn main() {
          let f = File::open("hello.txt").unwrap();
      }
      ```
   
      > - `expect`, which is similar to `unwrap`, lets us also choose the `panic!` error message. 
   
      ```rust
      use std::fs::File;
      
      fn main() {
          let f = File::open("hello.txt").expect("Failed to open hello.txt");
      }
      ```
   
      Return errors:
   
      ```rust
      use std::fs::File;
      use std::io;
      use std::io::Read;
      
      fn read_username_from_file() -> Result<String, io::Error> {
          let f = File::open("hello.txt");
      
          let mut f = match f {
              Ok(file) => file,
              Err(e) => return Err(e),
          };
      
          let mut s = String::new();
      
          match f.read_to_string(&mut s) {
              Ok(_) => Ok(s),
              Err(e) => Err(e),
          }
      }
      ```
   
      shortcuts:
   
      ```rust
      use std::fs::File;
      use std::io;
      use std::io::Read;
      
      fn read_username_from_file() -> Result<String, io::Error> {
          let mut s = String::new();
      
          File::open("hello.txt")?.read_to_string(&mut s)?;
      
          Ok(s)
      }
      ```
   

## Generic

See the codes

## Trait

This feature is like interface or abstract class in c++.

1. How to define a trait?
2. Other structs can implement traits.
3. Default traits method.

### One restriction:

> One restriction to note with trait implementations is that we can implement a trait on a type only if either the trait or the type is local to our crate.
>
> This restriction is part of a property of programs called *coherence*, and more specifically the *orphan rule*, so named because the parent type is not present. This rule ensures that other people???s code can???t break your code and vice versa.

### Default implementation:

> Default implementations can call other methods in the same trait, even if those other methods don???t have a default implementation. 

### Traits as parameters

1. Trait bounding

```rust
pub fn notify(item: &impl Summary) {
    println!("Breaking news! {}", item.summarize());
}
// equal to (syntax sugar)
pub fn notify<T: Summary>(item: &T) {
    println!("Breaking news! {}", item.summarize());
}
```

2. Multiple trait bounds

```rust
pub fn notify<T: Summary + Display>(item: &T) {}
```

3. Where clauses

```rust
fn some_function<T, U>(t: &T, u: &U) -> i32
    where T: Display + Clone,
          U: Clone + Debug
{}
```

4. Work with generic

Specification

```rust
use std::fmt::Display;

struct Pair<T> {
    x: T,
    y: T,
}

impl<T> Pair<T> {
    fn new(x: T, y: T) -> Self {
        Self { x, y }
    }
}

impl<T: Display + PartialOrd> Pair<T> {
    fn cmp_display(&self) {
        if self.x >= self.y {
            println!("The largest member is x = {}", self.x);
        } else {
            println!("The largest member is y = {}", self.y);
        }
    }
}
```

Conditionally implement a trait for any type that implements another trait.

```rust
impl<T: Display> ToString for T {
    // --snip--
}
```

## Lifetime

```rust
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() {
        x
    } else {
        y
    }
}
```

Three lifetime elision rules

> The first rule is that each parameter that is a reference gets its own lifetime parameter. In other words, a function with one parameter gets one lifetime parameter: `fn foo<'a>(x: &'a i32)`; a function with two parameters gets two separate lifetime parameters: `fn foo<'a, 'b>(x: &'a i32, y: &'b i32)`; and so on.
>
> The second rule is if there is exactly one input lifetime parameter, that lifetime is assigned to all output lifetime parameters: `fn foo<'a>(x: &'a i32) -> &'a i32`.
>
> The third rule is if there are multiple input lifetime parameters, but one of them is `&self` or `&mut self` because this is a method, the lifetime of `self` is assigned to all output lifetime parameters. This third rule makes methods much nicer to read and write because fewer symbols are necessary.

