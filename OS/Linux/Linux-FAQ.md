# Linux FAQ

## Vim

### 粘贴到vim内缩进混乱

需要事先设置粘贴模式：

```
# 设置 粘贴模式
:set paste

# 取消 粘贴模式
:set nopaste
```

## Shell

### What is the meaning of "#! /bin/sh"?

> [What is the use/meaning of “#!/bin/sh” in shell scripting?](https://stackoverflow.com/questions/8777190/what-is-the-use-meaning-of-bin-sh-in-shell-scripting)
>
> [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix))

Tells the system that this file is a set of commands to be fed to the command interpreter indicated.

## Daily Command Line

### June.26th, 2021

- copy multiple files to another folder

```
$ cp /home/ankur/folder/{file{1,2},xyz,abc} /home/ankur/dest
```

- copy a directory into another one

```
$ cp -R <source_folder> <destination_folder>
```

- rename/move a folder

```
$ mv <source_directory> <target_directory>
```

### July. 11th, 2021

- get current date information

  `$ date`

- print the output of commands or variables

  `$ echo <command_name>`

- Find the directory of a command

  `$ which <command_name>`

- Return to the last-in directory

  `$ cd -`

- `< file_name`:从文件输入

  `> file_name`:输出到文件

  `>> file_name`: append to a file

- change the access control lists of files/directories

  `chmod o+w <file_name>`

  More information is in this [wiki](https://wiki.jikexueyuan.com/project/unix/file-permission.html)
