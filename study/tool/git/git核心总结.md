---
date: "2018-01-01"
draft: false
lastmod: "2018-01-01"
publishdate: "2018-01-01"
tags:
- tool
- git
title: git核心总结
---
# 一、关于本地远程仓库关联

1. 远程和本地一一对应，对应关系可以通过配置设定，包括本地库映射的远程哪个仓库，以及本地分支映射的哪个分支。命令操作时可以添加参数改变这一默认执行方式。

# 二、关于本地仓库

1. 三个概念：
    * Head 这是当前分支版本顶端的别名，也就是在当前分支你最近的一个提交。
    * Index 也被称为staging area，是指一整套即将被下一个提交的文件集合。他也是将成为HEAD的父亲的那个commit
    * Working tree代表你正在工作的那个文件集

    说明：
    
    > 当从远程clone一个库后，本地的Head、Index、Working tree三者一致，当本地修改了文件后 Working >tree 与其他两者出现不一致，当将改动内容add到暂存文件时，working tree与index一致，head与此两者不一致，当commit之后三者重新变一致。这就是git能判断哪些是本地变动，哪些是在暂存中，哪些是未提交的一个原理。

# 三、代码merge的合并策略

## Git Merge

> Fast-forward 是最简单的一种合并策略。

假设当前分支为master, 新开发分支feature/func-1基于master分支创建并进行了提交，在`两个分支间没有分叉`情况下（master在feature/func-1拉取分支后没有新代码合并被合并进去），使用fast-forward策略会将master指向feature/func-1最后一个提交而不会产生新的提交记录。Fast-forward 是 Git 在合并两个没有分叉的分支时的默认行为，如果不想要这种表现，想明确记录下每次的合并，可以使用`git merge --no-ff`。

> Recursive 是 Git 分支合并策略中最重要也是最常用的策略，是 Git 在合并两个有分叉的分支时的默认行为。其算法可以简单描述为：递归寻找路径最短的唯一共同祖先节点，然后以其为 base 节点进行递归三向合并。

## Git Rebase

> git rebase也是一种经常被用来做合并的方法，其与 git merge 的最大区别是，他会更改变更历史对应的 commit 节点.

[参考](https://zhuanlan.zhihu.com/p/192972614)
