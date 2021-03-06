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
    
      (The **Full** parameter is a **switch parameter**. A parameter that doesn't require a value is called a switch parameter. )
    
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
    
      **Name** is a **positional parameter** and it's being used positionally in that example. This means the value can be specified without specifying the parameter name
    
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

-  what is properties and methods?

  A **property** is a characteristic about an item. Your drivers license has a property called eye color and the most common values for that property are blue and brown. A **method** is an action that can be taken on an item.

- The [Get-Service](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-service?view=powershell-7.1) cmdlet gets **objects**  that represent the services on a computer, including running and stopped services.  Example:

  ```powershell
  Get-Service -Name w32time
  
  Status   Name               DisplayName
  ------   ----               -----------
  Running  w32time            Windows Time
  ```

  Status, Name, and DisplayName are examples of properties.

  Select-Object cmdlet can be used to determine what properties you want to show

  ```powershell
  Get-Service -Name w32time | Select-Object -Property *
  Get-Service -Name w32time | Select-Object -Property Status, Name, DisplayName, ServiceType
  ```

  

- [Get-Member](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-member?view=powershell-7.1): discover what **objects, properties, and methods**  are available for commands <Gets the properties and methods of objects.\> ; `Get-Member` function displays what types of object was returned. Use this type and `Get-Command` to find commands that accept that type of **objects** as input. Example:

  ````powershell
  Get-Service -Name w32time | Get-Member
  Get-Command -ParameterType ServiceController
  ````

  

- > I rarely find myself using methods: A better option is to use a cmdlet to perform the action if one exists. But one of the benefits of using a cmdlet is that many times **the cmdlet offers additional functionality that isn't available with a method.** In the previous example, the PassThru parameter was used. This causes a cmdlet that doesn't normally produce output, to produce output. 

  Example:

  ```powershell
  Get-Service -Name w32time | Start-Service -PassThru
  ```

  If a command does not produce output, it can't be piped to Get-Member. 

- Active Directory (skipped).

  - Run as administrator in PowerShell: 

```
PS> Start-Process powershell -Verb runAs
```

#### Pipeline

- Many programming and scripting languages require a semicolon at the end of each line. While they can be used that way in PowerShell, it's **not recommended** because they're not needed. JUST PIPE SYMBOL

  ```powershell
  Get-Service |
    Where-Object CanPauseAndContinue -eq $true |
      Select-Object -Property *
  ```

  

- **Filtering left**: the orders of commands matter.

- Which parameters of one command accept some certain types of input? When a parameter accepts pipeline input by both property name and by value, it always tries **by value** first. If **by value** fails, then it tries **by property name**. **By value** is a little misleading, prefer to call it **by type**. -Confused

- In PowerShell, you should always use single quotes instead of double quotes unless the contents of the quoted string contains a variable that needs to be expanded to its actual value. 

- **Create a custom object**. Example: The contents of the CustomObject variable is a PSCustomObject object type and it contains a property named Name.

  ```powershell
  $CustomObject = [pscustomobject]@{
   Name = 'w32time'
   }
  ```

  

- In lineuping properties, Select-Object can be used to **rename (modify) a property**.

```
$CustomObject | 
  Select-Object -Property @{name='Name';expression={$_.Service}} | 
    Stop-Service
```

- How to use a parameter that does not accept pipeline input?

```powershell
# save the display name for a couple of Windows services into a text
'Background Intelligent Transfer Service', 'Windows Time' |
Out-File -FilePath $env:TEMP\services.txt

Stop-Service -DisplayName (Get-Content -Path $env:TEMP\services.txt)
```

- PowerShellGet: PowerShellGet is a PowerShell **module** that contains commands for discovering, installing, publishing, and updating PowerShell modules (and other artifacts) **to or from a NuGet repository**.

- Find-Module: find a module in the [PowerShell Gallery](https://www.powershellgallery.com/). And to install the module, pipe the commands to Install-Module:

  ```powershell
  Find-Module -Name MrToolkit | Install-Module
  ```

  

#### Formatting, aliases, providers, comparison

- `Format-List` and `Format-Table` formatting the outputs. ( **produce format objects**);

  Example:

  ```powershell
  Get-Service -Name w32time | Format-List | Get-Member
  ```

  

- Get-Alias:

  Example:

  ```powershell
  # find alias
  Get-Alias -Name gcm
  # find alias for a command
  Get-Alias -Definition Get-Command, Get-Member
  ```

  

- A **provider**  in PowerShell is an **interface** that allows **file system**  like access to a datastore.( `Get-PSProvider`) ; The actual drives that these providers use to expose their datastore can be determined with the `Get-PSDrive` cmdlet. (skip)

- Comparison Operators table:

  <img src="./images/comparison-operator-table.PNG" alt="Comparison Operator Table" style="zoom:50%;" />

  - > All of the operators listed in the Table are case-insensitive. Place a c in front of the operator listed in the Table to make it case-sensitive. For example, -ceq is the case-sensitive version of the -eq comparison operator.

#### Flow

- `ForEach-Object` : iterate through items in a pipeline.

  Example:

  ```powershell
  'ActiveDirectory', 'SQLServer' |
     ForEach-Object {Get-Command -Module $_} |
       Group-Object -Property ModuleName -NoElement |
           Sort-Object -Property Count -Descending
  ```

- When using the `foreach` keyword, you must store all of the items in memory before iterating through them

  Example:

  ```powershell
  $ComputerName = 'DC01', 'WEB01'
  foreach ($Computer in $ComputerName) {
    Get-ADComputer -Identity $Computer
  }
  ```

- for loop

  ```powershell
  for ($i = 1; $i -lt 5; $i++){...}
  ```

- do-until loop

  ```powershell
  do{...}until(...)
  ```

- while loop

  ```powershell
  while(...){}
  ```

- key word: break, continue, Return

  