---
date: "2020-05-16"
draft: false
lastmod: "2020-05-16"
publishdate: "2020-05-16"
tags:
- bigdata
- hadoop
title: hadoop安装及使用
---

# hadoop安装及使用

本文主要记录hadoop整个安装及启动及运行过程中重点过程及需要注意的问题，详细参考[官方指南](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SingleCluster.html)

当前安装版本为当前最新 v3.2.1

## 1. hadoop安装

hadoop的单机安装及启动比较简单

1. 下载tar包，地址 <https://mirror.bit.edu.cn/apache/hadoop/common/hadoop-3.2.1/hadoop-3.2.1.tar.gz>

2. 解压缩到软件目录 

   > tar -zxvf target-direct

3. 配置JAVA_HOME

   > export JAVA_HOME=/usr/lib/jvm/default-java

   或者配置/etc/profile方式永久生效

4. 进入hadoop的bin目录运行hadoop会打印命令行使用说明