# c# FAQ

#### **What is reflection?**

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

#### **So what are attributes in c#?**

- c# 中属性说明了一个程序（整个生成的二进制文件-assembiles、一个类-types、方法-methods甚至返回值等）的metadata，通过reflection可以在运行时获取到。
- 属性有默认的（语言本身集成）也可以是用户自定的；
- 在对应代码块上方[target : attribute-name(paras1, paras2,...)] target表示应用范围，如assembly。

[Attributes (C#)](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/concepts/attributes/)

#### **How to create custom attributes?**

通过继承System.Attribute来自定义类。

[Creating Custom Attributes (C#)](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/concepts/attributes/creating-custom-attributes)

#### **How to** **[Accessing Attributes by Using Reflection (C#)](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/concepts/attributes/accessing-attributes-by-using-reflection)** **and** **[Retrieving Information Stored in Attributes](https://docs.microsoft.com/en-us/dotnet/standard/attributes/retrieving-information-stored-in-attributes)**?

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