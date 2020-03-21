---
date: "2018-01-01"
draft: false
lastmod: "2018-01-01"
publishdate: "2018-01-01"
tags:
- middleware
- redis
title: redis集群
---
## 1. redis主从节点
* redis主从节点设置方式
    * 配置文件 slaveof host port 
    * 执行命令 SLAVEOF host port
* 节点数据复制方式
    * 同步信号由从节点发出，发出后从节点根据配置选择使用旧数据或者拒绝客户端请求
    * 主节点接收到请求后开始执行BGSAVE，并使用缓冲区记录BGSAVE之后执行的所有写命令
    * 主节点BGSAVE执行完成之后发送从节点快照数据，这期间仍然使用缓冲区记录写命令。
    * 发送完成之后从节点丢弃老数据解析并载入新数据，主节点发送缓冲区的命令到从节点
    * 缓冲区的命令同步完成之后的新写入实时同步至从节点
* 关于主从节点须知
    * 从节点可以作为其他节点的主节点
    * 从服务器在同步主节点数据时会清空自身原有数据！！！
    * 主从节点设置时需注意单个节点不要过多从节点，会对服务性能造成较大影响，根据业务情况每个节点设置三个从节点之内，组成树状主从链
    * 主服务器的内存使用设置50%～65%，其他用于执行BGSAVE和创建记录写命令的缓冲区


## 2. [哨兵模式](https://redis.io/topics/sentinel)

* sentinel启动的两种方式
    > redis-sentinel /path/to/sentinel.conf

    > redis-server /path/to/sentinel.conf --sentinel

* sentinel强制必须指定配置文件，且配置文件必须具有读写权限。
* sentinel部署必知
    * 强壮的生产部署必须至少要有三个sentinel实例
    * 三个sentinel实例应该放在三个独立的物理机或虚拟机中
    * sentinel + redis分布式系统不保证确认的信息在故障中仍被保留，因为redis使用的是异步复制。但是有办法可以使丢失的数据写入确定的时刻范围。
    * sentinel方案需要客户端的支持。
    * 没有在测试环境进行实时测试，sentinle的高可用方案并不一定安全，最好在生产环境进行测试是不是正常工作。因为你可能发现有些错误配置出现的时候已经晚了，比如晚上三点主节点停止工作。
    * Sentinel，Docker或其他形式的网络地址转换或端口映射应谨慎混合。Docker执行端口重新映射，破坏了其他Sentinel进程的Sentinel自动发现以及主数据库的副本列表。
* sentinel配置

    * 基本配置示例
    ```
    sentinel monitor mymaster 127.0.0.1 6379 2
    sentinel down-after-milliseconds mymaster 60000
    sentinel failover-timeout mymaster 180000
    sentinel parallel-syncs mymaster 1

    sentinel monitor resque 192.168.1.3 6380 4
    sentinel down-after-milliseconds resque 10000
    sentinel failover-timeout resque 180000
    sentinel parallel-syncs resque 5
    ```
    * 关于配置关键说明
        * 配置仅需要配置监控的主节点，服务会在启动或在故障转移时在主节点获取从节点信息并更新到配置中。
        * 配置包括两部分，一部分为主节点实例，另一组为未定义数量的从节点。
    * 配置说明
    
        * 配置监控节点
            > sentinel monitor \<master-group-name> \<ip> \<port> \<quorum>

            quorum 表示发生故障转移需要几个sentinel节点确认主节点不可达，这个配置主要用来标记确认失败的sentinel节点个数，正真的故障转移处理需要检测到失败的一个sentinel节点发起故障转移投票从各个sentinel节点选举出执行故障转移的sentinel节点，如果大多数sentinel进程无法通讯，故障转移也得不到执行。
        * 监控节点其他参数配置

            * 格式：
                > sentinel <option_name> <master_name> <option_value>

                down-after-milliseconds 多少毫秒连接不到标记为down掉
                
                parallel-syncs 指定当故障转移时允许有几个从节点从新主节点复制数据。数字越小故障转移需要掉时间越长；另外虽然从节点复制数据是非阻塞的，但是在从主库批量同步数据时也有那么一瞬间停止提供服务，也就是数字越大不能持续对外提供服务的从节点数越大。
        * 可以通过 SENTINEL SET 命令事实调整sentinel的配置。