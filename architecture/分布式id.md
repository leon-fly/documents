---
date: "2020-05-29"
draft: false
lastmod: "2020-05-29"
publishdate: "2020-05-29"
tags:
- architecture
title: 分布式ID总结
---

# 分布式ID总结

## 1. 分布式ID使用场景及要求

分布式ID，见名知意，使用在分布式系统中唯一标识。在单体数据库中业务表的主键需要一个唯一值来标识唯一一条记录，这是主键的一个重要作用，当业务体量单体库无法支撑之后便需要进行分库或分表，同一张业务表（如用户表）通过多张表或者多个库来分散存储来降低单表/数据库压力，那么问题也就来了，单体结构下一般单表的id通过id自增来生成，继续使用这种策略将不能满足唯一性要求。这是一种经典的分布式ID需求场景。



## 2. 常用的分布式ID生成方法

* 借助中间件生成

  * 借助数据库自增主键

    mysql、oracle等此类常用的关系型数据库通常都提供了自增id，当应用业务场景是低频且对生成id失效要求不是特别高的情况下可以使用。

    该方式优点：

    * 简单方便，生成的id有序递增

    该方式缺点：

    * 依赖数据库，增加业务故障点。
    * 集中依赖一张表，资源访问集中影响并发性能（可以考虑通过设置自增分段来进行优化）

  * redis的自增

    使用redis的incr或incyby命令来生成id

    优点：

    * 性能优于数据库，满足有序递增

    缺点：

    ​	redis是内存型数据库，即使使用AOF和RDB，依然存在数据丢失的可能，间接造成ID重复。

* 不借助中间件生成

  * [UUID](https://baike.baidu.com/item/UUID/5921266?fr=aladdin)

    全球统一唯一识别码，开放软件基金会组织在部分是计算领域的一部分，使id的生成不依赖于中央控制端。其一般由时间、日期、全球唯一的机器识别码、时钟序列组成一个128位的数，其实现算法版本有多种。

    该方式优点：

    * 不依赖第三方

    该方式确定：

    * 长度过长，无序。

  * 推特的雪花算法（snowflow）

    雪花算法由推特公司为解决高并发分布式系统而设计实现。使用64位来表示：

    ```
    |1位|42位时间戳|10位工作机器id|12位序列号	
    ```

    **1位标识部分**，在java中由于long的最高位是符号位，正数是0，负数是1，一般生成的ID为正数，所以为0；

    **41位时间戳部分**，这个是毫秒级的时间，一般实现上不会存储当前的时间戳，而是时间戳的差值（当前时间-固定的开始时间），这样可以使产生的ID从更小值开始；41位的时间戳可以使用69年，(1L << 41) / (1000L * 60 * 60 * 24 * 365) = 69年；

    **10位节点部分**，Twitter实现中使用前5位作为数据中心标识，后5位作为机器标识，可以部署1024个节点；

    **12位序列号部分**，支持同一毫秒内同一个节点可以生成4096个ID；

    该方式优点：

    * 生成id不依赖第三方，生成高效
    * 生成的id有序。

    该方式缺点：

    * 依赖服务器时间，需要注意避免发生时钟矫正等其他原因造成的时钟回拨。





