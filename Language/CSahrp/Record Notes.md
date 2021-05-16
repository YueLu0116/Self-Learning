# Record Notes

> [records from MSDN](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/record)
>
> [When to use record vs class vs struct](https://stackoverflow.com/questions/64816714/when-to-use-record-vs-class-vs-struct)

## What is record?

> **Record**  type is nothing but **a container of properties and variables**, most of the time classes are full with properties and variables, we need lot of code to just declare them but with the help of *Record Type* you can reduce your effort.  The `record` keyword to define a [reference type](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/reference-types) (They have keywords or operators that are synonyms for a type in the .NET library, e.g., object, string, delegate, and dynamic types) that provides built-in functionality for **encapsulating data**. You can create record types with **immutable properties** by using **positional parameters** or standard property syntax.

An example for record v.s. class:

```csharp
class studentInfo 
{ 
    string _strFName; 
    string _strMName; 
    string _strLName; 
    studentInfo(string strFN, string strMN, string strLN){ 
        this._strFName = strFN; 
        this._strMName = strMN; 
        this._strLName = strLN; 
    } 
    public string StudentFName {get{ return this._strFName;}} 
    public string StudentMName {get{ return this._strMName;}} 
    public string StudentLName {get{ return this._strLName;}} 
}

class record studentInfo(string StudentFName, string StudentMName, string StudentLName);
```

## Features

### Positional syntax for property definition

A public **init-only** auto-implemented property for each positional parameter provided in the record declaration.

```csharp
public record Person(string FirstName, string LastName);

public static void Main()
{
    Person person = new("Nancy", "Davolio");
    Console.WriteLine(person);
    // output: Person { FirstName = Nancy, LastName = Davolio }
}
```

###  Immutability

Immutability can be useful when you need a data-centric type to be thread-safe or you're depending on a hash code remaining the same in a hash table.

Only data that a **reference-type** property refers to can be changed. 

```csharp
public record Person(string FirstName, string LastName, string[] PhoneNumbers);

public static void Main()
{
    Person person = new("Nancy", "Davolio", new string[1] { "555-1234" });
    Console.WriteLine(person.PhoneNumbers[0]); // output: 555-1234

    person.PhoneNumbers[0] = "555-6789";
    Console.WriteLine(person.PhoneNumbers[0]); // output: 555-6789
}
```

### Value equality

Value equality means that two variables of a record type are equal if the types match and all property and field values match. For other reference types, equality means identity. That is, two variables of a reference type are equal if they refer to the same object.

### Nondestructive mutation

A `with` expression makes a new record instance that is **a copy (shallow copy) of an existing record instance**, with specified properties and fields modified.

```cs
public record Person(string FirstName, string LastName)
{
    public string[] PhoneNumbers { get; init; }
}

public static void Main()
{
    Person person1 = new("Nancy", "Davolio") { PhoneNumbers = new string[1] };
    Console.WriteLine(person1);
    // output: Person { FirstName = Nancy, LastName = Davolio, PhoneNumbers = System.String[] }

    Person person2 = person1 with { FirstName = "John" };
    Console.WriteLine(person2);
    // output: Person { FirstName = John, LastName = Davolio, PhoneNumbers = System.String[] }
    Console.WriteLine(person1 == person2); // output: False

    person2 = person1 with { PhoneNumbers = new string[1] };
    Console.WriteLine(person2);
    // output: Person { FirstName = Nancy, LastName = Davolio, PhoneNumbers = System.String[] }
    Console.WriteLine(person1 == person2); // output: False

    person2 = person1 with { };
    Console.WriteLine(person1 == person2); // output: True
}
```

### Inheritance

A record can inherit from another record. However, a record can't inherit from a class, and a class can't inherit from a record. 

An example:

```cs
public abstract record Person(string FirstName, string LastName);
public record Teacher(string FirstName, string LastName, int Grade)
    : Person(FirstName, LastName);
public static void Main()
{
    Person teacher = new Teacher("Nancy", "Davolio", 3);
    Console.WriteLine(teacher);
    // output: Teacher { FirstName = Nancy, LastName = Davolio, Grade = 3 }
}
```

For two record variables to be equal, the run-time type must be equal. 

You can only set properties of the **compile-time type**:

```csharp
public record Point(int X, int Y)
{
    public int Zbase { get; set; }
};
public record NamedPoint(string Name, int X, int Y) : Point(X, Y)
{
    public int Zderived { get; set; }
};

public static void Main()
{
    Point p1 = new NamedPoint("A", 1, 2) { Zbase = 3, Zderived = 4 };

    Point p2 = p1 with { X = 5, Y = 6, Zbase = 7 }; // Can't set Name or Zderived
    Console.WriteLine(p2 is NamedPoint);  // output: True
    Console.WriteLine(p2);
    // output: NamedPoint { X = 5, Y = 6, Zbase = 7, Name = A, Zderived = 4 }

    Point p3 = (NamedPoint)p1 with { Name = "B", X = 5, Y = 6, Zbase = 7, Zderived = 8 };
    Console.WriteLine(p3);
    // output: NamedPoint { X = 5, Y = 6, Zbase = 7, Name = B, Zderived = 8 }
}
```

## Record v.s. Struct v.s. Class

> Structures are *value types*. Classes are *reference types*. Records are ***by default immutable*** reference types.
>
> Can your data type be a *value* type? Go with `struct`. No? Does your type describe a value-like, preferably immutable state? Go with `record`. Use `class` otherwise.

## Appendix: Built-in reference types

> [Built-in reference types from MSDN](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/reference-types)

They have keywords or operators that are synonyms for a type in the .NET library. Such as `object`, `string`, `delegate`, and `dynamic` types.

A key point:

> **Strings are *immutable***--the contents of a string object cannot be changed after the object is created, although the syntax below makes it appear as if you can do this. For example, when you write this code, the compiler actually **creates a new string object** to hold the new sequence of characters, and that new object is assigned to `b`. The memory that had been allocated for `b` (when it contained the string "h") is then eligible for **garbage collection**.

```csharp
string b = "h";
b += "ello";
```

