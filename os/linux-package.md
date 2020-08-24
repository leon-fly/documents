---
date: "2020-08-23"
draft: false
lastmod: "2020-08-23"
publishdate: "2020-08-23"
tags:
- os
- linux
title: linux包管理
---

# linux包管理

linux发行版下有两大主流：Debian(ubuntu是其派生)和Fedora（centOS和RedHat是其派生）。

Debian的包管理文件为.deb,底层工具dpkg,上层工具apt-get,aptitude

Fedora的包管理文件为.rpm.底层工具rpm,上层工具yum

(PS:macOS包管理文件为.dmg，上层工具brew)



## 1. debian软件管理常用命令

### dpkg

* 安装

  > dpkg --install package_file

* 更新

  > dpkg --install package_file 与安装相同

* 卸载

  > dpkg --deinstall package_file

* 查看软件状态(是否安装了)

  > dpkg --status package_name

* 列出所安装的软件包

  > dpkg --list

### apt-get

* 安装：

  > apt-get update; apt-get install package-name

* 更新

  > apt-get update/upgrade

* 卸载

  > apt-get remove package_name

* 查看软件状态

* 查看软件包信息

  > apt-cache show package_name



## 2. fedora软件管理

### rpm

* 安装

  > rpm -i package_file

* 更新

  > rpm -U package_file

* 卸载

  > rpm -e package_file

* 查看软件安装状态

  > rpm -q package_name

* 列出所安装的软件包清单

  > rpm -qa

### yum

* 安装

  > yum install package_file

* 更新

  > yum update

* 卸载

  > Yum erase package_name

* 查看软件包信息

  > yum info package_name



