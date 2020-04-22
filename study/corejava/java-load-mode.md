---
date: "2018-01-01"
draft: false
lastmod: "2018-01-01"
publishdate: "2018-01-01"
tags:
- corejava
title: java类加载策略 - 双亲委派
---

## 1. java类加载策略
![双亲委派四级加载](../../picture/java-load.png)

### 1.1. 为什么使用双亲委派？
* 避免重复加载
* 安全考虑

## 2. 如何自定义CLassLoader
自定义ClassLoader，重写方法findCLass；

## 3. 如何打破双亲委派模式
自定义ClassLoader，重写findClass及loadClass。双亲委派的


TODO 详解