# Windows Message Model

> [Window Messages (Get Started with Win32 and C++)](https://docs.microsoft.com/en-us/windows/win32/learnwin32/window-messages)
>
> [About Messages and Message Queues](https://docs.microsoft.com/en-us/windows/win32/winmsg/about-messages-and-message-queues)

## Basic Procedure of Creating a Window

> [Create a traditional Windows Desktop application](https://docs.microsoft.com/en-us/cpp/windows/walkthrough-creating-windows-desktop-applications-cpp?view=msvc-160&viewFallbackFrom=vs-2019)

Use Windows API to create a window:

1. Populate a structer WNDCLASSEXW and register a window class using RegisterClass for subsequent use in calls to the CreateWindow or CreateWindowEx.

   > window class（窗口类）表示一类有共同属性的窗口，例如buttons，虽然每个button的文字等不同，但都会响应用户的点击。创建新窗口前，必须将该窗口“登记”到一个特定的类上。

   ```cpp
   // Register the window class.
   const wchar_t CLASS_NAME[]  = L"Sample Window Class";
   WNDCLASS wc = { };
   wc.lpfnWndProc   = WindowProc;
   wc.hInstance     = hInstance; // the handle to the application instance
   wc.lpszClassName = CLASS_NAME; // a string that identifies the window class
   ```

   > 这里CLASS_NAME在每个进程中应该是唯一的，可以是用户自定义的，也可以是standard Windows controls，例如button。

   ```cpp
   RegisterClass(&wc);
   ```

2. Create-Show-Update a window.

   > The system does not automatically display the main window after creating it; instead, an application must use the ShowWindow function to display the main window. After creating the main window, the application's WinMain function calls ShowWindow, passing it two parameters: a handle to the main window and a flag specifying whether the main window should be minimized or maximized when it is first displayed.

3. Specify a window processing function for the newly created window. 

   > - About WM_PAINT: One important message to handle is the [WM_PAINT](https://docs.microsoft.com/en-us/windows/win32/gdi/wm-paint) message. The application receives the `WM_PAINT` message when part of its displayed window must be updated. The event can occur when a user moves a window in front of your window, then moves it away again. Your application doesn't know when these events occur. Only Windows knows, so it notifies your app with a `WM_PAINT` message.  More information is in: https://docs.microsoft.com/en-us/windows/win32/learnwin32/painting-the-window
   >
   > - About Default Message Handling: If you don't handle a particular message in your window procedure, pass the message parameters directly to the [**DefWindowProc**](https://docs.microsoft.com/en-us/windows/desktop/api/winuser/nf-winuser-defwindowproca) function. This function performs the default action for the message, which varies by message type.

4. Construct a message loop.

   ```cpp
   MSG msg = { };
   while (GetMessage(&msg, NULL, 0, 0))
   {
       TranslateMessage(&msg);
       DispatchMessage(&msg);
   }
   ```

   >  Each time the program calls the [**DispatchMessage**](https://docs.microsoft.com/en-us/windows/desktop/api/winuser/nf-winuser-dispatchmessage) function, it indirectly causes Windows to invoke the WindowProc function, once for each message.

## Overview for Message Model

一个包含GUI的应用需要处理来自(1)用户和(2)操作系统的事件。Windows采用传递消息的模型，OS将**消息**传递给应用**窗口**，消息往往与一些**数据**关联，例如鼠标相关的消息与鼠标当前位置相关联。对于每个窗口，有相应的**window procedure**，接收并处理消息。

一个应用程序要接收的消息成千上万，同时，一个应用程序可能对应多个窗口。Windows通过**消息循环（message loop）**，将一个消息分配给对应的窗口。对于创建一个应用窗口的线程而言，Windows为其准备一个**消息队列**，通过`GetMessage` API 获取队首的消息。通过`TranslateMessage` 和`DispatchMessage`来转义消息，以及调用窗口的window procedure函数。一个典型的消息循环为：

```c++
MSG msg = { };
while (GetMessage(&msg, NULL, 0, 0) > 0)
{
    TranslateMessage(&msg);
    DispatchMessage(&msg);
}
```

上述消息是放入队列内的，通过PostMessage方法，还有些消息是不进入队列，操作系统直接调用`window procedure`，这些消息是通过SendMessage方法。GetMessage检查消息队列，如果没有消息，则挂起，直到有消息才返回，也就是说该方法是同步的，它的异步counterparty是PeekMessage，该方法无论队列里是否有消息都会返回。

Key Points:

- message and windows

- window procedure
- message loop
- message queue
- send and post message

