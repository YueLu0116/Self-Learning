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

# SET-FILE $file