---
date: "2015-03-15"
draft: false
lastmod: "2015-03-15"
publishdate: "2015-03-15"
tags:
- os
- linux
title: linux环境变量配置及使用
---
# linux环境变量配置

## 1. 配置
**导入变量命令：**
> export 变量名=变量值

通过命令直接配置后在重启后变量丢失，如果要永久性保留需要进行如下操作：

1. 在用户根目录的.profile中将导入命令添加
2. 使添加的命令生效
    > source .profile

## 2. 使用

> $变量名

如 echo $path 将打印path变量
