---
date: "2018-01-01"
draft: false
lastmod: "2018-01-01"
publishdate: "2018-01-01"
tags:
- db
- mysql
title: mysql事务及隔离级别
---

## 1. 事务
事务的ACID特性：
* 原子性 atomicity
* 一致性 consistency
* 隔离性 isolation
* 持久性 durability

## 2. mysql事务隔离级别
* 读未提交 READ UNCOMMITTED
* 读已提交 READ COMMITTED
* 可重复读 REPEATABLE READ （mysql默认隔离级别）
* 串行化 SERIALIZABLE

## 3. 事务不同隔离级别中的问题

|      -_^     | 脏读        | 不可重复读 | 幻读 |
| --------- | :----------:|:---------:|:-----:| 
| 读未提交      | ✓         | ✓        |   ✓    | 
| 读已提交      | x         | ✓        |    ✓   |
| 重复读       | x         | x        |     ✓(新版本？中已通过MVCC解决)  |
| 串行化       | x         | x       |    x   | 

![transaction-issue](../../../picture/transaction-issue.png)



