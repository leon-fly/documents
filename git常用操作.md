# git常用操作命令

> init

初始化一个仓库

> clone  

克隆远程仓库

> merge

合并分支，合并后时间线是并行的。

> rebase

线性合并分支，合并后的分支成一条时间线，这是与merge的唯一不同，看起来提交清晰。

> fetch

（仅）从远程下载未同步的内容。

```txt
git fetch #下载所有远程分支到本地。
git fetch origin <place> #下载指定的远程分支，更新所有本地不存在的提交，如果本地没有该分支就创建该远程分支的本地映射分支
git fetch origin <source>:<target> #下载指定的远程分支到指定的本地的远程分支的映射分支上
git fetch origin :target #创建本地分支
```

> pull

从远程下载未同步的内容并合并到本地分支中。

``` txt
git pull
git pull origin <source>:<target>
git pull origin :<target>
```

> push

提交到远程分支

``` txt
git push #使用当前分支默认配置推送远程
git push origin place  #切换到本地target分支，将该分支的所有提交推送到远程分支
git push origin <source>:<target> #将本地的source分支(或分支上的某次提交)提交推送到远程target分支，如果远程没有该分支则创建
git push origin :<target> #删除远程target分支
```

说明：

参考fetch,数据反向操作

> HEAD

用于指向当前操作

> tag

git标签，用于定格某个时间点的某次提交状态

```txt
git tag tagName commitId
```

> cherry-pick

用于选择性合并提交到当前分支。

``` txt
git cherry-pic c1 c2 c3 ...
```
