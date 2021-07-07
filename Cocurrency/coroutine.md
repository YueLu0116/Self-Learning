# Coroutine

## What is coroutine?

**Normal functions**: Call and return. Local variables are stored in stack and destroyed after returning.

**Coroutine**: Call - Suspend - Resume - Destroy - Return. Two data structures, one is in stack (stack frame) and the other is in heap (coroutine frame).

> - The **‘coroutine frame’** holds part of the coroutine’s activation frame that persists while the coroutine is suspended and the **‘stack frame’** part only exists while the coroutine is executing and is freed when the coroutine suspends and transfers execution back to the caller/resumer.
>
> - When performing the **Call** operation on a coroutine, the caller allocates a new stack-frame, writes the parameters to the stack-frame, writes the return-address to the stack-frame and transfers execution to the coroutine. This is exactly the same as calling a normal function.
>
>   The first thing the coroutine does is then **allocate a coroutine-frame on the heap and copy/move the parameters from the stack-frame into the coroutine-frame** so that the lifetime of the parameters extends beyond the first suspend-point.
>
> - The **Suspend**  operation suspends execution of the coroutine at the **current point** within the function and transfers execution back to the caller or resumer without destroying the activation frame. Any objects in-scope at the point of suspension remain alive after the coroutine execution is suspended.
>
> - The **Resume** operation resumes execution of a suspended coroutine at the point at which it was suspended. This reactivates the coroutine’s activation frame.
>
> - The **Destroy** operation destroys the activation frame without resuming execution of the coroutine. Any objects that were in-scope at the suspend point will be destroyed.

## Reference

[c++ 20 coroutine feature series by Lewis Baker](https://lewissbaker.github.io/)

[cppcoro in github](https://github.com/lewissbaker/cppcoro)

[What is a coroutine?](https://stackoverflow.com/questions/553704/what-is-a-coroutine)

[Explain coroutines like I'm five](https://dev.to/thibmaek/explain-coroutines-like-im-five-2d9)

[C++ coroutines: Getting rid of our mutex](https://devblogs.microsoft.com/oldnewthing/20210415-00/?p=105109)





