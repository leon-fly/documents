---
date: "2018-01-01"
draft: false
lastmod: "2018-01-01"
publishdate: "2018-01-01"
tags:
- middleware
- ha
title: HAProxy
---
# HAProxy安装

---
20191130
系统 ubantu

---

# 过程
* 下载[HAProxy](http://www.haproxy.org/)
* 解压
    > haproxy-2.1.0.tar.gz
* 编译可执行文件
    > make TARGET=generic PREFIX=/usr/local/haproxy
* 安装
    > make install PREFIX=/usr/local/haproxy

* 配置

* 启动


[参考](https://blog.csdn.net/wyqlxy/article/details/51861329)