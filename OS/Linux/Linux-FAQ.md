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

- rename a folder

```
$ mv <source_directory> <target_directory>
```

