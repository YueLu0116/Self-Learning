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
