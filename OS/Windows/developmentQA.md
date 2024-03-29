# Windows development

## Windows core

### 关于命名锁

> https://docs.microsoft.com/en-us/windows/win32/api/synchapi/nf-synchapi-createmutexa

Two or more processes can call CreateMutex to create the same named mutex. The first process actually creates the mutex, and subsequent processes with sufficient access rights simply open a handle to the existing mutex. 

### About window station

TODO

### 【COM】Replacement of QueryInterface when using Com

> [ComPtr from DirectXTK wiki](https://github.com/Microsoft/DirectXTK/wiki/ComPtr)

```c++
ComPtr<ID3D11Device> device;
hr = D3D11CreateDevice( ..., device.GetAddressOf(), ... );
if (SUCCEEDED(hr))
   // device created
ComPtr<ID3D11Device1> device1;
hr = device.As( &device1 );
```

### Why we need pdb files under release mode?

> [Release generating .pdb files, why?](https://stackoverflow.com/questions/5457095/release-generating-pdb-files-why)
>
> [What is the best way to distribute .Net binaries and PDBs?](https://stackoverflow.com/questions/225488/what-is-the-best-way-to-distribute-net-binaries-and-pdbs)

## API programming

### Write callback using a class member function

> [How can I make a callback function a member of my C++ class?](https://devblogs.microsoft.com/oldnewthing/20140127-00/?p=1963)

```cpp
class CountWindows
{
public:
  int CountThem();
private:
  static BOOL CALLBACK StaticWndEnumProc(HWND hwnd, LPARAM lParam);
  BOOL WndEnumProc(HWND hwnd);
  int m_count;
};
BOOL CountWindows::StaticWndEnumProc(HWND hwnd, LPARAM lParam)
{
   CountWindows *pThis = reinterpret_cast<CountWindows* >(lParam);
   return pThis->WndEnumProc(hwnd);
}
BOOL CountWindows::WndEnumProc(HWND hwnd)
{
    m_count++;
    return TRUE;
}
int CountWindows::CountThem()
{
  m_count = 0;
  EnumWindows(StaticWndEnumProc, reinterpret_cast<LPARAM>(this));
  return m_count;
}
```

The `WNDENUMPROC` is declared as a so-called *free function*, but member functions are not free. Neither are *function objects* (also known as *functors*) so you can’t use a `boost::function` as a window procedure either. The reason is that member functions and functors need to have a hidden `this` parameter, but free functions do not have a hidden `this` parameter.

On the other hand, static methods are free functions. They can get away with it because they don’t have a hidden `this` parameter either.

### How to get a window title bar's height? (and menu bar?)

> [Windows: Getting a window title bar's height](https://stackoverflow.com/questions/56549853/windows-getting-a-window-title-bars-height)

Get window's borders

```cpp
RECT wrect;
GetWindowRect( hwnd, &wrect );
RECT crect;
GetClientRect( hwnd, &crect );
POINT lefttop = { crect.left, crect.top }; // Practicaly both are 0
ClientToScreen( hwnd, &lefttop );
POINT rightbottom = { crect.right, crect.bottom };
ClientToScreen( hwnd, &rightbottom );

int left_border = lefttop.x - wrect.left; // Windows 10: includes transparent part
int right_border = wrect.right - rightbottom.x; // As above
int bottom_border = wrect.bottom - rightbottom.y; // As above
int top_border_with_title_bar = lefttop.y - wrect.top;
```

Get menu bar

```cpp
GetSystemMetrics(SM_CYMENU);
```

### How to capture screen in Windows?

> [Fastest method of screen capturing on Windows](https://stackoverflow.com/questions/5069104/fastest-method-of-screen-capturing-on-windows)
>
> [Chromium win/screen_capture_win_directx](https://chromium.googlesource.com/external/webrtc/+/b4c7b8365d9ed11099b4c5bdcc4eeab33923cd9c/webrtc/modules/desktop_capture/win/screen_capturer_win_directx.cc)

### What is exp files? What are the differences between exp and lib files?

> [What is the use of .exp and what is the difference between .lib and .dll?](https://stackoverflow.com/questions/2727020/what-is-the-use-of-exp-and-what-is-the-difference-between-lib-and-dll)

> A .exp file is an export file -- basically just about the same as a .lib file. It's used (at least primarily) when you have a circular dependency. For example, assume you have a DLL that acts as a plug-in for an executable. The executable supplies some exported functions for use by plug-in DLLs, but also needs to be able to call some functions in the plug-ins as well (e.g. to load and initialize a plug-in).
>
> The DLL won't link until the executable is built to provide a .lib file -- but the executable won't link until the DLL is built to provide a .lib file. To break the dependency, you run the linker against the executable, which fails (because it can't find a .lib file for the DLL), but *will* produce a .exp file. You then link the DLL against the .exp file for the executable. You can then re-run link to produce the executable, using the .lib file for the DLL.

### How to tell if a window is a parent window (except the desktop)?

Through spy++, we can see that every window is the child of desktop.

```c++
::GetAncestor(activedWnd, GA_PARENT) == ::GetDesktopWindow()
```

### How to create an application window on the second screen?

> [Win32程序多显示器情况下显示窗口](https://blog.csdn.net/csharpupdown/article/details/69939050)

```c++
// in App.h
class App
{
public:
    App() 
    {
        mMonitorInfoVec.clear();
        mMonitorInfoVec.reserve(::GetSystemMetrics(SM_CMONITORS));
    }
    // ...
private:
    static BOOL CALLBACK StaticMonitorEnumProc(HMONITOR hMonitor, HDC hdcMonitor, LPRECT lprcMonitor, LPARAM lParam);
    BOOL MonitorEnumProc(HMONITOR hMonitor, HDC hdcMonitor, LPRECT lprcMonitor);
    
    struct ALLMONITORINFO {
        HMONITOR mHmonitor;
        RECT mRect;
        bool mIsPrimary;
    };
    std::vector<ALLMONITORINFO> mMonitorInfoVec;
    // ...
}

// in App.cpp
BOOL App::StaticMonitorEnumProc(HMONITOR hMonitor, HDC hdcMonitor, LPRECT lprcMonitor, LPARAM lParam)
{
    PlayerApp* pthis = reinterpret_cast<PlayerApp*>(lParam);
    return pthis->MonitorEnumProc(hMonitor, hdcMonitor, lprcMonitor);
}

BOOL App::MonitorEnumProc(HMONITOR hMonitor, HDC hdcMonitor, LPRECT lprcMonitor)
{
    ALLMONITORINFO monitorInfo;
    monitorInfo.mHmonitor = hMonitor;
    monitorInfo.mRect = *lprcMonitor;
    HMONITOR priMonitor = ::MonitorFromWindow(nullptr, MONITOR_DEFAULTTOPRIMARY);
    if (priMonitor == hMonitor)
    {
        monitorInfo.mIsPrimary = true;
    }
    else
    {
        monitorInfo.mIsPrimary = false;
    }
    mMonitorInfoVec.push_back(monitorInfo);
    return TRUE;
}

// app initialization: create the window
HRESULT App::Initialize(HINSTANCE hInstance) 
{
    long width = 0, height = 0, startX = 0, startY = 0;
    //******
    ::EnumDisplayMonitors(nullptr, nullptr, StaticMonitorEnumProc, reinterpret_cast<LPARAM>(this));
    // only one monitor
    if (mMonitorInfoVec.size() == 1)
    {
        RECT rect = mMonitorInfoVec[0].mRect;
        width = rect.right - rect.left;
        height = rect.bottom - rect.top;
        startX = rect.left;
        startY = rect.top;
    }
    else // second monitor
    {
        for (size_t mid = 0; mid < mMonitorInfoVec.size(); mid++)
        {
            if (!mMonitorInfoVec[mid].mIsPrimary)
            {
                RECT rect = mMonitorInfoVec[mid].mRect;
                width = rect.right - rect.left;
                height = rect.bottom - rect.top;
                startX = rect.left;
                startY = rect.top;
                break;
            }
        }
    }
    hWnd = CreateWindow(
        szWindowClass, szTitle,
        WS_OVERLAPPEDWINDOW | WS_VISIBLE,
        startX, startY, width, height,
        NULL, NULL,
        hInstance,
        this);
}
```

### What is the Z-order of windows?

> [Window features](https://docs.microsoft.com/en-us/windows/win32/winmsg/window-features)

The z-order of a window indicates the window's position in a stack of overlapping windows. This window stack is oriented along an imaginary axis, the z-axis, extending outward from the screen. The window at the top of the z-order overlaps all other windows. 

### What is a top-level window?

> [What exactly is a top-level window in win32 programming?](https://stackoverflow.com/questions/18244379/what-exactly-is-a-top-level-window-in-win32-programming)

A window that has no parent, or **whose parent is the desktop window**, is called a top-level window.

### How to change wide char to char?

> https://blog.csdn.net/lightspear/article/details/54695123

Use `WideCharToMultiByte` twice

```c++
std::string WcahrToChar(const wchar_t* wp, size_t encode = CP_ACP)
{
    std::string str;
    int len = ::WideCharToMultiByte(encode, 0, wp, ::wcslen(wp), nullptr, 0, nullptr, nullptr);
    char* mChar = new(std::nothrow)char[len + 1];
    ::WideCharToMultiByte(encode, 0, wp, ::wcslen(wp), mChar, len, nullptr, nullptr);
    mChar[len] = '\0';
    str = mChar;
    delete[]mChar;
    return str;
}
```

### 【UI】How to create a progress bar and make it begin to move?

> [How to Use Progress Bar Controls](https://docs.microsoft.com/en-us/windows/win32/controls/create-progress-bar-controls)

### Details about WM_CREATE

> [WM_CREATE message](https://docs.microsoft.com/en-us/windows/win32/winmsg/wm-create)

The message is sent before `CreateWindow` returns. The window procedure of the new window receives this message after the window is created, but **before the window becomes visible**.

### 【UI】How to tell which button is clicked?

> [winapi BN_CLICKED how to identify which button was clicked?](https://stackoverflow.com/questions/20640330/winapi-bn-clicked-how-to-identify-which-button-was-clicked)

Create the button: note the menu id

```c++
HWND buttonCtrl = ::CreateWindow(L"Button", L"Start Unity",
                                 WS_VISIBLE | WS_CHILD | BS_PUSHBUTTON,
                                 btx, bty, btWidth, btHeight,
                                 parentHwnd, (HMENU)IDB_START, (HINSTANCE)GetWindowLongPtr(parentHwnd, GWLP_HINSTANCE), nullptr);
```

In WndProc:

```c++
case WM_COMMAND:
{
    switch (HIWORD(wParam))
    {
        case BN_CLICKED:
            {
                if (LOWORD(wParam) == IDB_START)
                {
                    // ...
                }
                else if (LOWORD(wParam) == IDB_RESTORE)
                {
                    // ...
                }
                break;
            }
    }
    break;
}
```

### How to hide the Windows system task bar through Windows api?

```c++
static HWND hShellWnd = ::FindWindow(_T("Shell_TrayWnd"), NULL);
ShowWindow(hShellWnd, SW_HIDE);
```

Note: the `ShowWindow` is very powerful.

### How to kill a process by name?

> [How to kill processes by name? (Win32 API)](https://stackoverflow.com/questions/7956519/how-to-kill-processes-by-name-win32-api)

```c++
void KillProcess(const wchar_t* exeName)
{
    HANDLE hSnapShot = CreateToolhelp32Snapshot(TH32CS_SNAPALL, NULL);
    PROCESSENTRY32 pEntry;
    pEntry.dwSize = sizeof(pEntry);
    BOOL hRes = Process32First(hSnapShot, &pEntry);
    while (hRes)
    {
        if (_wcsicmp(pEntry.szExeFile, exeName) == 0)
        {
            HANDLE hProcess = OpenProcess(PROCESS_TERMINATE, 0,
                (DWORD)pEntry.th32ProcessID);
            if (hProcess != NULL)
            {
                TerminateProcess(hProcess, 9);
                CloseHandle(hProcess);
            }
        }
        hRes = Process32Next(hSnapShot, &pEntry);
    }
    CloseHandle(hSnapShot);
}
```

### 【UI】How to create a window at full screen?

> [Win32: full-screen and hiding taskbar](https://stackoverflow.com/questions/2382464/win32-full-screen-and-hiding-taskbar)
>
> [chrominum](https://chromium.googlesource.com/chromium/src/+/lkgr/ui/views/win/fullscreen_handler.cc)

```c++
Microsoft::WRL::ComPtr<ITaskbarList2> ptaskBarList;

void SetFullScreen(HWND hwnd)
{
    LONG style = ::GetWindowLong(hwnd, GWL_STYLE);
    LONG exStyle = ::GetWindowLong(hwnd, GWL_EXSTYLE);
    RECT rect;
    ::GetWindowRect(hwnd, &rect);
    // Set new window style and size.
    SetWindowLong(hwnd, GWL_STYLE,
        style & ~(WS_CAPTION | WS_THICKFRAME));
    SetWindowLong(
        hwnd, GWL_EXSTYLE,
        exStyle & ~(WS_EX_DLGMODALFRAME | WS_EX_WINDOWEDGE |
            WS_EX_CLIENTEDGE | WS_EX_STATICEDGE));

    // On expand, if we're given a window_rect, grow to it, otherwise do
    // not resize.
    MONITORINFO monitorInfo;
    monitorInfo.cbSize = sizeof(monitorInfo);
    GetMonitorInfo(MonitorFromWindow(hwnd, MONITOR_DEFAULTTONEAREST), &monitorInfo);
    SetWindowPos(hwnd, nullptr, monitorInfo.rcMonitor.left, monitorInfo.rcMonitor.top,
        monitorInfo.rcMonitor.right - monitorInfo.rcMonitor.left, 
        monitorInfo.rcMonitor.bottom - monitorInfo.rcMonitor.top,
        SWP_NOZORDER | SWP_NOACTIVATE | SWP_FRAMECHANGED);
    if (!ptaskBarList)
    {
        HRESULT hr =
            ::CoCreateInstance(CLSID_TaskbarList, nullptr, CLSCTX_INPROC_SERVER,
                IID_PPV_ARGS(&ptaskBarList));
        if (SUCCEEDED(hr) && FAILED(ptaskBarList->HrInit()))
            ptaskBarList = nullptr;
    }
    if (ptaskBarList)
    {
        ptaskBarList->MarkFullscreenWindow(hwnd, TRUE);
    }
}
```

### Details of `QueryPerformanceCounter`

> https://www.cnblogs.com/luckyraye/p/7410131.html

TODO

### How to get the running process

> [Taking a Snapshot and Viewing Processes](https://docs.microsoft.com/en-us/windows/win32/toolhelp/taking-a-snapshot-and-viewing-processes)

Similar to question [How to kill a process by name?](#How-to-kill-a-process-by-name?)

### 【UI】How to draw texts on a window?

> [c++ win32 output a text](https://stackoverflow.com/questions/3432457/c-win32-output-a-text)

In `WM_PAINT` message handler, use `TextOut` api (or `DrawText` api). `SetTextColor` can set the texts' color and `SelectObject` combined with `CreateFont` can set the texts' font.

```c++
case WM_PAINT:
{
    PAINTSTRUCT paint;
    LPCWSTR hintStartMsg = L"测试1";
    LPCWSTR hintRestoretMsg = L"测试2";
    HDC hdc = ::BeginPaint(gWindowHandle, &paint);
    auto hFont = CreateFont(38, 15, 0, 0, FW_BOLD, FALSE, FALSE, FALSE, CHINESEBIG5_CHARSET, OUT_OUTLINE_PRECIS,
                            CLIP_DEFAULT_PRECIS, CLEARTYPE_QUALITY, VARIABLE_PITCH, TEXT("Times New Roman"));
    SelectObject(hdc, hFont);
    ::SetTextColor(hdc, 0x000000FF);  // red
    ::TextOut(hdc, 10, 10, hintStartMsg, wcslen(hintStartMsg));
    ::TextOut(hdc, 10, 50, hintRestoretMsg, wcslen(hintRestoretMsg));
    ::EndPaint(gWindowHandle, &paint);
    break;
}
```

## Command lines

### CMD Cheet sheet

http://xstarcd.github.io/wiki/windows/windows_cmd_syntax.html

### How to use cd command in windows cl

> [Using cd command in Windows command line, can't navigate to D](https://superuser.com/questions/135214/using-cd-command-in-windows-command-line-cant-navigate-to-d)

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

### How to get the bios or mainboard serial numbers?

use command line:

`wmic bios get serialnumber`

BTW: wmic = Windows Management Instrumentation Command-line

### 检测系统重启时间

> [How can I find out when Windows was last restarted?](https://superuser.com/questions/523726/how-can-i-find-out-when-windows-was-last-restarted)

`wmic os get lastbootuptime`

### 远程桌面连接时，触控测试失效

tldr:  

```
query session
tscon rdp-tcp#71 /dest:console
```

关于windows rdp的其他参考文章：
[UI自动化关闭远程桌面连接，鼠标键盘失效的解决方案](https://www.pianshen.com/article/79591080857/) 

[如何关闭远程桌面后仍处于可交互状态](https://zvv.me/z/1478.html)

## Utils

### Use Windbg to analyze dump files, minimum steps

> https://www.windowscentral.com/how-open-and-analyze-dump-error-files-windows-10

1. What is the dump files?

   On Windows 10, every time there is a crash, the system creates a "dump" file containing the memory information at the time of the error. The ".dmp" file includes the stop error message, list of the drivers loaded at the time of the problem, and kernel, processor, and processes details, as well as other pieces of information depending on the type of dump file you are using.

2. How to get the dump files?

   Use the "procexp64.exe" tool.

3. How to open and analyze dump files?

   Use [Windbg (preview version)](https://docs.microsoft.com/en-us/windows-hardware/drivers/debugger/debugging-using-windbg-preview)

### How to find out which process is occupying a file?

use sysinternals tools "procexp64.exe"

reference: https://superuser.com/a/117908

### How to remotely debug use dbgview?

> Reference MSDN: https://blog.csdn.net/u012308586/article/details/93002901

### Autolog when remotely connect to a computer

> https://blog.csdn.net/qq_39019865/article/details/106684267

1. 运行（Ctrl+R）：gpedit.msc，打开本地组策略编辑器
2. 计算机配置>>>管理模板>>>系统>>>凭据分配
3. 在右侧找到>>>允许分配保存的凭据用于仅 NTLM 服务器身份验证
4. 右键编辑，点击“已启用”;
5. 点击“将服务器添加到列表：显示”;
6. 在将服务器添加到列表中添加允许保存凭据的服务器名称和类型，如 dcList item.contoso.com上的终端服务器，即“TERMSRV/dc.contoso.com”。当然也可以输入“TERMSRV/*”允许保存所有计算机的远程终端凭据。
7. 最后在CMD命令行执行gpupdate /force 使修改的组策略生效，即可！

## Errors

### Main function is unresolved

[Error LNK2019 unresolved external symbol _main referenced in function “int __cdecl invoke_main(void)” (?invoke_main@@YAHXZ)](https://stackoverflow.com/questions/33400777/error-lnk2019-unresolved-external-symbol-main-referenced-in-function-int-cde)

console or window?:

Check project configuration. **Linker**->**System**->**SubSystem** should be **Windows**.
