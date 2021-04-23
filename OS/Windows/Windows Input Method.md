# Windows Input Method

- **windows api 相关**

> [Input Method Manager - Win32 apps](https://docs.microsoft.com/en-us/windows/win32/intl/input-method-manager)

1. framework

   IME (input method editor) --> IMM (input method manager) --> applications

2. what can imm do?

   > allows the IME to monitor a user's keystrokes, anticipates the characters the user might want, and presents a list of candidate characters from which to choose.

3. status of the composition string

   - The composition string is the current text in the composition window. 

   - Tracked by IME, this status contains attribute information, clause information, typing information, and cursor position. The application can retrieve the composition status by using the [**ImmGetCompositionString**](https://docs.microsoft.com/en-us/windows/desktop/api/Imm/nf-imm-immgetcompositionstringa) function.

     1. The attribute information: an array of 8-bit values that specifies the status of characters in the composition string;

     2. The clause information: an array of 32-bit values that specifies the positions of the clauses in the composition string. The array includes one value for each clause and a final value that specifies the length of the full string.

        > For example, if a string has two clauses, the clause information has three values: the first value is 0, the second value is the offset of the second clause, and the third value is the length of the string. For Unicode, the position of a clause is counted in Unicode characters, and the length of a string is the size in Unicode characters.

     3. The typing information: a null-terminated character string representing the characters that the user enters at the keyboard.

     4. The cursor position: 

        > indicating the position of the cursor relative to the characters in the composition string. The value is the offset, in bytes, from the beginning of the string. If this value is 0, the cursor is immediately before the first character in the string. If the value is equal to the length of the string, the cursor is immediately after the last character. If the value is 1, the cursor is not present.

4. IME messages
   - **the operating system** sends the **[WM_IME_SETCONTEXT](https://docs.microsoft.com/en-us/windows/win32/intl/wm-ime-setcontext)** message **to the application**  when a window is activated. **IME-unaware applications**  pass these messages to the [DefWindowProc](https://docs.microsoft.com/en-us/windows/desktop/api/winuser/nf-winuser-defwindowproca) function, which sends them to the corresponding default **IME window** . **IME-aware applications**  either process these messages or forward them to their own IME windows.
   - change the position of a composition window, by using the **[WM_IME_CONTROL](https://docs.microsoft.com/en-us/windows/win32/intl/wm-ime-control)** message. 
   - The IME notifies the application about **changes to the composition string**  by using the **[WM_IME_COMPOSITION](https://docs.microsoft.com/en-us/windows/win32/intl/wm-ime-composition)** message.
   - about **general changes**  to the status of the IME windows by sending the **[WM_IME_NOTIFY](https://docs.microsoft.com/en-us/windows/win32/intl/wm-ime-notify)** message.

5. Input context:  It contains information about the status of the IME and is used by IME windows. By default, the operating system creates and assigns an input context to each thread. Within the thread, this default input context is a shared resource and is associated with each newly created window.

6. Three windows: The status (indicates that the IME is open and provides the user with the means to set the conversion modes),  composition (appears when the user enters text and, depending on the conversion mode, either displays the text as entered or displays converted text), and candidates windows (appears in conjunction with the composition window) form the user interface for the IME. The IME sends the composed characters to the IME-aware application in the form of **[WM_IME_CHAR](https://docs.microsoft.com/en-us/windows/win32/intl/wm-ime-char)** or **[WM_IME_COMPOSITION](https://docs.microsoft.com/en-us/windows/win32/intl/wm-ime-composition)**/GCS_RESULT messages. 
7. Unicode handling: Two issues are involved with the IMM and its handling of Unicode. The first issue is that the Unicode versions of IMM functions retrieve **the size of a buffer in bytes** instead of 16-bit Unicode characters. The second issue is that the IMM normally retrieves Unicode characters (instead of DBCS characters) in the [**WM_CHAR**](https://docs.microsoft.com/en-us/windows/win32/inputdev/wm-char) and [**WM_IME_CHAR**](https://docs.microsoft.com/en-us/windows/win32/intl/wm-ime-char) messages. (?)

---



