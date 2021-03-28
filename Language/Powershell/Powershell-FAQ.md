# Powershell-FAQ

> daily problems I met, and the resolutions

#### I wrote a function in visual studio code, how to use it?

I want to achieve Linux `touch` command using Powershell, and use it in my windows laptop. Referring to [this post in superuser](https://superuser.com/questions/502374/equivalent-of-linux-touch-to-create-an-empty-file-with-powershell), I wrote this:

```powershell
# touch-file.ps1
function SET-FILE {
    param (
        [string] $file
    )
    if($null -eq $file) {
        throw "No filename supplied"
    }
    if(Test-Path $file)
    {
        (Get-ChildItem $file).LastWriteTime = Get-Date
    }
    else
    {
        Write-Output $null > $file
    }
}
```

However, when I opened ps command window, and type:`PS >touch-file.ps1`, there is no response.

After searching on the web, I got [this post](https://community.spiceworks.com/topic/1959279-no-output-on-powershell-script-get-remote-logon-status) and [MSDOC-about_scripts](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_scripts?view=powershell-7.1). So I changed the script to:

```powershell
# touch-file.ps1
param (
	[string] $file
)
function SET-FILE {
    if($null -eq $file) {
        throw "No filename supplied"
    }
    if(Test-Path $file)
    {
        (Get-ChildItem $file).LastWriteTime = Get-Date
    }
    else
    {
        Write-Output $null > $file
    }
}

SET-FILE $file
```

Run: `PS >touch-file.ps1 -file "test.md"`, it works fine.

And I continued to think that everytime I wanted to make a new file, I needed type the name of the script, which seemed very inconvenient. How can I use `SET-FILE` function directly in command line?

[This post](https://stackoverflow.com/questions/6016436/in-powershell-how-do-i-define-a-function-in-a-file-and-call-it-from-the-powersh) saved my time, use _modules_ in powershell and import it, I can use function directly. This contains these steps:

```
1. Get-Module -listavailable to get the modules path
2. In modules' directory (I choose ps7), create a folder of which the name should be the same with the script.
3. Rename the script to xx.psm1 indicating this script is a module.
4. Get-Module -listavailable again, and if three steps above is done right, touch-file can be seen in the output list.
5. Import-Module touch-file
6. SET-FILE can now be used.
```

Whether using module is the best choice? I need learn more on powershell.