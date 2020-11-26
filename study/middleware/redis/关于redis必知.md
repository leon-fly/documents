---
date: "2018-01-01"
draft: false
lastmod: "2018-01-01"
publishdate: "2018-01-01"
tags:
- middleware
- redis
title: 带着问题看redis
---

# 完整了解redis

## 1. redis是什么？与memcache区别？

redis是一个基于内存的key-value数据库，支持持久化。支持以下数据类型的存储：

* String
* List
* Set
* Zset
* hash

## 2. redis的经典应用场景？

## 3. redis的内部实现及架构？

由c语言编写，内部使用了hash表、跳表等

## 4. redis的高可用及扩展怎么做？

方式一：主从+哨兵模式实现高可用

方式二：集群实现扩展

方式三：主从+集群实现高可用和可扩展

[redis扩展及高可用方案](redis扩展及高可用方案)

## 5. redis的持久化怎么做？以及redis到底要不要做持久化？

## 6. 说如何保证redis中的数据都是热点数据？有哪些策略？

redis是基于内存的，也就是说一般存储的数据是有限的，为了使用最少的资源达到最好的效果，redis提供的数据淘汰策略，当将达到指定的最大使用空间时（配置指定）对数据进行淘汰（删除）。淘汰策略主要包括：

* LRU 最近最少使用
  * volatile-lru 针对设置了过期时间的键
  * allkeys-lru 针对所有键
* TTL 挑选将要过去的数据淘汰
* random 随机淘汰
  * volatile-random 针对设置了过期时间的键
  * allkeys-random 针对所有键
* no-enviction 禁止驱逐

## 7. redis如何优化？

## 8. redis使用过程应该注意哪些问题？

## 9. redis应该有哪些基本配置？



[参考资料-面试中关于Redis的问题看这篇就够了](https://juejin.im/post/5ad6e4066fb9a028d82c4b66)