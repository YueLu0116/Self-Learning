# Windows Q&A

## How to use cd command in windows cl

> [Using cd command in Windows command line, can't navigate to D:\](https://superuser.com/questions/135214/using-cd-command-in-windows-command-line-cant-navigate-to-d)

> ```
> C:\Users\coneslayer>e:
> 
> E:\>c:
> 
> C:\Users\coneslayer>cd e:\software
> 
> C:\Users\coneslayer>e:
> 
> e:\Software>
> ```

## CMD Cheet sheet

http://xstarcd.github.io/wiki/windows/windows_cmd_syntax.html

## Use Windbg to analyze dump files

> https://www.windowscentral.com/how-open-and-analyze-dump-error-files-windows-10

1. What is the dump files?

   On Windows 10, every time there is a crash, the system creates a "dump" file containing the memory information at the time of the error. The ".dmp" file includes the stop error message, list of the drivers loaded at the time of the problem, and kernel, processor, and processes details, as well as other pieces of information depending on the type of dump file you are using.

2. How to get the dump files?

   Use the "procexp64.exe" tool.

3. How to open and analyze dump files?

   Use [Windbg (preview version)](https://docs.microsoft.com/en-us/windows-hardware/drivers/debugger/debugging-using-windbg-preview)

## How to get the bios or mainboard serial numbers?

use command line:

`wmic bios get serialnumber`

BTW: wmic = Windows Management Instrumentation Command-line

## How to find out which process is occupying a file?

use sysinternals tools "procexp64.exe"

reference: https://superuser.com/a/117908

## Autolog when remotely connect to a computer

> https://blog.csdn.net/qq_39019865/article/details/106684267

1. 运行（Ctrl+R）：gpedit.msc，打开本地组策略编辑器
2. 计算机配置>>>管理模板>>>系统>>>凭据分配
3. 在右侧找到>>>允许分配保存的凭据用于仅 NTLM 服务器身份验证
4. 右键编辑，点击“已启用”;
5. 点击“将服务器添加到列表：显示”;
6. 在将服务器添加到列表中添加允许保存凭据的服务器名称和类型，如 dcList item.contoso.com上的终端服务器，即“TERMSRV/dc.contoso.com”。当然也可以输入“TERMSRV/*”允许保存所有计算机的远程终端凭据。
7. 最后在CMD命令行执行gpupdate /force 使修改的组策略生效，即可！

## 远程桌面连接时，触控测试失效
tldr:  
```
query session
tscon rdp-tcp#71 /dest:console
```
关于windows rdp的其他参考文章：
[UI自动化关闭远程桌面连接，鼠标键盘失效的解决方案](https://www.pianshen.com/article/79591080857/)  
[如何关闭远程桌面后仍处于可交互状态](https://zvv.me/z/1478.html)

## About dll

### dll main可能导致的死锁

> [dll best practices](https://docs.microsoft.com/en-us/windows/win32/dlls/dynamic-link-library-best-practices)
>
> You cannot call any function in DllMain that directly or indirectly tries to acquire the loader lock. Otherwise, you will introduce the possibility that your application deadlocks or crashes.

### dll 动态加载

> https://docs.microsoft.com/en-us/windows/win32/dlls/about-dynamic-link-libraries
>
> In run-time dynamic linking, a module uses the **LoadLibrary or LoadLibraryEx** function to load the DLL at run time. After the DLL is loaded, the module calls the **GetProcAddress function** to get the addresses of the exported DLL functions. The module calls the exported DLL functions using **the function pointers** returned by GetProcAddress. This eliminates the need for an import library.

### dll动态加载引用计数

>https://docs.microsoft.com/en-us/windows/win32/dlls/run-time-dynamic-linking
>
>If the call to LoadLibrary or LoadLibraryEx specifies a DLL whose code is **already mapped into the virtual address space of the calling process**, the function simply **returns a handle to the DLL and increments the DLL reference count.** Note that two DLLs that have the same base file name and extension but are found in different directories are not considered to be the same DLL.

### dll入口函数只会在加载后启动的线程内调用

> https://docs.microsoft.com/en-us/windows/win32/dlls/run-time-dynamic-linking 
>
> The entry-point is not called for threads that existed before LoadLibrary or LoadLibraryEx is called.

### import library: lib file

> https://docs.microsoft.com/en-us/windows/win32/dlls/dynamic-link-library-creation
>
> An import library (.lib) file contains information the linker needs to resolve external references to exported DLL functions, so the system can locate the specified DLL and exported DLL functions at run time. You can create an import library for your DLL when you build your DLL.

