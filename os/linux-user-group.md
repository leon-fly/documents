---
date: "2020-08-23"
draft: false
lastmod: "2020-08-23"
publishdate: "2020-08-23"
tags:
- os
- linux
title: linux用户及组
---

# Linux-用户及组

## 1. 组操作

* 添加组，groupadd 组名, 如添加一个ops的组：

  > groupadd ops

* 查看用户所属组，groups 用户名，如查看ops所属组：

  > groups ops

* 添加用户到组，group



## 2. 用户操作

* 添加一个用户， useradd -g 组名 用户名，如新增一个用户ops，并将其加入组：

  > useradd -g ops  ops

* root用户对普通用户修改密码, 如为ops用户修改密码

  > passwd ops