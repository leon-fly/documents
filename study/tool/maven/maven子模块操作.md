---
date: "2018-01-01"
draft: false
lastmod: "2018-01-01"
publishdate: "2018-01-01"
tags:
- tool
- maven
title: maven子模块操作
---
| version  | updated by  | update at | remark |
|:-------------: |:---------------:| -------------:|-------------:|
| v1.0      | LeonWang |         20180926 | Create

示例：

> mvn clean compile -pl 子模块名称 -am

参数pl制定子模块，am参数指定包含依赖编译