# Windows development

## Errors

### Main function is unresolved

[Error LNK2019 unresolved external symbol _main referenced in function “int __cdecl invoke_main(void)” (?invoke_main@@YAHXZ)](https://stackoverflow.com/questions/33400777/error-lnk2019-unresolved-external-symbol-main-referenced-in-function-int-cde)

console or window?:

Check project configuration. **Linker**->**System**->**SubSystem** should be **Windows**.

## Windows core

### 关于命名锁

> https://docs.microsoft.com/en-us/windows/win32/api/synchapi/nf-synchapi-createmutexa

Two or more processes can call CreateMutex to create the same named mutex. The first process actually creates the mutex, and subsequent processes with sufficient access rights simply open a handle to the existing mutex. 

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

