---
date: "2021-10-10"
draft: false
lastmod: "2021-10-10"
publishdate: "2021-10-10"
tags:
- trouble-shooting
title: ts-websocket-connection limits
---
# 💣 websocket连接失败

**Time : 2021/10/19**
**Issue Description:**
app使用websocket打造的消息通道，突然生产新的连接不能成功创建。



上下文：

连接链路：

app -> azure gateway -> nginx -> application gateway -> application -> message broker(rabbitmq)

**👉 解决方案：**

排查整个链路的连接数，解除连接数的限制

1. 各个组件/应用所在的系统的open files限制调整
2. nginx连接数配置限制调整
3. rabbitmq连接数调整





另外需要注意：

rabbitmq与依赖erlang有版本适配范围，如果版本不支持存在潜在风险crash掉。

