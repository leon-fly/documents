---
date: "2019-01-01"
draft: false
lastmod: "2019-01-01"
publishdate: "2019-01-01"
tags:
- middleware
- monitor
- graphite
title: 开篇：graphite监控整体说明
---

# 开篇：grafana监控整体说明

## 1. 监控方向
graphite监控方案的监控方向是实时性能，如：
* web网站
* 应用
* 业务服务
* 网络服务

是通过收集监控元数据，进行数据聚合及展示。是整个方案比较核心对组成，graphite对数据保存支持降低“分辨率”（就像图片对分辨率一样，根据一定的算法将原来的大量数据缩小到一定量，仍然保持原始数据样本的特点），做到一定的存储空间支持存储更长时间范围内的统计信息。

## 2. 组件构成
该监控方案主要包含三个部分：

* graphite主要用于接收数据、查询及对数据对二次处理等
* statsd 一个用于收集客户端元数据对组件，可以从客户端收集数据并汇总再发送给graphite，这是一个独立与graphite对项目。
* grafana 一个用于对graphite数据进行查询展示对工具，功能较丰富，弥补了graphite自身展示对不足。

## 3. 各组件详细介绍及安装使用
后续将通过以下几个文档进行更多对了解及初步使用

[graphite简介](graphite简介)

[statsd简介](statsd简介)

[graphite监控相关组件安装](graphite安装)

[grafana配置及使用](grafana配置及使用)
