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
