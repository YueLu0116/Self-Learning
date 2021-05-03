# 【C#】Event

[Handling and Raising Events](https://docs.microsoft.com/en-us/dotnet/standard/events/)

1. The object that raises the event is called the *event sender*. The event is typically a member of the event sender.
2. To define an event, you use the C# [event](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/keywords/event) in the signature of your event class, and **specify the type of delegate**  for the event.
3. To raise an event, you add a **method** . Name this method OnEventName (not a must); for example, OnDataReceived. The method should **take one parameter that specifies an event data object, which is an object of type EventArgs or a derived type** . 

```csharp
class Counter 
{ 
    // event delegateName EventName
    public event EventHandler ThresholdReached; 
 
    // invoke events
    protected virtual void OnThresholdReached(EventArgs e) 
    { 
        EventHandler handler = ThresholdReached; 
        handler?.Invoke(this, e); 
    } 
 
    // provide remaining implementation for the class 
}
```

1. A delegate is declared with a **signature**  that shows the return type and parameters for the methods it references, and it can hold references only to methods that match its signature. A delegate is an **intermediary (or pointer-like mechanism)**  between the event source and the code that handles the event.
2. Data that is associated with an event can be provided through an event data class.

```csharp
public class ThresholdReachedEventArgs : EventArgs
{
    public int Threshold { get; set; }
    public DateTime TimeReached { get; set; }
}
```

1. To respond to an event, you define an **event handler method** (not the method in [3]) in the event receiver. This method must match the signature of the delegate for the event you are handling.
2. To receive notifications when the event occurs, your event handler method must **subscribe to the event** . (Event handler -> Event)

```c#
class Program 
{ 
    static void Main() 
    { 
        var c = new Counter(); 
        c.ThresholdReached += c_ThresholdReached; 
 
        // provide remaining implementation for the class 
    } 
 
    static void c_ThresholdReached(object sender, EventArgs e) 
    { 
        Console.WriteLine("The threshold was reached."); 
    } 
}
```

[EventHandler Delegate (System)](https://docs.microsoft.com/en-us/dotnet/api/system.eventhandler?view=net-5.0)

Example:

```csharp
using System; 
 
namespace ConsoleApplication1 
{ 
    class Program 
    { 
        static void Main(string[] args) 
        { 
            Counter c = new Counter(new Random().Next(10)); 
            c.ThresholdReached += c_ThresholdReached; 
 
            Console.WriteLine("press 'a' key to increase total"); 
            while (Console.ReadKey(true).KeyChar == 'a') 
            { 
                Console.WriteLine("adding one"); 
                c.Add(1); 
            } 
        } 
 
        // handler
        static void c_ThresholdReached(object sender, ThresholdReachedEventArgs e) 
        { 
            Console.WriteLine("The threshold of {0} was reached at {1}.", e.Threshold,  e.TimeReached); 
            Environment.Exit(0); 
        } 
    } 
 
    class Counter 
    { 
        private int threshold; 
        private int total; 
 
        public Counter(int passedThreshold) 
        { 
            threshold = passedThreshold; 
        } 
 
        public void Add(int x) 
        { 
            total += x; 
            if (total >= threshold) 
            { 
                ThresholdReachedEventArgs args = new ThresholdReachedEventArgs(); 
                args.Threshold = threshold; 
                args.TimeReached = DateTime.Now; 
                OnThresholdReached(args);     // trigger
            } 
        } 
 
        protected virtual void OnThresholdReached(ThresholdReachedEventArgs e) 
        { 
            // EventHandler<ThresholdReachedEventArgs> handler = ThresholdReached; 
            // if (handler != null) 
            // { 
            //     handler(this, e); 
            // } 
            ThresholdReached?.Invoke(this,e);
        } 
 
        public event EventHandler<ThresholdReachedEventArgs> ThresholdReached; 
    } 
 
    public class ThresholdReachedEventArgs : EventArgs 
    { 
        public int Threshold { get; set; } 
        public DateTime TimeReached { get; set; } 
    } 
}
```