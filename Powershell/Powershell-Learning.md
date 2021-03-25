# Powershell Learning

> Reference: [MSDN Docs on Powershell](https://docs.microsoft.com/en-us/powershell/scripting/overview?view=powershell-7.1)

#### What is Powershell ?

- PowerShell is a cross-platform task automation and configuration management framework, consisting of a **command-line shell and scripting language** . Unlike most shells, which accept and return text, PowerShell is built on top of the .NET Common Language Runtime (CLR), and accepts and returns .NET **objects** . 
- Difference between Windows Powershell and Powershell 7.1.

#### Getting Started with Powershell

- Check and change the Powershell execution policy;

#### Helping Systems

- cmdlets: **Compiled commands**  in PowerShell are called cmdlets. Cmdlet is pronounced "command-let" (not CMD-let). Cmdlets names have the form of singular **"Verb-Noun"**  commands to make them easily discoverable. 
- Three core cmdlets:
  - Get-Help:
    - Use and locate commands;
    - Six sets of parameters;
    - Use help which provides one page of help at a time instead of using Get-Help;
    - Support wildcards, such as help about_* ;
  - Get-Command
    - To locate commands;
    - Accept wildcards;

#### Objects, properties, and methods

- The Get-Service cmdlet gets **objects**  that represent the services on a computer, including running and stopped services. 

- Get-Member:discover what **objects, properties, and methods**  are available for commands;

- I rarely find myself using methods, but they're something you need to be aware of. There are times that you'll come across a Get-* command without a corresponding command to modify that item.

- Active Directory (

  skipped

  ).

  - Run as administrator in PowerShell: 

```
PS> Start-Process powershell -Verb runAs
```

#### Pipeline

- Many programming and scripting languages require a semicolon at the end of each line. While they can be used that way in PowerShell, it's not recommended because they're not needed.
- Filtering left: the orders of commands matter.
- Which parameters of one command accept some certain types of input? When a parameter accepts pipeline input by both property name and by value, it always tries **by value** first. If **by value** fails, then it tries **by property name**. **By value** is a little misleading, prefer to call it **by type**.
- In PowerShell, you should always use single quotes instead of double quotes unless the contents of the quoted string contains a variable that needs to be expanded to its actual value. 
- In lineuping properties, Select-Object can be used to rename (modify) a property.

```
$CustomObject | 
  Select-Object -Property @{name='Name';expression={$_.Service}} | 
    Stop-Service
```

#### Formatting, aliases, providers, comparison

- Format-List and Format-Table formatting the outputs. ( produce format objects);
- Get-Alias -Name gcm, gm and Get-Alias -Definition Get-Command, Get-Member ;
- A **provider**  in PowerShell is an interface that allows **file system**  like access to a datastore.( Get-PSProvider and Get-PSDrive );
- [Comparison operators](https://docs.microsoft.com/en-us/powershell/scripting/learn/ps101/05-formatting-aliases-providers-comparison?view=powershell-7.1#comparison-operators);

#### Flow