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

## Shell Programming

### What is the meaning of "#! /bin/sh"?

> [What is the use/meaning of “#!/bin/sh” in shell scripting?](https://stackoverflow.com/questions/8777190/what-is-the-use-meaning-of-bin-sh-in-shell-scripting)
>
> [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix))

Tells the system that this file is a set of commands to be fed to the command interpreter indicated.

### Shebang for zsh, and logical and absolute path for shebang.

> [How does /usr/bin/env work in a Linux shebang line?](https://stackoverflow.com/questions/43793040/how-does-usr-bin-env-work-in-a-linux-shebang-line)
>
> [Why is it better to use “#!/usr/bin/env NAME” instead of “#!/path/to/NAME” as my shebang?](https://unix.stackexchange.com/questions/29608/why-is-it-better-to-use-usr-bin-env-name-instead-of-path-to-name-as-my?newreg=07f60b7398b94fcaabbf6571498cb7d7)

```shell
#! /usr/bin/env zsh
```

### How to execute a bash/zsh script

1. Use `chmod` to give the script execution privilege.
2. In the terminal: `./bash_name.sh`

### How to call bash function?

> [How to call bash functions](https://superuser.com/questions/106272/how-to-call-bash-functions)
>
> [bash functions](https://linuxize.com/post/bash-functions/)

The `source` command can read and execute commands from the file. See more information in [source ref](https://linuxize.com/post/bash-source-command/). So, if I wrote a function:

```shell
#! /usr/bin/env zsh
marco(){
    pwd > current_dir.txt
}
```

In the terminal:

```shell
source marco.sh; marco
```

To call it from another bash script:

```shell
#! /usr/bin/env zsh
source marco.sh
marco
```

### What is /dev/null

> [What is /dev/null 2>&1?](https://stackoverflow.com/questions/10508843/what-is-dev-null-21)

For example:

```shell
#!/bin/bash  
/etc/apf/apf -f >> /dev/null 2>&1
```

Step 1: `>>` redirect outputs to pseudo devices which means discarding them.

Step 2: `2>&1`: Whenever you execute a program, the operating system always opens three files, standard input, standard output, and standard error. `2>&1`redirect the error information to stdout.

Total: don't output anything even the error information.

### What is the difference between sh and bash?

> [Difference between sh and bash](https://stackoverflow.com/questions/5725296/difference-between-sh-and-bash)
>
> [Terminal, shell, and bash](https://medium.com/@krish.raghuram/terminal-shell-and-bash-3e76218c8865#id_token=eyJhbGciOiJSUzI1NiIsImtpZCI6IjFiZjhhODRkM2VjZDc3ZTlmMmFkNWYwNmZmZDI2MDcwMWRkMDZkOTAiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJuYmYiOjE2MjY0OTk4NDksImF1ZCI6IjIxNjI5NjAzNTgzNC1rMWs2cWUwNjBzMnRwMmEyamFtNGxqZGNtczAwc3R0Zy5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsInN1YiI6IjExNTc3NDc2MTk2MTkwMzgwNTQ0NiIsImVtYWlsIjoiZGVyZWtsdTE5OTYwMTE2QGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJhenAiOiIyMTYyOTYwMzU4MzQtazFrNnFlMDYwczJ0cDJhMmphbTRsamRjbXMwMHN0dGcuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJuYW1lIjoiWXVlIEx1IiwicGljdHVyZSI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS9hL0FBVFhBSnhvbnFTUDJmSzU0eURKQ012YXcwWTBzcjBzRzFTejJmNTlqVGMyPXM5Ni1jIiwiZ2l2ZW5fbmFtZSI6Ill1ZSIsImZhbWlseV9uYW1lIjoiTHUiLCJpYXQiOjE2MjY1MDAxNDksImV4cCI6MTYyNjUwMzc0OSwianRpIjoiZWY0MDNjNDk1NTdiY2MzZWM2OTQ2ZTY1OWI4ZDBmMmY2NTU1OTdjZSJ9.Ne8l2MnhxQ6DbeVVc6_m-7THCBnaOA0CmIWJGUIFOAOY0sfQnLHdx4kRb2ezr-wbphuwxOBMitBnH7hmxfoLGlXKGYhky2qCAOuQLBxgRps1IRydEMkeIBrypCtSEdqaJ5XXZZkUULehloo20pmrcqsQACgQbrnuC4lQvzRJxjOrc22_pzFABQGr5txSYCdW9xyDrSnPnGAEQMQdjs4GdZ6sCiQD32B7_yNZx3ilHIxo4D3a8foADi1ugFIwCTPbrD56PCDv04TCvTP5oKR4Auf3EFYeuNNAiZPKs7cFV3BLtwJ8PfAJYxbnLOZYqkntgcByo13FfbkPpeEURpIuNw)

### Shortcuts for bash

https://levelup.gitconnected.com/15-keyboard-shortcuts-that-advanced-linux-bash-users-always-use-661b340d5a8e

### Difference between so many bash/zsh files

https://shreevatsa.wordpress.com/2008/03/30/zshbash-startup-files-loading-order-bashrc-zshrc-etc/

### Curly braces around shell variables

> [When do we need curly braces around shell variables?](https://stackoverflow.com/questions/8748831/when-do-we-need-curly-braces-around-shell-variables)

It is useful when I want to expand the variable names

```bash
"${foo}bar"
```



## Command Lines

### Copy multiple files to another folder

```
$ cp /home/ankur/folder/{file{1,2},xyz,abc} /home/ankur/dest
```

### Copy a directory into another one

```
$ cp -R <source_folder> <destination_folder>
```

### Rename/move a folder

```
$ mv <source_directory> <target_directory>
```

### Get current date information

`$ date`

### Print the output of commands or variables

`$ echo <command_name>`

### Find the directory of a command

`$ which <command_name>`

### Return to the last-in directory

`$ cd -`

### Input and output

- `< file_name`:从文件输入

  `> file_name`:输出到文件

  `>> file_name`: append to a file

### Change the access control lists of files/directories

`chmod o+w <file_name>`

More information is in this [wiki](https://wiki.jikexueyuan.com/project/unix/file-permission.html)

### Find command

- `find [path] [options] [actions]`

  Locate all the md files in current directory:

  `find . -name '*.md'`

  find and xargs: find all the md files and zip them:

  `find . -name '*.md' -print0 | xargs -0 zip markdown.zip`

  More info:

  [how do I zip/unzip on the unix and linux](https://unix.stackexchange.com/questions/6596/how-do-i-zip-unzip-on-the-unix-command-line)

  [handle file names containing spaces when use xargs](https://stackoverflow.com/questions/16758525/make-xargs-handle-filenames-that-contain-spaces)

  [find command](https://shapeshed.com/unix-xargs/)

### Move files based on their extensions

```bash
mv *.{mp3,ogg,wav} ../../Music
```

### Grep a keyword and get certain lines before/after it

> [How do you grep a file and get the next 5 lines](https://stackoverflow.com/questions/19274127/how-do-you-grep-a-file-and-get-the-next-5-lines/19274215)

```bash
grep -A 5 'a-word' <file>
```

### How to use tmux

> [Gentle Guide to Get Started With tmux](https://pragmaticpineapple.com/gentle-guide-to-get-started-with-tmux/)
>
> [How to close a tmux session](https://superuser.com/questions/777269/how-to-close-a-tmux-session)

Session-Window-Pane

