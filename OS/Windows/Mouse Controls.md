# Mouse Controls

> just quick notes
>
> [Taking Advantage of High-Definition Mouse Movement](https://docs.microsoft.com/en-us/windows/win32/dxtecharts/taking-advantage-of-high-dpi-mouse-movement?redirectedfrom=MSDN)

## WM_MOUSEMOVE

- `WM_MOUSEMOVE` is that it is **limited to the screen resolution**. This means that if you move the mouse slightly — but not enough to cause the pointer to move to the next pixel — then no `WM_MOUSEMOVE` message is generated. It is not so good for moving a first-person camera, since the high-definition precision will be lost.

## WM_INPUT

- `WM_INPUT` messages are read directly from the Human Interface Device (HID) stack and reflect high-definition results. The advantage to using WM_INPUT is that your game receives raw data from the mouse at **the lowest level** possible.

## DirectInput

- DirectInput creates a second thread to read WM_INPUT data, and using the DirectInput APIs will add more overhead than simply reading WM_INPUT directly. DirectInput is **only useful for reading data from DirectInput joysticks**; however, if you only need to support the Xbox 360 controller for Windows, use **XInput** instead. Overall, using DirectInput offers **no advantages** when reading data from mouse or keyboard devices, and the use of DirectInput in these scenarios is discouraged.

