---
date: "2018-01-01"
draft: false
lastmod: "2018-01-01"
publishdate: "2018-01-01"
tags:
- corejava
- concurrent
title: java-synchronized 
---
<!-- TOC -->

- [1. 线程同步](#1-线程同步)
- [2. 线程同步方式一：synchroinzed](#2-线程同步方式一synchroinzed)
    - [2.1. synchroinzed用在方法上](#21-synchroinzed用在方法上)
    - [2.2. synchronized锁定代码块](#22-synchronized锁定代码块)
    - [2.3. 锁升级](#23-锁升级)
- [3. 线程同步方式二： lock](#3-线程同步方式二-lock)

<!-- /TOC -->
# 1. 线程同步
简单的理解，当多个线程同时操作一个资源时，可能因为读写逻辑被其他线程操作干扰造成非预期的结果，这就是线程同步同步出现的背景。那么线程同步具体做什么？再简单的理解即通过Lock或synchroinzed等方式使共享资源被多个线程有序的一个个的访问。
# 2. 线程同步方式一：synchroinzed

## 2.1. synchroinzed用在方法上
* 当synchroinzed作用在静态方法上时，锁定的是class类，静态同步方法竞争的时class对象锁，所有静态同步方法只有一个方法可以执行。
* 当synchroinzed作用在非静态方法上时，锁定的是实例，非静态同步方法竞争的是实例对象的锁，所有非静态同步方法只有一个可以执行。
## 2.2. synchronized锁定代码块
* synchronized(this)
* synchronized(Object sharedSource)

## 2.3. 锁升级
**jvm中的锁根据重量级由低到高分为：**
    1. 无锁
    2. 偏向锁
    3. 轻量级锁
    4. 重量级锁

**synchronized操作的锁定jvm在加锁时按照以上顺序来升级，可以根据实际情况对锁升级进行控制。**
[更多信息](../../analysis/analysis-jvm.md)


# 3. 线程同步方式二： lock
