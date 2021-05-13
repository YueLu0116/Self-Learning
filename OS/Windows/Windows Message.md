# Windows Message Model

> [Window Messages (Get Started with Win32 and C++)](https://docs.microsoft.com/en-us/windows/win32/learnwin32/window-messages)
>
> [About Messages and Message Queues](https://docs.microsoft.com/en-us/windows/win32/winmsg/about-messages-and-message-queues)

## Overview

一个包含GUI的应用需要处理来自用户和操作系统的事件。Windows采用传递消息的模型，OS将**消息**传递给应用**窗口**，消息往往与一些**数据**关联，例如鼠标相关的消息与鼠标当前位置相关联。对于每个窗口，有相应的**window procedure**，接收并处理消息。

一个应用程序要接收的消息成千上万，同时，一个应用程序可能对应多个窗口。Windows通过**消息循环（message loop）**，将一个消息分配给对应的窗口。对于创建一个应用窗口的线程而言，Windows为其准备一个**消息队列**，通过`GetMessage` API 获取队首的消息。通过`TranslateMessage` 和`DispatchMessage`来转义消息，以及调用窗口的window procedure函数。一个典型的消息循环为：

```c++
MSG msg = { };
while (GetMessage(&msg, NULL, 0, 0) > 0)
{
    TranslateMessage(&msg);
    DispatchMessage(&msg);
}
```

上述消息是放入队列内的，通过post message方法，还有些消息是不进入队列，操作系统直接调用`window procedure`，这些消息是通过send message方法。

Key Points:

- message and windows

- window procedure
- message loop
- message queue
- send and post message

