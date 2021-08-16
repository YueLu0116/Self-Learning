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

