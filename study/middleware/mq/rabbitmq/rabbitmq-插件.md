---
date: "2018-01-01"
draft: false
lastmod: "2018-01-01"
publishdate: "2018-01-01"
tags:
- middleware
- mq
- rabbitmq
title: rabbitmq-插件
---
# 系统插件

## 启用管理平台，默认端口15672
> rabbitmq-plugins enable  rabbitmq_management 

插件关闭命令与开启命令格式类似，将enable改为disable即可。

## 启用监控插件
> rabbitmq-plugins enable rabbitmq_tracing