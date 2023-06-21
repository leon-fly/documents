---
date: "2018-01-01"
draft: false
lastmod: "2018-01-01"
publishdate: "2018-01-01"
tags:
- tool
- git
title: git常用操作
---
超棒网站：
[git-flow](https://danielkummer.github.io/git-flow-cheatsheet/index.zh_CN.html)
[git learning](https://learngitbranching.js.org/?demo)

# init

初始化一个仓库。
当从远程创建一个仓库后，可以通过git clone克隆下来并通过git init初始化该仓库，提交并push上去

# clone  

克隆远程仓库

```txt
git clone 仓库地址
```

# branch

创建分支

```txt
git branch #展示当前分支状况
git branch branchName #创建分支
git branch -f branchName HEAD~num #强制branch回退到(以当前HEAD指向为基础的)num个提交
git branch -d branchName 删除本地分支
git push origin :branchName 删除远程分支
```

# checkout

检出分支

```txt
git checkout branchNmae #切换到分支branchName
git checkout -b branchName #创建branch并切换到该分支
git checkout branchName^ #HEAD指向branch的父节点。
```

# merge

合并分支，合并后时间线是并行的。

```txt
git merge branchName #将branch合并到当前分支
```

# rebase

线性合并分支，合并后的分支成一条时间线，这是与merge的唯一不同，看起来提交清晰。

```txt
git rebase branchName  #设置父节点为新指定的分支。
git rebase -i commitNode #交互式调整提交内容,不要随意删除某个提交，删除后不可恢复
```

场景：
发现某个提交需要小的修改（内容或者commit的message）如何做？

```txt
1. git rebase -i HEAD~indexNum
2. 找到要修改的某次提交移动到最底部，保存进行rebase。
3. 修改
4. git commit --amend
5. git rebase -i HEAD~indexNum
6. 恢复原提交顺序，保存进行rebase
```

# fetch

（仅）从远程下载未同步的内容。

```txt
git fetch #下载所有远程分支到本地。
git fetch origin <place> #下载指定的远程分支，更新所有本地不存在的提交，如果本地没有该分支就创建该远程分支的本地映射分支
git fetch origin <source>:<target> #下载指定的远程分支到指定的本地的远程分支的映射分支上
git fetch origin :target #创建本地分支
```

# pull

从远程下载未同步的内容并合并到本地分支中。

``` txt
git pull
git pull origin <source>:<target>
git pull origin :<target>
```

# push

提交到远程分支

``` txt
git push #使用当前分支默认配置推送远程
git push origin place  #切换到本地target分支，将该分支的所有提交推送到远程分支
git push origin <source>:<target> #将本地的source分支(或分支上的某次提交)提交推送到远程target分支，如果远程没有该分支则创建
git push origin :<target> #删除远程target分支
```

说明：

参考fetch,数据反向操作

# HEAD

HEAD总是指向当前分支上的最近一次提交记录，运行git命令，HEAD会调整指向。可以在分支上使用引用符号^和~手动设置HEAD的指向。

```txt
git checkout master^ #head指向master的父节点（master的上一次提交）,每加一个^往上一层。
git checkout HEAD^ #以当前HEAD指向向父节点移动

git checkout master~3 #head指向master的上三级父节点
```

# reset

撤销提交，主要用于撤销本地提交

```txt
git reset commitId/Head表达方式  #本地分支提交重置到某次提交，该次提交之后的提交从提交历史移除，不暂存处理

git reset --soft commitId/Head表达方式 #本地分支提交重置到某次提交，该次提交之后的代码均为待提交状态。
git reset --mixed commitId/Head表达方式 #默认的参数，见无参数的reset
git reset --hard commitId/Head表达方式 #本地分支提交重置到某次提交，该次提交之后的代码均删除。

```

# revert

回滚操作，用于远程回滚。

```txt
git revert commitId/Head表达式 #回滚到某次提交，原来的提交历史不变，新增一次提交
```

# tag

git标签，用于定格某个时间点的某次提交状态

```txt
git tag tagName commitId
```

# cherry-pick

用于选择性合并其他分支的提交到当前分支。

``` txt
git cherry-pic c1 c2 c3 ...
```

# remote

查看远程仓库信息

```txt
git remote show origin  #origin为仓库名
```

# stash

本地贮藏 git stash --help

1. 选择要stash的文件.一般在版本控制中的文件进行stash不需要这个步骤，如果要把新增的文件放入stash需要用改命令先加入版本控制中

    > git add 文件列表       或者    git  add .  

2. 保存save

    > git stash save 'this is stash message'

3. 使用贮藏pop或apply + index

    > git stash pop|apply  stash@{0}

4. 查看贮藏列表list

    > git stash list

5. 查看某一贮藏中的更改内容 show + index

    > git show stash@{0}

6. 删除贮藏 drop + index

    > git drop stash@{0}


# Large File 处理

1. 忽略单次拉取操作

```
GIT_LFS_SKIP_SMUDGE=1 git clone SERVER-REPOSITORY
```

​		Windows 需要使用两条命令

```
set GIT_LFS_SKIP_SMUDGE=1  
git clone SERVER-REPOSITORY
```

2. 全局配置忽略拉取大文件操作

```
git config --global filter.lfs.smudge "git-lfs smudge --skip -- %f"
git config --global filter.lfs.process "git-lfs filter-process --skip"
git clone SERVER-REPOSITORY
```

3. 恢复拉取大文件配置

```
git config --global filter.lfs.smudge "git-lfs smudge -- %f"
git config --global filter.lfs.process "git-lfs filter-process"
```

# log

## 用来显示提交日志

[log参数传送门](https://git-scm.com/docs/git-log)

> git log

## 场景应用 - 代码统计

最近一周内代码统计

```
git log --format='%aN' | sort -u | while read name; do echo -en "$name\t"; git log --author="$name" --pretty=tformat: --since=1.weeks --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }' -; done;
```

时间段内的代码统计

```
git log --format='%aN' | sort -u | while read name; do echo -en "$name\t"; git log --author="$name" --pretty=tformat: --since ==2019-10-01 --until=2019-12-31 --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }' -; done;
```

# 配置

配置用户名

> git config user.name LeonWang   配置当前提交用户名为LeonWang

配置邮箱

> git config user.email leonwang@email.com. 配置当前用户的邮箱为leonwang@email.com.

以上配置均针对当前repository生效，如果想全局生效，需要增加global参数。示例：

> git config --global user.name LeonWang

# 应用

1. 本地删除了文件需要恢复

   > git checkout -- filename

2. 远程出现错误的提交需要回滚

   > git revert 此回滚操作将留下操作记录，推荐做法。
   > git reset 此方式处理比较生硬，git push 使用force参数可提交到远程。此方式处理后原提交记录删除，谨慎使用。
