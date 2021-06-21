# Windows下获取输入位置和键盘焦点

> 代码：https://github.com/YueLu0116/IMETest
>
> 工作中小问题提炼

直接使用[GetFocus](https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getfocus)需要窗口和调用线程关联，更实用的方式是：

1. 通过[GetWindowThreadProcessId ](https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getwindowthreadprocessid)获取窗口对应的线程id；
2. 将该id传入[GetGUIThreadInfo](https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getguithreadinfo)中，获取gui information。

使用[GetCaretPos](https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getcaretpos)直接获取焦点位置（目前返回结果均为0,0）。

