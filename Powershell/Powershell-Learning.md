# Powershell Learning

> Reference: [MSDN Docs on Powershell](https://docs.microsoft.com/en-us/powershell/scripting/overview?view=powershell-7.1)

#### What is Powershell ?

- PowerShell is a cross-platform task automation and configuration management framework, consisting of a **command-line shell and scripting language** . Unlike most shells, which accept and return text, PowerShell is built on top of the .NET Common Language Runtime (CLR), and accepts and returns .NET **objects** . 
- Difference between Windows Powershell and Powershell 7.1.

#### Getting Started with Powershell

- Run as admin

- Check and change the Powershell execution policy;

  - what is execution policy?

    It's designed to prevent a user from unknowingly running a script. Two types: Remote Signed & Restricted; Regardless of the execution policy setting, any PowerShell command can be run interactively. The execution policy only affects commands running in a **script**. 

  - Related codes:

    ```powershell
    Get-ExecutionPolicy
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
    ```

- Related stuffs

  - [about_Automatic_Variables](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_automatic_variables): Describes variables that store state information for PowerShell. These variables are created and maintained by PowerShell.
  - [about_Hash_Tables](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_hash_tables): Describes how to create, use, and sort hash tables in PowerShell.
  - [about_Execution_Policies](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies): Describes the PowerShell execution policies and explains how to manage them.

#### Helping Systems

- cmdlets: **Compiled commands**  in PowerShell are called cmdlets. Cmdlet is pronounced "command-let" (not CMD-let). Cmdlets names have the form of singular **"Verb-Noun"**  commands to make them easily discoverable. 
- Three core cmdlets:
  - Get-Help:
    - How to use and locate commands (can be used to find commands that don't have help topics); Example:
    
      ```powershell
      Get-Help -Name Get-Help
      Get-Help -Name Get-Help -Full
      ```
    
      (The **Full** parameter is a switch parameter. A parameter that doesn't require a value is called a switch parameter. )
    
    - Six sets of parameters;
    
      - NAME
      - SYNOPSIS
      - SYNTAX
      - DESCRIPTION
      - PARAMETERS
      - INPUTS
      - OUTPUTS
      - NOTES
      - EXAMPLES
      - RELATED LINKS
    
    - Use `help` which provides one page of help at a time instead of using Get-Help:
    
      ```powershell
      Get-Help -Name Get-Help -Full
      help -Name Get-Help -Full
      help Get-Help -Full
      ```
    
      `Help` is a function that **pipes** `Get-Help` to a function named `more` ;  
    
      **Name** is a positional parameter and it's being used positionally in that example. This means the value can be specified without specifying the parameter name
    
      ```powershell
      help Get-Help -Parameter Name
      ```
    
      Don't display the entire help topic for a command:
    
      ```powershell
      Get-Help -Name Get-Command -Full
      Get-Help -Name Get-Command -Detailed
      Get-Help -Name Get-Command -Examples
      Get-Help -Name Get-Command -Online
      Get-Help -Name Get-Command -Parameter Noun
      Get-Help -Name Get-Command -ShowWindow
      ```
    
      or
    
      ```powershell
      help Get-Command -Full | Out-GridView
      ```
    
      
    
    - Support wildcards
    
      ```powershell
      help *process*
      help process
      ```
    
      
  - Get-Command
    - To **locate** commands;
    
       use the `Get-Command` cmdlet to determine what commands exist for working with processes
    
      ```powershell
      Get-Command -Noun Process
      ```
    
      
    
    - Accept wildcards;
    
    - Periodically update the help system
    
      ```powershell
      Update-Help
      ```
    
    - Learn a PowerShell command a day
    
      ```powershell
      Get-Command | Get-Random | Get-Help -Full
      ```
    
      
    
  - Get-Member

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