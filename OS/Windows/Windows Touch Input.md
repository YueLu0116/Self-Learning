# Windows Touch Input (quick notes)

## Basic Procedures

1. Test the capabilities of the input digitizer.
2. Register to receive Windows Touch messages.
3. Handle the messages.

### Test Capabilities

> https://docs.microsoft.com/en-us/windows/win32/wintouch/getting-started-with-multi-touch-messages#testing-the-capabilities-of-the-input-digitizer

Use [GetSystemMetrics](https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getsystemmetrics)

```cpp
// test for touch
int value = GetSystemMetrics(SM_DIGITIZER);
if (value & NID_READY){ /* stack ready */}
if (value  & NID_MULTI_INPUT){
    /* digitizer is multitouch */ 
    MessageBoxW(hWnd, L"Multitouch found", L"IsMulti!", MB_OK);
}
if (value & NID_INTEGRATED_TOUCH){ /* Integrated touch */}
```

### Registry

> https://docs.microsoft.com/en-us/windows/win32/wintouch/getting-started-with-multi-touch-messages#registering-to-receive-windows-touch-input

Before receiving Windows Touch input, **applications** must first register to receive Windows Touch input.

Use [RegisterTouchWindow](https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-registertouchwindow)

### Message Handling

> https://docs.microsoft.com/en-us/windows/win32/wintouch/getting-started-with-multi-touch-messages#handling-windows-touch-messages

Key functions and ds

[TOUCHINPUT](https://docs.microsoft.com/en-us/windows/win32/api/winuser/ns-winuser-touchinput)

> Now when a user touches the screen, the positions that he or she is touching will be stored in the points array. The **dwID** member of the [**TOUCHINPUT**](https://docs.microsoft.com/en-us/windows/win32/api/winuser/ns-winuser-touchinput) structure stores an identifier that will be hardware dependent.

[GetTouchInputInfo](https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-gettouchinputinfo)

[CloseTouchInputHandle](https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-closetouchinputhandle)



