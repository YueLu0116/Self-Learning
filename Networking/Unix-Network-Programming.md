# Unix Network Programming Quick Notes

## Chapter 5

> 本章实现了TCP客户服务器程序，重点在于如何处理边界条件，例如服务端主机崩溃等。服务侧是通过fork子进程来处理多个客户连接请求。

### Command line

1. [netstat](https://man7.org/linux/man-pages/man8/netstat.8.html) command: Print network connections, routing tables, interface statistics, masquerade connections, and multicast memberships. This program is mostly obsolete.  Replacement for netstat is ss. Replacement for netstat -r is ip route.  Replacement for netstat -i is ip -s link.  Replacement for netstat -g is ip maddr. Under windows OS, there is also a [netstat](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/netstat) command.

2. [ps](https://man7.org/linux/man-pages/man1/ps.1.html) report a snapshot of the current processes. ps displays information about a selection of the active processes.  If you want a repetitive update of the selection and the displayed information, use top instead.

3. [grep](https://www.geeksforgeeks.org/grep-command-in-unixlinux/) The grep filter searches a file for a particular pattern of characters, and displays all lines that contain that pattern. Syntax:

   `grep [options] pattern [files]`

4. [tcpdump](https://www.tcpdump.org/): a powerful command-line packet analyzer;

### 正常终止时需要注意什么？

- fork出的子进程终止时，会给服务端父进程发送SIGCHILD消息，如果父进程没有处理该消息，则子进程变为僵尸程序（zombie）；

### Unix下信号处理机制

- 通过调用`sigaction` 函数制定信号处理方式：
  1. 提供一个函数，“登记”在该信号上；
  2. 忽略该信号；
  3. 默认的处理方式；

- 信号处理时的阻塞是指阻塞某个信号，防止在阻塞期间递交，反操作是解阻塞。如果同一个信号在阻塞期间产生了多次，那么信号解阻塞后只会提交一次，即Unix下信号时非排队的；

- `wait` or `waitpid`: wait函数的作用是自动分析当前进程的子进程是否已经退出，如果是，则返回该进程id以及状态，waitpid则可以提供想要等待的进程id以及options；
- 类似于accept这种慢系统调用处理的基本规则是，阻塞在该函数的进程的信号处理函数返回时，慢系统调用可能返回一个EINTER错误；

### 服务器进程终止可能带来的问题

- 客户端可能同时阻塞在两个描述符上（fgets and socket），select and poll 解决该问题；

### 服务器主机崩溃或重启

- 客户端如何不主动发送数据也能检测到主机的崩溃？keepalive

### 处理服务器主机关机

- select and poll