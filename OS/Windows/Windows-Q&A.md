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