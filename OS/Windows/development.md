# Windows development

## Errors

### Main function is unresolved

[Error LNK2019 unresolved external symbol _main referenced in function “int __cdecl invoke_main(void)” (?invoke_main@@YAHXZ)](https://stackoverflow.com/questions/33400777/error-lnk2019-unresolved-external-symbol-main-referenced-in-function-int-cde)

console or window?:

Check project configuration. **Linker**->**System**->**SubSystem** should be **Windows**.

