# c# FAQ

> [Hidden features of c#](https://stackoverflow.com/questions/9033/hidden-features-of-c)

## Advances

### What is reflection?

- 编译时不清楚某些对象的类型时，例如类、方法的等，利用回射检查（inspect）自身代码，确定这些类型。以一段java代码为例：

```csharp
// Without reflection 
Foo foo = new Foo(); 
foo.hello(); 
// With reflection Class cls = Class.forName("Foo"); 
Object foo = cls.newInstance(); 
Method method = cls.getMethod("hello", null); 
method.invoke(foo, null);
```

[What is reflection and why is it useful?](https://stackoverflow.com/questions/37628/what-is-reflection-and-why-is-it-useful?rq=1)

[What is the use of reflection in Java/C# etc](https://stackoverflow.com/questions/2488531/what-is-the-use-of-reflection-in-java-c-etc?noredirect=1&lq=1)

- Reflection in c#

创造一个类型实例，获取对象的类型，或者获取类型后调用其方法，访问field等。利用回射获取程序属性是最常用的一个功能。

[Reflection (C#)](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/concepts/reflection)

### So what are attributes in c#?

- c# 中属性说明了一个程序（整个生成的二进制文件-assembiles、一个类-types、方法-methods甚至返回值等）的metadata，通过reflection可以在运行时获取到。
- 属性有默认的（语言本身集成）也可以是用户自定的；
- 在对应代码块上方[target : attribute-name(paras1, paras2,...)] target表示应用范围，如assembly。

[Attributes (C#)](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/concepts/attributes/)

### How to create custom attributes?

通过继承System.Attribute来自定义类。

[Creating Custom Attributes (C#)](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/concepts/attributes/creating-custom-attributes)

### How to **[Accessing Attributes by Using Reflection (C#)](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/concepts/attributes/accessing-attributes-by-using-reflection)** **and** **[Retrieving Information Stored in Attributes](https://docs.microsoft.com/en-us/dotnet/standard/attributes/retrieving-information-stored-in-attributes)**?

Show me the code

```csharp
// Multiuse attribute.   
[System.AttributeUsage(System.AttributeTargets.Class |   
                       System.AttributeTargets.Struct,   
                       AllowMultiple = true)  // Multiuse attribute.   
]   
public class Author : System.Attribute   
{   
    string name;   
    public double version;   
   
    public Author(string name)   
    {   
        this.name = name;   
   
        // Default value.   
        version = 1.0;   
    }   
   
    public string GetName()   
    {   
        return name;   
    }   
}   
   
// Class with the Author attribute.   
[Author("P. Ackerman")]   
public class FirstClass   
{   
    // ...   
}   
   
// Class without the Author attribute.   
public class SecondClass   
{   
    // ...   
}   
   
// Class with multiple Author attributes.   
[Author("P. Ackerman"), Author("R. Koch", version = 2.0)]   
public class ThirdClass   
{   
    // ...   
}   
   
class TestAuthorAttribute   
{   
    static void Test()   
    {   
        PrintAuthorInfo(typeof(FirstClass));   
        PrintAuthorInfo(typeof(SecondClass));   
        PrintAuthorInfo(typeof(ThirdClass));   
    }   
   
    private static void PrintAuthorInfo(System.Type t)   
    {   
        System.Console.WriteLine("Author information for {0}", t);   
   
        // Using reflection.   
        System.Attribute[] attrs = System.Attribute.GetCustomAttributes(t);  // Reflection.   
   
        // Displaying output.   
        foreach (System.Attribute attr in attrs)   
        {   
            if (attr is Author)   
            {   
                Author a = (Author)attr;   
                System.Console.WriteLine("   {0}, version {1:f}", a.GetName(), a.version);   
            }   
        }   
    }   
}   
/* Output:   
    Author information for FirstClass   
       P. Ackerman, version 1.00   
    Author information for SecondClass   
    Author information for ThirdClass   
       R. Koch, version 2.00   
       P. Ackerman, version 1.00   
*/
```

### Lambdas

> [c# lambda in MSDN](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/operators/lambda-expressions)
>
> [How to return value with anonymous method?](https://stackoverflow.com/questions/10520892/how-to-return-value-with-anonymous-method)

1. Types:

   ```c#
   (input-parameters) => expression
   (input-parameters) => { <sequence-of-statements> }
   ```

2. Usages:

   - Convert to a delegate type

     ```c#
     Func<int, int> square = x => x * x;
     ```

   - Convert to the expression tree types (TODO)

     ```c#
     System.Linq.Expressions.Expression<Func<int, int>> e = x => x * x;
     Console.WriteLine(e);
     // Output:
     // x => (x * x)
     ```

   - Async lambdas

     ```c#
     public partial class Form1 : Form
     {
         public Form1()
         {
             InitializeComponent();
             button1.Click += async (sender, e) =>
             {
                 await ExampleMethodAsync();
                 textBox1.Text += "\r\nControl returned to Click event handler.\n";
             };
         }
     
         private async Task ExampleMethodAsync()
         {
             // The following line simulates a task-returning asynchronous process.
             await Task.Delay(1000);
         }
     }
     ```

3. A frequent error

   ```c#
   string temp = () => {return "test";};  // WRONG
   
   // modify
   Func<string> temp = () => {return "test";};
   ```

   > The problem here is that you've defined an anonymous method which returns a `string` but are trying to assign it directly to a `string`. It's an expression which when invoked produces a `string` it's not directly a `string`. It needs to be assigned to a compatible delegate type. In this case the easiest choice is `Func<string>`

### What is the expression body definition?

simple and easy to use: where `expression` is a valid expression. The return type of `expression` must be implicitly convertible to the `member`'s return type.

```csharp
// member => expression;

public override string ToString() => $"{fname} {lname}".Trim(); 

// equals to

public override string ToString() 
{ 
   return $"{fname} {lname}".Trim(); 
}
```



## Parallel Programming

### How to **correctly** use Reader-Writer lock

> https://docs.microsoft.com/en-us/dotnet/api/system.threading.readerwriterlock?view=net-5.0
>
> https://stackoverflow.com/questions/2116957/readerwriterlock-vs-lock
>
> https://stackoverflow.com/questions/4217398/when-is-readerwriterlockslim-better-than-a-simple-lock

使用读写锁的场景是，在实现一个下载器时，有两个线程，分别读、写同一个变量。[What happens if two threads read & write the same piece of memory](https://stackoverflow.com/questions/3580291/what-happens-if-two-threads-read-write-the-same-piece-of-memory)里说明了一个线程读，一个线程写，结果也是undefined的，需要加读写锁。

读写锁的机制是同一时刻，只有一个writer和多个readers（两个队列），写完后读，所有线程读完了再写。读写锁应用时，尽量减少写的时间，防止饥饿。同时会设置超时机制，防止死锁。

> For example, a thread might acquire the writer lock on one resource and then request a reader lock on a second resource; in the meantime, another thread might acquire the writer lock on the second resource, and request a reader lock on the first. Unless time-outs are used, the threads deadlock.

参考[ReaderWriterLock](https://docs.microsoft.com/en-us/dotnet/api/system.threading.readerwriterlock?view=net-5.0)，基本使用方式为

```csharp
static ReaderWriterLock rwl = new ReaderWriterLock();
rwl.AcquireReaderLock(timeOut);
// ...
rwl.ReleaseReaderLock();

rwl.AcquireWriterLock(timeOut);
// ...
rwl.ReleaseWriterLock();
```

> Instead of releasing a reader lock in order to acquire the writer lock, you can use [UpgradeToWriterLock](https://docs.microsoft.com/en-us/dotnet/api/system.threading.readerwriterlock.upgradetowriterlock?view=net-5.0) and [DowngradeFromWriterLock](https://docs.microsoft.com/en-us/dotnet/api/system.threading.readerwriterlock.downgradefromwriterlock?view=net-5.0).

官方建议使用 [ReaderWriterLockSlim](https://docs.microsoft.com/en-us/dotnet/api/system.threading.readerwriterlockslim?view=net-5.0)：

>  [ReaderWriterLockSlim](https://docs.microsoft.com/en-us/dotnet/api/system.threading.readerwriterlockslim?view=net-5.0) is recommended for all new development. [ReaderWriterLockSlim](https://docs.microsoft.com/en-us/dotnet/api/system.threading.readerwriterlockslim?view=net-5.0) is similar to [ReaderWriterLock](https://docs.microsoft.com/en-us/dotnet/api/system.threading.readerwriterlock?view=net-5.0), but it has simplified rules for recursion and for upgrading and downgrading lock state. [ReaderWriterLockSlim](https://docs.microsoft.com/en-us/dotnet/api/system.threading.readerwriterlockslim?view=net-5.0) avoids many cases of potential deadlock. In addition, the performance of [ReaderWriterLockSlim](https://docs.microsoft.com/en-us/dotnet/api/system.threading.readerwriterlockslim?view=net-5.0) is significantly better than [ReaderWriterLock](https://docs.microsoft.com/en-us/dotnet/api/system.threading.readerwriterlock?view=net-5.0).

### Delegate and event

> [Understanding events and event handlers in C#](https://stackoverflow.com/questions/803242/understanding-events-and-event-handlers-in-c-sharp)

event异步模式是当程序中有一个事件发生时，执行某些方法（event handlers），而delegate相当于event和handlers间的中间件。 

delegate可以理解为函数的签名，指明了参数与返回值：

```csharp
//This delegate can be used to point to methods
//which return void and take a string.
public delegate void MyEventHandler(string foo);
```

通过delegate来告知程序，当一个event发生时，调用哪种类型的函数：

```csharp
public event MyEventHandler SomethingHappened;
```

定义一个事件发生时需要执行的函数：

```csharp
void HandleSomethingHappened(string foo)
{
    //Do some stuff
}
```

登记：将对应的函数和event联系起来

```csharp
myObj.SomethingHappened += new MyEventHandler(HandleSomethingHappened);
```

raise an event

```csharp
// in some method
SomethingHappened("bar");
// or
// SomethingHappened?.Invoke("bar");
```

摘录微软官方文档笔记，见[此处](.\\event-notes.md)。

## Core

### What is the difference between readonly and const?

[readonly in microsoft docs](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/keywords/readonly) 官方文档中说明了`readonly`变量 (field) 只能在声明时或者构造函数中进行赋值，但可以进行多次赋值。而`const`变量只能被赋值一次。**readonly通过以下语句指定运行时常量：**

`public static readonly int ThisYear = 2004;` 而**const指定的是编译时常量**。

> The `readonly` keyword is different from the [const](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/keywords/const) keyword. A `const` field can only be initialized at the declaration of the field. A `readonly` field can be assigned multiple times in the field declaration and in any constructor. Therefore, `readonly` fields can have different values depending on the constructor used.

SO问题 [What is the difference between const and readonly in C#?](https://stackoverflow.com/questions/55984/what-is-the-difference-between-const-and-readonly-in-c) 给出了二者比较的例子：

```csharp
public class Const_V_Readonly
{
  public const int I_CONST_VALUE = 2;
  public readonly int I_RO_VALUE;
  public Const_V_Readonly()
  {
     I_RO_VALUE = 3;
  }
}
```

Assembly A中定义了这个类，而在Assembly B中引用到了Assembly A，那么对于const类型的变量，在A中改变该值，A和B都要重新编译，对于readonly变量，在A中改变了改值，只需要重新编译A。因此只有在确定变量值不变时才用const。

_Effective c#_中补充:

> - Compile-time constants can also be declared inside methods. Read-only constants cannot be declared with method scope.
> - Compile-time constants can be used only for primitive types (built-in integral and floating-point types), enums, or strings. Runtime constants can be any type.
> - Updating the value of a public constant should be viewed as an interface change. You must recompile all code that references that constant. Updating the value of a read-only constant is an implementation change; it is binary compatible with existing client code.

### What are field and property? What is the difference between them?

[field](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/fields) 对应类的“数据成员”官方文档中给出了如下几条规范：

> - Generally, you should use fields only for variables that have private or protected accessibility. Data that your class exposes to client code should be provided through [methods](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/methods), [properties](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/properties), and [indexers](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/indexers/). By using these constructs for indirect access to internal fields, you can guard against invalid input values. A private field that stores the data exposed by a public property is called a *backing store* or *backing field*. (封装，field通常是private and protect的)
> - Fields typically store the data that must be accessible to more than one class method and must be stored for longer than the lifetime of any single method. For example, a class that represents a calendar date might have three integer fields: one for the month, one for the day, and one for the year. Variables that are not used outside the scope of a single method should be declared as *local variables* within the method body itself. （类中多个方法需要使用的变量设为field，只在一个方法中使用的应该是那个方法的local variable）

[properity](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/properties)为private fields提供了接口（更为灵活，检查赋值是否合法等），有三种实现形式：

1. the traditional way

```csharp
public double Hours
{
    get { return _seconds / 3600; }
    set {
        if (value < 0 || value > 24)
            throw new ArgumentOutOfRangeException(
            $"{nameof(value)} must be between 0 and 24.");

        _seconds = value * 3600;
    }
}
```

2. expression body definitions

```csharp
public Person(string first, string last)
{
    _firstName = first;
    _lastName = last;
}

public string Name => $"{_firstName} {_lastName}";
```

3. auto-implemented properties

```csharp
public string Name
{ get; set; }

public decimal Price
{ get; set; }
```

SO也有相关[问题](https://stackoverflow.com/questions/2720142/programming-terms-field-member-properties-c)。

### What is Indexers, and why should I use it?

类似于带参数的属性，用以访问array / map等私有变量的成员。举例：

```c#
using System;

class SampleCollection<T>
{
   // Declare an array to store the data elements.
   private T[] arr = new T[100];

   // Define the indexer to allow client code to use [] notation.
   public T this[int i]
   {
      get => arr[i];
      set => arr[i] = value;
   }
}

class Program
{
   static void Main()
   {
      var stringCollection = new SampleCollection<string>();
      stringCollection[0] = "Hello, World.";
      Console.WriteLine(stringCollection[0]);
   }
}
// The example displays the following output:
//       Hello, World.
```

使用`this`关键字定义indexer，`value`关键字表示所赋值。

### What is "using" statement?

> [What are the uses of “using” in C#?](https://stackoverflow.com/questions/75401/what-are-the-uses-of-using-in-c)



## IO Related

### How to get the current/working directory?

> [How do I get the name of the current executable in C#?](https://stackoverflow.com/questions/616584/how-do-i-get-the-name-of-the-current-executable-in-c)

主要用于获取当前可执行文件的路径：

```c#
using System.Diagnostics;
Process.GetCurrentProcess().ProcessName;
// Process.GetCurrentProcess().MainModule.FileName
```

## Miscellaneous

### Run as administrator

> [How do I force my .NET application to run as administrator?](https://stackoverflow.com/questions/2818179/how-do-i-force-my-net-application-to-run-as-administrator)

添加Application Manifest File，按照其中的注释修改配置文件

`<requestedExecutionLevel level="requireAdministrator" uiAccess="false" />`

### How to check which .net framework version has been installed?

> [How to: Determine which .NET Framework versions are installed](https://docs.microsoft.com/en-us/dotnet/framework/migration-guide/how-to-determine-which-versions-are-installed)

检查注册表的方式：

> The version of .NET Framework (4.5 and later) installed on a machine is listed in the registry at HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full. If the Full subkey is missing, then .NET Framework 4.5 or above isn't installed.

### How to debug cs projects using visual studio code?

> https://github.com/OmniSharp/omnisharp-vscode/blob/master/debugger.md

```
// 创建工程目录
mkdir MyNewProject
cd MyNewProject
dotnet new console // dotnet new --list 查看所有工程模板

// vscode
打开对应folder
添加tasks.json 和 launch.json

// 编写程序

F5 debug
```

