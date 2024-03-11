---
date: "2020-08-23"
draft: false
lastmod: "2020-08-23"
publishdate: "2020-08-23"
tags:
- os
- mac
title: 关于HomeBrew
---

# HomeBrew 常用命令

## 关于HomeBrew

[HomeBrew](https://brew.sh/)是Mac上常用的自动化软件安装工具(也可以用于linux)。关于homebrew需要知道的：

* 可以用来安装软件包或着桌面应用（二进制， brew cast）
* 使用HomeBrew安装软件的默认路径, 对于Intel架构是  ***/usr/local/Cellar***，对于ARM架构是 ***/opt/local/Cellar***
* HomeBrew镜像源参考 👉 [HomeBrew镜像源](https://zhuanlan.zhihu.com/p/475756310)

## 常用命令

* 信息查询

  > brew --prefix  查看软件安装路径

  > brew list 查看软件安装清单

  > brew list 包名    查看某软件安装位置

  > brew info 包名  查看软件信息

  > brew deps --installed --tree 以树形形式展示已安装的包的依赖

* 包安装/卸载/更新

  > brew search 包名  查询远程库存在的软件及版本

  > brew outdated 查看哪些包可以更新

  > brew install 包名  安装某软件最新版本，如果需要指定版本则追加 '@版本号', 如 brew install mysql@5.7

  > brew uninstall 包名  卸载软件

  > brew upgrade 包名  软件更新

  > brew pin 包名 阻止包更新

  > brew unpin 包名 恢复包更新

  > brew cleanup 包名 移除老版本

* 软件切换

  > brew switch 包名 版本号

* 服务相关

  > brew services list 获取services列表

  > brew services start/stop/restart serverName，如

  - `brew services start mysql` 启动mysql服务
  - `brew services restart mysql` 重启mysql服务
  - `brew services stop mysql` 停止mysql服务

* 全局命令

  > brew doctor 诊断brew存在的问题

  > brew update  升级home brew

  > brew update-reset 恢复到稳定版本

  > brew upgrade 升级所有软件包

* 应用

  > brew list --cask 查看安装的应用

  > brew install --cask 应用名  安装应用

