# cpp FAQ

> personal questions generated in everyday programming. Answers mainly extracted from stackoverflow

## Basics

### How to correctly use global variables?

> [How to declare a global variable in C++](https://stackoverflow.com/questions/9702053/how-to-declare-a-global-variable-in-c)

global variables: any variable declared outside functions

use global variables in other TUs:

```cpp
// a.cpp
int x = 5;

// b.h
extern int x;
//b.cpp
#include "b.h"
// use x
void foo(){
    std::cout << x;
}
```

about const global variables: if a variable is marked as const, it is internal linkage.

```cpp
// a.cpp
extern const int x = 5;
// b.h
extern const int x;
// b.cpp
#include "b.h"
void foo(){
    std::cout << x;
}
```

use a global head file: include this head file everywhere I need to access it.

```cpp
// globals.h
extern int x;
// global.cpp
int x = 5;
```

### Translation unit and linkage

> [What is a “translation unit” in C++?](https://stackoverflow.com/questions/1106149/what-is-a-translation-unit-in-c)
>
> [Translation units and linkage](https://docs.microsoft.com/en-us/cpp/cpp/program-and-linkage-cpp?view=msvc-160)
>
> [What is external linkage and internal linkage?](https://stackoverflow.com/questions/1358400/what-is-external-linkage-and-internal-linkage)
>
> [Superiority of unnamed namespace over static?](https://stackoverflow.com/questions/4422507/superiority-of-unnamed-namespace-over-static)
>
> [Unnamed/anonymous namespaces vs. static functions](https://stackoverflow.com/questions/154469/unnamed-anonymous-namespaces-vs-static-functions)

1. about TU:

> A translation unit is the **basic unit of compilation** in C++. It consists of the contents of **a single source file, plus the contents of any header files directly or indirectly included by it**, minus those lines that were ignored using conditional preprocessing statements.
>
> A single translation unit can be compiled into an object file, library, or executable program.

2. about linkage: 
   - external linkage: refers to things that exist **beyond a particular translation unit**. In other words, accessible through the whole program, which is the combination of all translation units;
   - internal linkage: refers to everything only **in scope of a translation unit**.

3. control the linkage use `extern` and `static` (If the linkage is not specified then the default linkage is `extern` (external linkage) for non-`const` symbols and `static` (internal linkage) for `const` symbols.):

```cpp
// In namespace scope or global scope.
int i; // extern by default
const int ci; // static by default
extern const int eci; // explicitly extern
static int si; // explicitly static

// The same goes for functions (but there are no const functions).
int f(); // extern by default
static int sf(); // explicitly static 
```

4. use anonymous namespace for internal linkage is a better choice

   - for user-defined types:

     ```cpp
     //legal code
     static int sample_function() { /* function body */ }
     static int sample_variable;
     
     //illegal code
     static class sample_class { /* class body */ };
     static struct sample_struct { /* struct body */ };
     
     //legal code
     namespace 
     {  
          class sample_class { /* class body */ };
          struct sample_struct { /* struct body */ };
     }
     ```

   - access: unnamed namespaces are accessible within the file they're created in, as if you had an implicit using-clause to them.

   - other usages: Putting methods in an anonymous namespace prevents you from accidentally violating the One Definition Rule, allowing you to never worry about naming your helper methods the same as some other method you may link in.

### More about static key word

> [The static keyword and its various uses in C++](https://stackoverflow.com/questions/15235526/the-static-keyword-and-its-various-uses-in-c/15235708)

1. static variables: 

   - If it's **in a namespace scope** (i.e. outside of functions and classes), then it can't be accessed from any other translation unit. 

   - If it's a variable *in a function*, it can't be accessed from outside of the function, just like any other local variable. 

     ```cpp
     void foo()
     {
        static int x; //static storage duration - shared between calls
     }
     ```

     

   - class members have no restricted scope due to `static`, but can be addressed from the class as well as an instance. You can *declare* static members in a class, but they should usually still be *defined* in a translation unit (cpp file), and as such, there's only one per class.

   - initialize orders: [static initialization order fiasco](https://stackoverflow.com/questions/3035422/static-initialization-order-fiasco)

2. static functions:

   - very rarely used for a free-standing function
   - A static member function differs from a regular member function in that it can be called without an instance of a class, and since it has no instance, **it cannot access non-static members of the class**.

### When to use scope resolution operator?

> [scope resolution operator without a scope](https://stackoverflow.com/questions/75213/scope-resolution-operator-without-a-scope)
>
> [When to use “::” for global scope in C++?](https://stackoverflow.com/questions/17289896/when-to-use-for-global-scope-in-c)

> You might need to use this operator when you have conflicting functions or variables in the same scope and you need to use a global one. 

```c++
void bar();    // this is a global function

class foo {
    void some_func() { ::bar(); }    // this function is calling the global bar() and not the class version
    void bar();                      // this is a class member
};
```

### How to initialize a container-like struct?

Use *Aggregate initialization*: [reference](https://en.cppreference.com/w/cpp/language/aggregate_initialization)

An example:

```c++
struct address {
    int street_no;
    char *street_name;
    char *city;
    char *prov;
    char *postal_code;
};
address temp_addres = {
  0,  // street_no
  nullptr,  // street_name
  "Hamilton",  // city
  "Ontario",  // prov
  nullptr,  // postal_code
};
```

### Things on Enum

> [Enumeration declaration](https://en.cppreference.com/w/cpp/language/enum)
>
> [Where to put the enum in a cpp program?](https://stackoverflow.com/questions/993505/where-to-put-the-enum-in-a-cpp-program)
>
> 

1. unscoped  `enum`:

   > If the underlying type is not fixed and the source value is out of range, the result is unspecified (until C++17)the behavior is undefined (since C++17).

   ```cpp
   // define
   enum Color { red, green, blue };
   Color r = red;
   // types conversion
   enum access_t { read = 1, write = 2, exec = 4 }; // enumerators: 1, 2, 4 range: 0..7
   access_t x = static_cast<access_t>(8.0); // undefined behavior since C++17
   access_t y = static_cast<access_t>(8);   // undefined behavior since C++17
   ```

2. scoped `enum`

   > Each *enumerator* becomes **a named constant** of the enumeration's type, which is contained **within the scope of the enumeration**, and can be accessed using scope resolution operator. There are no implicit conversions from the values of a scoped enumerator to integral types, although [`static_cast`](https://en.cppreference.com/w/cpp/language/static_cast) may be used to **obtain the numeric value of the enumerator**.

   ```cpp
   enum class Color { red, green = 20, blue };
   Color r = Color::blue;
   // int n = r; // error: no implicit conversion from scoped enum to int
   int n = static_cast<int>(r); // OK, n = 21
   ```

   More info:

   > [What's an enum class and why should I care?](https://stackoverflow.com/questions/14041711/whats-an-enum-class-and-why-should-i-care)

3. `enum struct|class name : type{...}`

   `enum name(optional) : type{...}`

4. Where should I put `enum` in my project? Mostly, put them in a common head files.

### What is "*&" in c++?

> [Meaning of *& and **& in C++](https://stackoverflow.com/questions/5789806/meaning-of-and-in-c)

That is taking the parameter by reference. So in the first case you are taking a pointer parameter by reference so whatever modification you do to **the value of the pointer** is reflected outside the function. 

Example:

```cpp
void pass_by_value(int* p)
{
    //Allocate memory for int and store the address in p
    p = new int;
}

void pass_by_reference(int*& p)
{
    p = new int;
}

int main()
{
    int* p1 = NULL;
    int* p2 = NULL;

    pass_by_value(p1); //p1 will still be NULL after this call
    pass_by_reference(p2); //p2 's value is changed to point to the newly allocate memory

    return 0;
}
```

### What happens to a function's local memory after its ending?

> [Can a local variable's memory be accessed outside its scope?](https://stackoverflow.com/questions/6441218/can-a-local-variables-memory-be-accessed-outside-its-scope)

A great [answer](https://stackoverflow.com/a/6445794/11100389)!

### The lift time of string literals

```c++
const char **p = nullptr;

{
    const char *t = "test";
    p = &t;
}

cout << *p;
```

The value of `t` is the address of the string literal `"test"`, and that is not a variable you declared, **it's not on the stack and has static duration, which is the same with static variables** . It's a string literal, which is a constant defined in the program (similar to the integer literal `99` or the floating point literal `0.99`). Literals don't go out of scope as you expect, because they are not created or destroyed, they just *are*.

## OOP

### Can I access derived class member from base class?

> [Can I access derived class member from base class?](https://stackoverflow.com/questions/2436125/c-access-derived-class-member-from-base-class-pointer)

Example:

```c++
class Base
{
    public:
    int base_int;
};

class Derived : public Base
{
    public:
    int derived_int;
};

Base* basepointer = new Derived();
basepointer-> //Access derived_int here, is it possible? If so, then how?
```

No, I can't...

## Parallel Programming

### Why can't I use reference in a thread process function?

> [Passing object by reference to std::thread in C++11](https://stackoverflow.com/questions/34078208/passing-object-by-reference-to-stdthread-in-c11/34078246)

线程启动时，如果引用指向的变量已经被销毁，则与线程执行相关的函数将会崩溃。举例如下：

```c++
// thread function
void SimpleThread(int& i) {
    std::this_thread::sleep_for(std::chrono::seconds{1});
    i = 0;
}

// main function
// causing thread funcion failed
int main()
{
    {
        int a;
        std::thread th(SimpleThread, a);
        th.detach();
    }
    // "a" is out of scope
    // at this point the thread may be still running
    // ...
}
```

如果偏要使用引用作为参数，则可以使用`std::ref`:

```c++
auto thread1 = std::thread(SimpleThread, std::ref(a));
```

## Types and Conversions

### How to convert string to wstring?

> [C++ Convert string (or char*) to wstring (or wchar_t*)](https://stackoverflow.com/questions/2573834/c-convert-string-or-char-to-wstring-or-wchar-t)
>
> [How do I convert a string to a wstring using the value of the string?](https://stackoverflow.com/questions/18244133/how-do-i-convert-a-string-to-a-wstring-using-the-value-of-the-string)

just for reference. c++ 20 may update this function.

Windows API solution (use `MultiByteToWideChar`):

```c++
std::wstring s2ws(const std::string& s)
{
    int len;
    int slength = (int)s.length() + 1;
    len = MultiByteToWideChar(CP_ACP, 0, s.c_str(), slength, 0, 0); 
    wchar_t* buf = new wchar_t[len];
    MultiByteToWideChar(CP_ACP, 0, s.c_str(), slength, buf, len);
    std::wstring r(buf);
    delete[] buf;
    return r;
}
```

### How to convert wstring into string?

> [How to convert wstring into string?](https://stackoverflow.com/questions/4804298/how-to-convert-wstring-into-string)

### `string` v.s. `wstring`

> [std::wstring VS std::string](https://stackoverflow.com/questions/402283/stdwstring-vs-stdstring)
>
> [utf-8 everywhere](http://utf8everywhere.org/)
>
> [Should UTF-16 be considered harmful?](https://softwareengineering.stackexchange.com/questions/102205/should-utf-16-be-considered-harmful)

`std::string` 以`char`为模板，而`std::wstring`以`wchar_t`为模板。

`char`8位1字节，而`wchar_t`由操作系统决定。在linux上，`wchar_t`是4字节，而在windows上`char`是2字节，在windows上（UFT-16)，使用`char`型变量的被称为multibyte，而使用`wchar_t`的被称为widechar，相关api有`MultibyteToWideChar`以及`WideCharToMultiByte`。

### How to convert a single char to a string?

> [Convert a single character to a string?](https://stackoverflow.com/questions/3222572/convert-a-single-character-to-a-string)

simple and easy:

```cpp
string firstLetter(1,str[0]);
```

### How to print wide character?

> [printf, wprintf, %s, %S, %ls, char* and wchar*: Errors not announced by a compiler warning?](https://stackoverflow.com/questions/17700797/printf-wprintf-s-s-ls-char-and-wchar-errors-not-announced-by-a-compil)
>
> [How to initialize and print a std::wstring?](https://stackoverflow.com/questions/8788057/how-to-initialize-and-print-a-stdwstring)

```cpp
wprintf(L"2 %S\n",L"some string"); // printf
std::wstring st = L"SomeText";
std::wcout << st; // stream
```

## Errors and Exceptions handling

### Error: Expected a type specifier

> [C++ Error: Expected a type specifier](https://stackoverflow.com/questions/21100391/c-error-expected-a-type-specifier)

工作中的具体场景，自定义了`class A` 和`class B`:

```cpp
class A{
public:
    A(const std::string &_str):m_str(_str){}
// ...
}

class B{
public:
    B();
private:
    std::string _str;
    A mA(_str);
}
```

编译器提示错误，如标题所示。

类型A的初始化应该在B的构造函数中：

```cpp
class A{
public:
    A(const std::string &_str):m_str(_str){}
// ...
}

class B{
public:
    B(): mA(_str){};
private:
    std::string _str;
    A mA;
}
```

参考：[Most vexing parse](https://en.wikipedia.org/wiki/Most_vexing_parse)

### How to convert a const char* to string?

```cpp
const char* str="hello";
std::string s = str;
// or std::string str(s);
```

## Utils

### How to get current (working) directory?

```cpp
#include <filesystem>  // !!!
#include <iostream>

std::filesystem::path cwd = std::filesystem::current_path() / "filename.txt";
std::ofstream file(cwd.string());
file.close();
```

### How to get current time?

> [How to get current time and date in C++?](https://stackoverflow.com/questions/997946/how-to-get-current-time-and-date-in-c)

```c++
#include <iostream>
#include <chrono>
#include <ctime>    

int main()
{
    auto start = std::chrono::system_clock::now();
    // Some computation here
    auto end = std::chrono::system_clock::now();

    std::chrono::duration<double> elapsed_seconds = end-start;
    std::time_t end_time = std::chrono::system_clock::to_time_t(end);

    std::cout << "finished computation at " << std::ctime(&end_time)
              << "elapsed time: " << elapsed_seconds.count() << "s\n";
}
```



## Resource

- [Default keyboard shortcuts in Visual Studio](https://docs.microsoft.com/en-us/visualstudio/ide/default-keyboard-shortcuts-in-visual-studio?view=vs-2019)