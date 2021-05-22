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
