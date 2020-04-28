---
date: "2019-01-01"
draft: false
lastmod: "2019-01-01"
publishdate: "2019-01-01"
tags:
- middleware
- monitor
- graphite
title: statsd简介
---

# stastd简介

[StatsD Metric转译](https://www.jianshu.com/p/2b0aa5898dd7)

## 1. statsD是什么？有什么作用？

   运行在node.js平台的网络守护程序，监听统计信息，比如计数，时间等，采用UDP或TCP协议将聚合数据发送到一个或多个可插拔的后端服务，比如graphite.

## 2. 关键概念

* buckets.每个统计都在自己的桶中，没有在任何地方预定义。桶可以随意命名，最后被转换到graphite。
* values.每个统计都有一个值，如何解释依赖于修饰符，通常该值都为整数。
* flush. 达到刷新时间间隔（默认10s），统计信息被聚合并发送到后端服务。

## 3. 使用方式

```txt
<metricname>:<value>|<type>
如：
foo:1|c
```

## 4. 度量类型

* Counting,

   计数类的度量类型,最简单的metric，也就是通常的计数功能，StatsD会将收到的counter value累加，然后在flush的时候输出，并且重新清零。所以我们用counter就能非常方便的查看一段时间某个操作的频率，譬如对于一个HTTP服务来说，我们可以使用counter来统计request的次数，finish这个request的次数以及fail的次数。

   > gorets:1|c

   业务使用：
   接口请求次数，成功失败次数等。
* Timing

   耗时度量类型。statsd会计算出当前刷新间隔的平均值，标准差，累加值，个数，最小及最大值等极其百分之。
   > glork:320|ms

   * percentile threshold 配置一个百分比进行削峰后的重新计算结果。
   * histogram 配置连续的数据段，统计时将统计落入各数据段的数据个数
* Gauges

   不同于Counter，Gauge在下次flush的时候是不会清零的，另外，gauge通常是在client进行统计好在发给StatsD的，譬如, capacity:100|g 这样的gauge，即使我们发送多次，在StatsD里面，也只会保存100，不会学counter那样进行累加。
   > gaugor:333|g

   但我们可以通过显示的加入符号来让StatsD帮我们进行累加，譬如:
   > gaugor:-10|g
   > gaugor:+4|g
* Sets

   Set用来计算某个metric unique事件的个数，譬如对于一个接口，可能我们想知道有多少个user访问了，我们可以这样:
    > request:1|s
    > request:2|s
    > request:1|s

    StatsD就会展示这个request metric只有1，2两个用户访问了。

   > uniques:765|s

## 5. 关键配置范例

```txt
{
  graphitePort: 2003,
  graphiteHost: "localhost",
  port: 8125,
  backends: [ "./backends/graphite", "./backends/console" ],
  debug: false,
  dumpMessages: true,
  histogram: [{metric: 'timing', bins: [10, 100, 1000, 'inf']}],
  flushInterval:5000,
  log: "/mnt/c/User/Administrator/software/log/statsd.log"
}
```