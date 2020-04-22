---
date: "2019-01-01"
draft: false
lastmod: "2019-01-01"
publishdate: "2019-01-01"
tags:
- middleware
- monitor
- statsd_grafana_graphite
title: whisper数据库
---

# [whisper database](https://graphite.readthedocs.io/en/latest/whisper.html)

## 1. whisper数据库简介

1. whisper是一种固定大小的数据库，在设计和使用上跟RRD(round-robin-database)很相似
2. 提供随时间推移进行快速可靠的数字型数据存储
3. 允许将高分辨率数据点降级为低分辨率数据点进行长时间的历史数据保留。

## 2. Data Points (数据点)

whisper数据点作为big-endian双精度浮点数存储在磁盘上，每个值与以UNIX纪元(1970.1.1)始的以秒为单位的时间戳成对。数据值由python的float()函数来解析，特殊字符串比如'inf'也是采用这种方式来处理。最大值和最小值由Python解释器允许的浮点值范围确定，浮点值可以通过执行找到：
> python -c 'import sys; print sys.float_info'

## 3. Archives (存档，涉及保留期限和数据点分辨率两个概念)

whisper数据库包含一个或多个archives，每个archives包含一个特定的数据分辨率和保留方案（以数据点数量或最大时间戳年龄定义）。archives由最高数据点分辨率，最短保留的archive到最低数据分辨率、最长保留期的archive。

为了支持从高数据点分辨率到地分辨率的精确聚合，较长保留期的archive的精度必须是可被下一个较低保留期的archive切分的。比如每60s一个数据点的archive后面可以是每300s一个数据点，因为300能被60整除。相反的，180s的精度后面不能是600s的精度，因为从第一个archive到下一个的数据点率将为3 1/3,whisper不能进行部分点插值。

数据库的总保留时间由保留度最高的存档决定，因为每个存档所覆盖的时间段是重叠的。也就是说，一对1个月和1年的archive不会提供可能猜想的13个月的数据存储，实际上，它仅提供1年的数据存储，也就是里面最高的存档。

## 4. 汇总聚合

超过一个archive的whisper数据库需要一个策略来在数据需要滚动到一个较低数据分辨率时折叠多个数据点。平均函数默认被使用，可用的聚合方法有：

* average
* sum
* last
* max
* min
  
数据聚合的规则定义在graphite的安装目录下的conf/ storage-aggregation.conf配置文件里面，示例：

```txt
[min]
pattern = \.lower$
xFilesFactor = 0.1
aggregationMethod = min

[max]
pattern = \.upper(_\d+)?$
xFilesFactor = 0.1
aggregationMethod = max

[sum]
pattern = \.sum$
xFilesFactor = 0
aggregationMethod = sum

[count]
pattern = \.count$
xFilesFactor = 0
aggregationMethod = sum

[count_legacy]
pattern = ^stats_counts.*
xFilesFactor = 0
aggregationMethod = sum

[default_average]
pattern = .*
xFilesFactor = 0.3
aggregationMethod = average
```

聚合规则定义的语法如下：

```txt
[name]
pattern = <regex>
xFilesFactor = <float between 0 and 1>
aggregationMethod = <average|sum|last|max|min>
```

* name：规则的名称，可随意指定，但在这个配置文件里面必须唯一
* pattern：用来匹配具体指标名的正则表达式。如果配置文件里面定义了多个聚合规则，那么收到一个指标数据的时候，会从上到下使用每个规则里面的pattern对指标名称进行正则表达式匹配，最先匹配到的规则将会被使用。
* aggregationMethod：数据聚合策略（方法）
* xFilesFactor：必须是一个0到1之间的浮点型数值。这个值规定了要把高精度的数据转换成一个低精度的数据，高精度的数据必须有几个。

## 5. 多archive存储和恢复方式

当whisper写入多个archive的数据库时，进来的数据点马上被写入所有的archive。数据点将被按照原样写入高数据分辨率的archive，并将被按照配置的聚合方式聚合存放到各自更高的保留时间archive中。如果你有高数据分辨率的数据点需要聚合，考虑使用[carbon-aggregator](https://graphite.readthedocs.io/en/latest/carbon-daemons.html)来解决

当(在时间范围内的)数据被重新取回，第一个能满足整个时间区间的archive被使用，当时间区间超过archive边界，一个较低的数据分辨率的archive将被使用。这允许在检索数据时使用更简单的方式，因为数据的解析在整个返回的系列中是一致的。

## 6. 磁盘空间效率

whisper在磁盘空间上的使用有点低效，因为如下几个特定的设计选择：

* 每个数据点与它的时间戳一起被存储
* archive重叠时间段
* 一个archive中的所有的时间间隙都占用空间，无论是否有数据被存储