# Git FAQ

## How to write .gitignore file?

Reference: [.gitignore](https://git-scm.com/docs/gitignore) in the man pages for git

![how-to-write-gitignore](./images/gitignore-pattern.PNG)

## What does the `fork` mean in github?

Forking is nothing more than a clone on the GitHub server side. I can push and pull from the forked repo.

More info:

[Forking vs. Branching in GitHub](https://stackoverflow.com/questions/3611256/forking-vs-branching-in-github)

## What is `git rebase`?

> [Git Branching - Rebasing](https://git-scm.com/book/en/v2/Git-Branching-Rebasing)

Just like `merge` command, `rebase` also integrate changes from one branch into another. However, git rebase makes the git tree more clean (like a linear history).

```
$ git checkout experiment
$ git rebase maste
```

Used situations:

> Often, you’ll do this to make sure your commits apply cleanly on a remote branch — perhaps in a project to which you’re trying to contribute but that you don’t maintain.

## How to push newly created local branch to a remote branch?

> https://blog.csdn.net/ljj_9/article/details/79386306

1. use `git branch` to check current branch;
2. `git push origin dev_luyue:dev_luyue`

## How to use submodules?

> [Git Tools - Submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules)

1. What can I do with submodules?

   Submodules allow you to keep a Git repository as a subdirectory of another Git repository. 

2. How to add submodules to my git repository?

   `git sumodule add <url>`

3. What is the `.gitmodules` file?

   This is a configuration file that stores the mapping between the project’s URL and the local subdirectory you’ve pulled it into.

4. How to clone a repository with submodules?

   ```
   $ git clone <url-main-repo>
   $ git submodule init
   $ git submodule update
   # or
   $ git clone --recurse-submodules <url-main-repo>
   ```

5. Pulling in upstream changes from the remote submodule repos

   ```
   # go into the submodule's directory
   $ git fetch
   $ git merge origin/master
   # an easier way
   $ git submodule update --remote <submodule-name>
   ```


## How to merge two local branches?

> https://stackoverflow.com/questions/25053697/git-merge-two-local-branches

merge branch B into branch A:

```
git checkout branchA
git merge branchB
```

## What is patch files in git?

> https://stackoverflow.com/questions/8279602/what-is-a-patch-in-git-version-control

illustration:

![patch](./images/patch.png)

Patch describes the change to the contents of a file. And it is what exactly `diff` tell us. For example, apply the patch to file1.txt according to the newly created file2.txt:

```
$ cat file1.txt 
This is line A.
This is line B, or otherwise #2.
$ cat file2.txt 
This is SPARTA.
This is line B, or otherwise #2.
$ diff -u file1.txt file2.txt > changes.patch
$ cat changes.patch 
--- file1.txt   2011-11-26 11:09:38.651010370 -0500
+++ file2.txt   2011-11-26 11:07:13.171010362 -0500
@@ -1,2 +1,2 @@
-This is line A.
+This is SPARTA.
 This is line B, or otherwise #2.
$ patch < changes.patch 
patching file file1.txt
$ cat file1.txt 
This is SPARTA.
This is line B, or otherwise #2.
```

> When talking in terms of git, patch file still means the same thing, but using diff + patch yourself would be a nightmare. For example, you will always have to have two versions of the file (or even the whole repository) checked out in order to compare them. Doesn't sound that good, does it? So git takes care of all of the hard work for you - it compares your local file with what is there in the repository you are working with, and can show it to you as a "diff", or apply that "diff" as a patch aka commit your changes, or even let you apply some patch file that you have already. 

## "Reset, restore and revert" in git

> [What's the difference between Git Revert, Checkout and Reset?](https://stackoverflow.com/questions/8358035/whats-the-difference-between-git-revert-checkout-and-reset)
>
> [Why do I get conflicts when I do git revert?](https://stackoverflow.com/questions/46275070/why-do-i-get-conflicts-when-i-do-git-revert)

Git revert doesn't "take you back to" that commit and pretend that subsequent commits didn't happen. It applies a logical negation of a single commit - and *that commit alone* - leaving subsequent commits in place.

An example in https://stackoverflow.com/a/46275419/11100389

Use `git reset --hard <commit>` on another branch will not affect other branches.

## What is cherry-pick in git?

> [What does cherry-picking a commit with Git mean?](https://stackoverflow.com/questions/9339429/what-does-cherry-picking-a-commit-with-git-mean)

Cherry picking in Git means to choose a commit from one branch and apply it onto another.

```
$ git checkout rel_2.3
$ git cherry-pick dev~2 # commit F, below
```

before:

![before cherry-pick](./images/before-cp.png)

after:

![after cherry-pick](./images/after-cp.png)

