# Ansible quick notes

> Based on the official [documents](https://docs.ansible.com/ansible/latest/user_guide/intro_getting_started.html#intro-getting-started)

## Basic procedure

- selects machines to execute against from **inventory**
- **connects** to those machines (or network devices, or other managed nodes), usually over SSH (This step has been done by 'Data')
- **copies** one or more modules to the remote machines and starts **execution** there.

## Three elements

1. inventory
2. ad hoc commands.
3. playbooks

## Some details

### Create a basic inventory

under: `/etc/ansible/hosts`, add remote systems into it:

```
192.0.2.50
aserver.example.org
bserver.example.org
```

### Connections

Use SSH to connect all the nodes in the inventory.

### Executions

Ansible transfers the modules required by the commands or playbook to the remote machine(s) for execution.s

Use ping module to ping all the nodes:

```
$ ansible all -m ping
```

Run **playbooks**:

- Write [yaml](https://docs.ansible.com/ansible/latest/reference_appendices/YAMLSyntax.html) scripts. For example:

  ```yaml
  ---
  - name: My task
    hosts: all
    tasks:
       - name: Leaving a mark
         command: "touch /tmp/ansible_was_here"
  ```

- Run this playbooks:

  ```
  $ ansible-playbook mytask.yaml
  ```

## More on Playbook

> https://docs.ansible.com/ansible/latest/user_guide/index.html#writing-tasks-plays-and-playbooks
>
> https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html

Different situations. Check when using.

> - Executing tasks with elevated privileges or as a different user with [become](https://docs.ansible.com/ansible/latest/user_guide/become.html#become)
> - Repeating a task once for each item in a list with [loops](https://docs.ansible.com/ansible/latest/user_guide/playbooks_loops.html#playbooks-loops)
> - Executing tasks on a different machine with [delegation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_delegation.html#playbooks-delegation)
> - Running tasks only when certain conditions apply with [conditionals](https://docs.ansible.com/ansible/latest/user_guide/playbooks_conditionals.html#playbooks-conditionals) and evaluating conditions with [tests](https://docs.ansible.com/ansible/latest/user_guide/playbooks_tests.html#playbooks-tests)
> - Grouping a set of tasks together with [blocks](https://docs.ansible.com/ansible/latest/user_guide/playbooks_blocks.html#playbooks-blocks)
> - Running tasks only when something has changed with [handlers](https://docs.ansible.com/ansible/latest/user_guide/playbooks_handlers.html#handlers)
> - Changing the way Ansible [handles failures](https://docs.ansible.com/ansible/latest/user_guide/playbooks_error_handling.html#playbooks-error-handling)
> - Setting remote [environment values](https://docs.ansible.com/ansible/latest/user_guide/playbooks_environment.html#playbooks-environment)

## More on inventory

> https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html#intro-inventory

Inventory is an `ini` file. A basic ini file under `/etc/ansible/hosts` is like:

```
mail.example.com

[webservers]
foo.example.com
bar.example.com

[dbservers]
one.example.com
two.example.com
three.example.com
```

[group name] ...

**About groups**:

> There are two default groups: `all` and `ungrouped`. The `all` group contains every host. The `ungrouped` group contains all hosts that don’t have another group aside from `all`. Every host will always belong to at least 2 groups (`all` and `ungrouped` or `all` and some other group).

**range of hosts:**

```
[webservers]
www[01:50].example.com

# stride
[webservers]
www[01:50:2].example.com
```

**variables in the inventory:**

```
[atlanta]
host1
host2

[atlanta:vars]
ntp_server=ntp.atlanta.example.com
proxy=proxy.atlanta.example.com
```

