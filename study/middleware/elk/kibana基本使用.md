---
date: "2020-04-30"
draft: false
lastmod: "2020-04-30"
publishdate: "2020-04-30"
tags:
- middleware
- ELK
title: kibana基本使用
---

# kibana的基本使用

kibana是ELK的核心组件之一，用来对收集的日志通过elasticsearch查询并进行展示。kibana主要做的工作是面向用户的操作窗口，其实现的功能都是基于logstash收集到日志，elasticsearch进行索引并提供查询服务。那么kibana提供了多种类型的操作。

## 1. 索引创建 - 查询的基础

## 2. 查询功能

### 2.1. 查询输入

* 时间选择

  * 支持快速选择范围，如最近15/30分钟内，最近1/4/12/24小时等等
  * 支持相对时间范围，如3天前-1天前
  * 支持绝对时间范围，如具体时刻点A-具体时刻点B (精确到ms)

* 查询语句

  * 输入关键字直接对关键字进行查询（针对所有字段）
  * 使用lucene语法进行查询
    * 查询字段值
      * 单字段查询
        * 单字段单条件查询
          * field : key
        * 单字段多条件查询
          * field1 : (key1 **AND/OR**  key2)  OR可以省略
      * 多字段查询
        * field1 : key1 AND/OR field2 : key2
        * field1.\\* : key1  （适合key多层级）
      * 字段非空查询
        * \_exists_ : field    查询field不为空的记录
      * 正则支持（慎用，尤其是*在前面可能要索引大量数据）
        * field:\\正则表达式\ 
      * 模糊查询
      * 近邻查询
      * 范围查询（针对时间、数字）
        * field : [ start TO end]        查询field从start 到 end到记录， []为包含边界 {}为不包含边界，可以使用[}   {], *可以代表无边界
        * field : >num      查询field大于num到记录， >可以替换为其他操作符，如>= 、< 、<=
      * booting 
      * boolean操作
        * 表达式中可以包含可选存在项、必存在项、必存在项。可选存在项有一个即可

  

  注意：在elasticsearch中使用"."连接的一串英文解析为一个单词，比如你想要查找java.lang.Exception如果查询串关键字为Exception那么查询很可能不是你想要的结果，你需要将关键字设置为java.lang.Exception

  [官方 lucene查询语法](https://www.elastic.co/guide/en/elasticsearch/reference/5.5/query-dsl-query-string-query.html#query-string-syntax)

### 2.2. 查询结构操作

* 展示字段选择
* 展示字段排序
* 查询结果列上下文日志展示



