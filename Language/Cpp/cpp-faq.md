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

3. control the linkage use `extern` and `static` (If the linkage is not specified then **the default linkage is `extern` (external linkage) for non-`const` symbols and `static` (internal linkage) for `const` symbols**.):

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

   - access: **unnamed namespaces are accessible within the file they're created in**, as if you had an implicit using-clause to them.

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

### What is the meaning of "!!"?

> [!! c operator, is a two NOT?](https://stackoverflow.com/questions/10307281/c-operator-is-a-two-not)
>
> [What is “!!” in C? [duplicate\]](https://stackoverflow.com/questions/14751973/what-is-in-c)
>
> [Defining double exclamation?](https://stackoverflow.com/questions/11374810/defining-double-exclamation)

`!!a` is 1 if `a` is non-zero and 0 if `a` is 0. Turn everything to `int`.

### My mentor told me to use forward declaration, but sometimes it can be failed...

> [C++ class forward declaration](https://stackoverflow.com/questions/9119236/c-class-forward-declaration)

> 1. `B` **only uses references or pointers** to `A`. Use forward declaration then you don't need to include `<A.h>`. This will in turn speed a little bit the compilation.
>
> ```cpp
> class A ;
> 
> class B 
> {
>   private:
>     A* fPtrA ;
>   public:
>     void mymethod(const& A) const ;
> } ;
> ```
>
> 2. `B` derives from `A` or `B` explicitly(or implicitly) uses objects of class `A`. You then need to include `<A.h>`
>
> ```cpp
> #include <A.h>
> 
> class B : public A 
> {
> };
> 
> class C 
> {
>   private:
>     A fA ;
>   public:
>     void mymethod(A par) ;   
> }
> ```

### Difference between two ways on initializing smart pointers

what's the difference?

```cpp
std::shared_ptr<Object> p1 = std::make_shared<Object>("foo");
std::shared_ptr<Object> p2(new Object("foo"));
```

The difference is that `std::make_shared` performs one heap-allocation, whereas calling the `std::shared_ptr` constructor performs two.

`std::shared_ptr` manages two entities:

- the control block (stores meta data such as ref-counts, type-erased deleter, etc)
- the object being managed

`std::make_shared` performs a single heap-allocation accounting for the space necessary for both the control block and the data. In the other case, `new Obj("foo")` invokes a heap-allocation for the managed data and the `std::shared_ptr` constructor performs another one for the control block.

### Oh! I forget how to use lambda in cpp  today...

> [What is a lambda expression in C++11?](https://stackoverflow.com/questions/7627098/what-is-a-lambda-expression-in-c11)

- The simplest version:

```cpp
void func3(std::vector<int>& v) {
  std::for_each(v.begin(), v.end(), [](int) { /* do something here*/ });
}
```

- add return types:

```cpp
void func4(std::vector<double>& v) {
    std::transform(v.begin(), v.end(), v.begin(),
        [](double d) -> double {
            if (d < 0.0001) {
                return 0;
            } else {
                return d;
            }
        });
}
```

- capture other variables except the passed ones

```cpp
void func5(std::vector<double>& v, const double& epsilon) {
    std::transform(v.begin(), v.end(), v.begin(),
        [epsilon](double d) -> double {
            if (d < epsilon) {
                return 0;
            } else {
                return d;
            }
        });
}
```

### Difference on casting an int to void between static and reinterpret cast

> [When to use reinterpret_cast?](https://stackoverflow.com/questions/573294/when-to-use-reinterpret-cast)

`static_cast`ing a pointer to and from `void*` preserves the address. 

```cpp
int* a = new int();
void* b = static_cast<void*>(a);
int* c = static_cast<int*>(b);
```

`reinterpret_cast` only guarantees that if you cast a pointer to a different type, *and then `reinterpret_cast` it back to the original type*, you get the original value.

```cpp
int* a = new int();
void* b = reinterpret_cast<void*>(a);
int* c = reinterpret_cast<int*>(b);
```

### How to new a 2D array?

> [How do I declare a 2d array in C++ using new?](https://stackoverflow.com/questions/936687/how-do-i-declare-a-2d-array-in-c-using-new)

If your row length is a compile time constant, C++11 allows

```cpp
auto arr2d = new int [nrows][CONSTANT];
```

### Why and when should I use union?

> [What is union, exactly](https://zh.cppreference.com/w/c/language/union)
>
> [Purpose of Unions in C and C++](https://stackoverflow.com/questions/2310483/purpose-of-unions-in-c-and-c)

> The purpose of union is to save memory by using the same memory region for storing different objects at different times.

### The capacity and size of a vector

> [Difference between std::resize(n) and std::shrink_to_fit in C++?](https://stackoverflow.com/questions/60400758/difference-between-stdresizen-and-stdshrink-to-fit-in-c)

> Vectors have two "length" attributes that mean different things:
>
> - `size` is the number of usable elements in the vector. It is the number of things you have stored. This is a conceptual length.
> - `capacity` is how many elements would fit into the amount of memory the vector has currently allocated.

### Rounding integer division

> [Rounding integer division (instead of truncating)](https://stackoverflow.com/questions/2422712/rounding-integer-division-instead-of-truncating)

```cpp
unsigned int round_closest(unsigned int dividend, unsigned int divisor)
{
    return (dividend + (divisor / 2)) / divisor;
}
```

### How to use `if constexpr`?

Condition judgement finished in compiling time. In a constexpr if statement, the value of *condition* must be a [contextually converted constant expression of type bool](https://en.cppreference.com/w/cpp/language/constant_expression#Converted_constant_expression)

```cpp
#include <iostream>

template<typename T>
auto print_type_info(const T& t) {
    if constexpr (std::is_integral<T>::value) {
        return t + 1;
    } else {
        return t + 0.001;
    }
}
int main() {
    std::cout << print_type_info(5) << std::endl;
    std::cout << print_type_info(3.14) << std::endl;
}
```

### The "<<" operator is binary

> [About overloading <<](https://www.learncpp.com/cpp-tutorial/overloading-the-io-operators/)
>
> Consider the expression `std::cout << point`. If the operator is <<, what are the operands? The left operand is the std::cout object, and the right operand is your Point class object. std::cout is actually an object of type std::ostream. 

For example:

```cpp
#include <iostream>
 
class Point
{
private:
    double m_x{};
    double m_y{};
    double m_z{};
 
public:
    Point(double x=0.0, double y=0.0, double z=0.0)
      : m_x{x}, m_y{y}, m_z{z}
    {
    }
 
    friend std::ostream& operator<< (std::ostream& out, const Point& point);
};
 
std::ostream& operator<< (std::ostream& out, const Point& point)
{
    // Since operator<< is a friend of the Point class, we can access Point's members directly.
    out << "Point(" << point.m_x << ", " << point.m_y << ", " << point.m_z << ')'; // actual output done here
 
    return out; // return std::ostream so we can chain calls to operator<<
}
 
int main()
{
    const Point point1{2.0, 3.0, 4.0};
 
    std::cout << point1 << '\n';
 
    return 0;
}
```

### What is the size of int, double... in c++?

> [What does the C++ standard state the size of int, long type to be?](https://stackoverflow.com/questions/589575/what-does-the-c-standard-state-the-size-of-int-long-type-to-be)
>
> [c data types - wikipedia](https://en.wikipedia.org/wiki/C_data_types)

The C++ standard does not specify the size of integral types in bytes, but it specifies **minimum ranges** they must be able to hold. 

So I should use `int32_t` to specify the size when do binary transportation.

### How to implement make_unique in c++?

> https://changkun.de/modern-cpp/zh-cn/05-pointers/index.html#5-3-std-unique-ptr

```cpp
template<typename T, typename ...Args>
std::unique_ptr<T> make_unique( Args&& ...args ) {
  return std::unique_ptr<T>( new T( std::forward<Args>(args)... ) );
}
```

### I want to return a local variable's pointer, but it will be destroyed after the function returns, so what can I do?

> [Returning a pointer of a local variable C++](https://stackoverflow.com/questions/19042552/returning-a-pointer-of-a-local-variable-c)
>
> [What is the lifetime of a static variable in a C++ function?](https://stackoverflow.com/questions/246564/what-is-the-lifetime-of-a-static-variable-in-a-c-function)

Method 1: New memory on heap. But may cause memory leakage when I forget to free it.

```cpp
int * count()
{
    int myInt = 5;

    int * p = new int;
    *p = myInt;

    return p;
}
```

Method 2: Return a smart pointer. But when I'm working on functions others' defined, I can't return what I want.

```cpp
unique_ptr<int> count()
{
   unique_ptr<int> value(new int(5));
   return value;
}
```

Method 3: Return a static variable's location.

```cpp
int* count()
{
    static int myInt = 5;
    return &myInt;
}
```

## Advances

### The forwarding problem

> [What are the main purposes of using std::forward and which problems it solves?](https://stackoverflow.com/questions/3582001/what-are-the-main-purposes-of-using-stdforward-and-which-problems-it-solves)

如何保证两个函数的参数完全相同？例如在模板中，想要保证E == f：

```cpp
template <typename A, typename B, typename C>
void f(A& a, B& b, C& c)
{
    E(a, b, c);
}
```

以上左值引用在传入的参数是临时左值时失效：`f(1,2,3)`

如果尝试：

```cpp
template <typename A, typename B, typename C>
void f(const A& a, const B& b, const C& c)
{
    E(a, b, c);
}
```

当尝试传入非常量时，E内不能修改。

在泛型编程时，这种情况就需要对每个参数的所有情况进行遍历，有$2^N$ 次。

cpp 11后引入了右值引用，引用运算遵循以下规则：

> "[given] a type TR that is a reference to a type T, an attempt to create the type “lvalue reference to cv TR” creates the type “lvalue reference to T”, while an attempt to create the type “rvalue reference to cv TR” creates the type TR."

```
TR   R

T&   &  -> T&  // lvalue reference to cv TR -> lvalue reference to T
T&   && -> T&  // rvalue reference to cv TR -> TR (lvalue reference to T)
T&&  &  -> T&  // lvalue reference to cv TR -> lvalue reference to T
T&&  && -> T&& // rvalue reference to cv TR -> TR (rvalue reference to T)
```

即左值引用结果都是左值引用，右值引用结果是本身。

And now we can use "perfect forwarding"

```cpp
template <typename A>
void f(A&& a)
{
    E(static_cast<A&&>(a)); 
}
```

That is what `std::forward` doing

```cpp
template <typename A>
void f(A&& a)
{
    E(std::forward<A>(a);); 
}
```

### Specialized Template

1. The compiler finds only one specialization. The compiler uses this specialization.
2. The compiler finds more than one specialization. The compiler uses the most specialized one. If this process ends in more than one specialization, the compiler throws an error.
3. The compiler finds no specialization. It uses the primary specialization.

### std::variant and std::visit

> https://kheresy.wordpress.com/2017/10/16/cpp17-variant/

## Template

### The true meaning of `typename`

> [Officially, what is typename for?](https://stackoverflow.com/questions/1600936/officially-what-is-typename-for)

The keyword `typename` was introduced to specify that the identifier that follows is a type. Consider the following example:

```cpp
template <class T>
Class MyClass
{
  typename T::SubType * ptr;
  ...
};
```

Here, `typename` is used to clarify that `SubType` is a **type** of `class T`. Thus, `ptr` is a pointer to the type `T::SubType`. Without `typename`, `SubType` would be considered **a static member**. Thus

```cpp
T::SubType * ptr
```

would be a multiplication of value `SubType` of type `T` with `ptr`.

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

### No default constructor exists for class xxx

> [no default constructor exists for class](https://stackoverflow.com/questions/4981241/no-default-constructor-exists-for-class)

A member of a class is self-defined class with a non-default constructer:

```cpp
class A
{
    A(/*...*/){/*...*/}
    // ...
}

class B
{
    //...
    A mA; // ERROR!
    B(A _a):mA(_a){} // CORRECT! or define a default constructer for A
}
```

### What is the meaning and usage of "::*"?

> [Pointer to class data member “::*”](https://stackoverflow.com/questions/670734/pointer-to-class-data-member)

An simple example:

```cpp
#include <iostream>

class bowl {
public:
    int apples;
    int oranges;
};

int count_fruit(bowl * begin, bowl * end, int bowl::*fruit)
{
    int count = 0;
    for (bowl * iterator = begin; iterator != end; ++ iterator)
        count += iterator->*fruit;
    return count;
}

int main()
{
    bowl bowls[2] = {
        { 1, 2 },
        { 3, 5 }
    };
    std::cout << "I have " << count_fruit(bowls, bowls + 2, & bowl::apples) << " apples\n";
    std::cout << "I have " << count_fruit(bowls, bowls + 2, & bowl::oranges) << " oranges\n";
    return 0;
}
```

## Parallel Programming

### How to create a thread function?

> [Simple example of threading in C++](https://stackoverflow.com/questions/266168/simple-example-of-threading-in-c)

```cpp
void task1(std::string msg)
{
    std::cout << "task1 says: " << msg;
}

std::thread t1(task1, "Hello");
```

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

### Thread function is a class's member function

> [Start thread with member function](https://stackoverflow.com/questions/10673585/start-thread-with-member-function)

```cpp
#include <thread>
#include <iostream>

class bar {
public:
    void foo() {
      std::cout << "hello from member function" << std::endl;
    }
    // in another member function
    std::thread spawn() {
      return std::thread(&blub::test, this);
    }
    // or
    std::thread spawn() {
      return std::thread( [this] { this->test(); } );
    }
};

// outside the class definition
int main()
{
  std::thread t(&bar::foo, bar()); // !!
  t.join();
}
```

### A similar question to the last one: how std::bind works with member functions

> [How std::bind works with member functions](https://stackoverflow.com/questions/37636373/how-stdbind-works-with-member-functions)

example:

```cpp
// for normal functions
double my_divide (double x, double y) {return x/y;}
auto fn_half = std::bind (my_divide,_1,2);               // returns x/2

std::cout << fn_half(10) << '\n';                        // 5

// for member functions
struct Foo {
    void print_sum(int n1, int n2)
    {
        std::cout << n1+n2 << '\n';
    }
    int data = 10;
};

Foo foo;
// for member fucntions
// the first arguement of std::bing must be explicitly an pointer
auto f = std::bind(&Foo::print_sum, &foo, 95, _1);
f(5);
```

more on pointer to a member:

```cpp
#include <iostream>

struct Foo {
    int value;
    void f() { std::cout << "f(" << this->value << ")\n"; }
    void g() { std::cout << "g(" << this->value << ")\n"; }
};

void apply(Foo* foo1, Foo* foo2, void (Foo::*fun)()) {
    (foo1->*fun)();  // call fun on the object foo1, applying a pointer to a member of a pointer to an object
    (foo2->*fun)();  // call fun on the object foo2
}

int main() {
    Foo foo1{1};
    Foo foo2{2};

    apply(&foo1, &foo2, &Foo::f);
    apply(&foo1, &foo2, &Foo::g);
}
```

> Since a pointer to a member function needs an object, it is necessary to use this operator which asks for an object. Internally, `std::bind()` arranges the same to happen.

### How to make a thread sleep for a certain duration?

`chrono` solution

```cpp
#include <chrono>
#include <thread>

std::this_thread::sleep_for(std::chrono::milliseconds(2000));
```

### What is std::future?

Thread A creates thread B, and after some time, A needs the results of B. Usage example:

```cpp
#include <iostream>
#include <future>
#include <thread>

int main() {
    // 将一个返回值为7的 lambda 表达式封装到 task 中
    // std::packaged_task 的模板参数为要封装函数的类型
    std::packaged_task<int()> task([](){return 7;});
    // 获得 task 的期物
    std::future<int> result = task.get_future(); // 在一个线程中执行 task
    std::thread(std::move(task)).detach();
    std::cout << "waiting...";
    result.wait(); // 在此设置屏障，阻塞到期物的完成
    // 输出执行结果
    std::cout << "done!" << std:: endl << "future result is " << result.get() << std::endl;
    return 0;
}
```

### unique_lock v.s. lock_guard

> https://stackoverflow.com/a/20516876/11100389

> The difference is that you can lock and unlock a `std::unique_lock`. `std::lock_guard` will be locked only once on construction and unlocked on destruction.

### When to use cv and when to use semaphore?

- A condition variable is generally used to avoid busy waiting

- Semaphores are good for producer/consumer situations where producers are allocating resources and consumers are consuming them. They're better used when you have a shared resource that can be available and unavailable based on some integer number of available things.

### std::atomic in c++

> [What exactly is std::atomic?](https://stackoverflow.com/questions/31978324/what-exactly-is-stdatomic)
>
> [atomic<>weapons](https://channel9.msdn.com/Shows/Going+Deep/Cpp-and-Beyond-2012-Herb-Sutter-atomic-Weapons-1-of-2)

about memory model:

- *sequential consistency* (default). This just means all loads and stores must be "as if" they happened in **the order you wrote them** within each thread.
- memory_order_relaxed: out-of-order loads and stores; i.e., if it requires atomicity but not **ordering**;
- memory_order_acquire/release: keep particular loads and stores in order.

Advice:

> Mutexes are great, and C++11 standardizes them. But sometimes for performance reasons you want lower-level primitives. Although to be frank, unless you are an expert and working on some serious low-level code, you should probably stick to mutexes and condition variables.

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

### How to convert a const char* to string?

```cpp
const char* str="hello";
std::string s = str;
// or std::string str(s);
```

### How to change "int" to a formatted hex string?

> [c++ std::cout in hexadecimal](https://stackoverflow.com/questions/28257957/c-stdcout-in-hexadecimal)

```cpp
#include <string>
#include <iomanip> // setfill and setw
#include <sstream>
#include <iostream>

int a = 15;
// std::setw(n): It is used to sets the field width to be used on output operations.
// std::setfill(c): use which character to fill the width.
std::cout << std::hex << std::setfill('0') << std::setw(2) << a; // prints "0f"
```

```cpp
// C++ code to demonstrate
// the working of setfill() function
  
#include <iomanip>
#include <ios>
#include <iostream>
  
using namespace std;
  
int main()
{
  
    // Initializing the integer
    int num = 50;
  
    cout << "Before setting the fill char: \n"
         << setw(10);
    cout << num << endl;
  
    // Using setfill()
    cout << "Setting the fill char"
         << " setfill to *: \n"
         << setfill('*')
         << setw(10);
    cout << num << endl;
  
    return 0;
}
```

### How to convert int to string?

> [Easiest way to convert int to string in C++](https://stackoverflow.com/questions/5590381/easiest-way-to-convert-int-to-string-in-c)

```cpp
#include <string> 

std::string s = std::to_string(42);
```

## Design Pattern

### Singleton in cpp

> [Is Meyers' implementation of the Singleton pattern thread safe?](https://stackoverflow.com/questions/1661529/is-meyers-implementation-of-the-singleton-pattern-thread-safe)
>
> :yum:[C++ Singleton design pattern](https://stackoverflow.com/questions/1008019/c-singleton-design-pattern)

how to:

```cpp
class S
{
    public:
        static S& getInstance()
        {
            static S    instance; // Guaranteed to be destroyed.
                                  // Instantiated on first use.
            return instance;
        }
    private:
        S() {}                    // Constructor? (the {} brackets) are needed here.

        // C++ 03
        // ========
        // Don't forget to declare these two. You want to make sure they
        // are inaccessible(especially from outside), otherwise, you may accidentally get copies of
        // your singleton appearing.
        S(S const&);              // Don't Implement
        void operator=(S const&); // Don't implement

        // C++ 11
        // =======
        // We can use the better technique of deleting the methods
        // we don't want.
    public:
        S(S const&)               = delete;
        void operator=(S const&)  = delete;

        // Note: Scott Meyers mentions in his Effective Modern
        //       C++ book, that deleted functions should generally
        //       be public as it results in better error messages
        //       due to the compilers behavior to check accessibility
        //       before deleted status
};
```

### What is RAII pattern?

> [What is meant by Resource Acquisition is Initialization (RAII)?](https://stackoverflow.com/questions/2321511/what-is-meant-by-resource-acquisition-is-initialization-raii)

There has been a bit of a movement to try to rename this concept as Scope-Bound Resource Management.  In short, things that we have a finite supply of and so we need to be able to control their usage. The 'Scope-bound' aspect means that the lifetime of the object is bound to the scope of a variable, so when the variable goes out of scope then the destructor will release the resource. For example:

```cpp
class ManagedResourceHandle {
public:
   ManagedResourceHandle(RawResourceHandle* rawHandle_) : rawHandle(rawHandle_) {};
   ~ManagedResourceHandle() {delete rawHandle; }
   ... // omitted operator*, etc
private:
   RawResourceHandle* rawHandle;
};

ManagedResourceHandle handle(createNewResource());
handle->performInvalidOperation();
```



## Windows related

### What is c++/winrt

> [What is C++/WinRT exactly?](https://stackoverflow.com/questions/60021694/what-is-c-winrt-exactly)
>
> [How do I get the computer’s serial number? Consuming Windows Runtime classes in desktop apps](https://devblogs.microsoft.com/oldnewthing/20180108-00/?p=97735)

c++ 17以来包含的windows运行时api。

使用时需要先通过nuget获取cppwinrt，install后必须要**先build一下**，然后再去使用其中的头文件。

应用举例：获取bios serial number

```cpp
#include <windows.h>
#include <stdio.h> // Horrors! Mixing C and C++!

#include "winrt/Windows.System.Profile.SystemManufacturers.h"

int __cdecl wmain(int, char**)
{
  winrt::init_apartment();
  {
    auto serialNumber = winrt::Windows::System::Profile::
         SystemManufacturers::SmbiosInformation::SerialNumber();
    wprintf(L"Serial number = %ls\n", serialNumber.c_str());
  }

  // The last thread cleans up before uninitializing for good.
  winrt::clear_factory_cache();
  winrt::uninit_apartment();

  return 0;
}
```

### How to get exe name?

Use GetModuleFileName api. Get the total path.

```cpp
#include <iostream>
#include <Windows.h>

using namespace std;

int main ()
{   LPWSTR buffer[MAX_PATH]; //or wchar_t * buffer;
    GetModuleFileName(NULL, buffer, MAX_PATH) ;
    cout<<buffer;
}
```

### How to delete a registry key?

The key point is we must first open the registry key. And we must know which is the key and which is the value.

```cpp
HKEY hKey = NULL;
long lReturn = RegOpenKeyEx( HKEY_CURRENT_USER,
                             _T("test1\\test2\\test3"),
                             0L,
                             KEY_SET_VALUE,
                             &hKey );
if (lReturn == ERROR_SUCCESS)
{
    lReturn = RegDeleteValue(hKey, _T("value1"));
    lReturn = RegDeleteValue(hKey, _T("value2"));
    lReturn = RegCloseKey(hKey);
}

lReturn = RegDeleteKey(HKEY_CURRENT_USER, _T("test1\\test2\\test3"));
lReturn = RegDeleteKey(HKEY_CURRENT_USER, _T("test1\\test2"));
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

### Why should I use noexcept?

> https://www.modernescpp.com/index.php/c-core-guidelines-the-noexcept-specifier-and-operator

> First, an exception specifier documents the behaviour of the function. If a function is specified as noexcept, it can be safely used in a non-throwing function. Second, it is an optimisation opportunity for the compiler. noexcept may not call std::unexpectedand may not unwind the stack. 

### Precompile header files should be put in the first position or it will cause compile error

> [Why stdfax.h should be the first include on MFC applications? ](https://stackoverflow.com/questions/16040689/why-stdfax-h-should-be-the-first-include-on-mfc-applications)

error: class xxx is not a class or namespace name.

### Error: "conversion to inaccessible base class 'xx' is not allowed"

> [C++ inheritance - inaccessible base?](https://stackoverflow.com/questions/4847100/c-inheritance-inaccessible-base)

The default inheritance type of a `class` in C++ is `private`, so any `public` and `protected` members from the base class are limited to `private`.

```cpp
class Bar : public Foo
{
    // ...
}
```

### std::cout uint8_t just print a blank

> [uint8_t can't be printed with cout](https://stackoverflow.com/questions/19562103/uint8-t-cant-be-printed-with-cout)

> `uint8_t` will most likely be a `typedef` for `unsigned char`. The `ostream` class has a special overload for `unsigned char`, i.e. it prints the character with the number 5, which is non-printable, hence the empty space.

Solutions 1:

```cpp
uint8_t aa=5;
cout << "value is " << unsigned(aa) << endl;
```

Solutions 2:

```c++
uint8_t aa = 5;
cout<<"value is "<< +aa <<endl; // value is 5
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

### How to define the application version in visual studio?

> https://stackoverflow.com/questions/20362394/how-do-i-add-version-information-to-the-compiled-exe-file-in-visual-studio
>
> Right-click the **Resource Files** folder in your solution, Add, Resource, Version. Just edit the fields as you want them. 

Bonus: [the difference between file version and production version](https://stackoverflow.com/questions/752162/whats-the-difference-between-a-dlls-fileversion-and-productversion)

> File and product versions are only likely to be different if the assembly in question is not just part of one product (e.g. a reusable third party library), if just used in a single application there seems little reason not to keep them the same.

## Linkages

### What is "incremental linking"?

> [What is “incremental linking”?](https://stackoverflow.com/questions/3349521/what-is-incremental-linking)

Incremental linking links your exe/dll in a way which makes it easier for the linker to update the existing exe/dll when you make a small change and re-compile.

### What is pdb files?

> [What is a PDB file?](https://stackoverflow.com/questions/3899573/what-is-a-pdb-file)

**PDB** is an abbreviation for **P**rogram-Debug **D**ata **B**ase. As the name suggests, it is a repository (persistent storage such as databases) to maintain information required to run your program in debug mode. It contains many important information required to you debug your code (in Visual Studio) e.g. at what points you have put break points where you expect the debugger to break in Visual Studio.

Generally it is not recommended to exclude the generation of `*.pdb` files. From production release stand-point what you should be doing is create the PDB files but don't ship them to customer site in product installer. Preserve all the generated PDB files on a symbol server from where it can be used/referenced in future if required. 

## Resource

- [Default keyboard shortcuts in Visual Studio](https://docs.microsoft.com/en-us/visualstudio/ide/default-keyboard-shortcuts-in-visual-studio?view=vs-2019)