# redis总结

## 安装及启动
[官方安装指南](https://redis.io/download)

* 下载解压编译

    ```
    $ wget http://download.redis.io/releases/redis-5.0.7.tar.gz
    $ tar xzf redis-5.0.7.tar.gz
    $ cd redis-5.0.7
    $ make
    ```
* 服务启动

    ```
    $ src/redis-server
    ```
* 客户端连接

    ```
    $ src/redis-cli
    redis> set foo bar
    OK
    redis> get foo
    "bar"
    ```


## 数据类型及常用命令
[官方命令清单](https://redis.io/commands#)
[中文版命令参考](http://redisdoc.com/)
### 1. String
* 可以存储字符串和数字类型（整型和浮点型，整形支持长度相当于long，浮点型相当于double）。
* 字符串支持追加，长度，指定截取等操作。
* 数字类型支持数据加减指定值。

设置
> SET key value 

> MSET [key value]...  一次性设置多个，高校

> SETNX key value   仅当不存在时设置

> MSETNX [key value]... 仅当不存在时设置，一次设置多个

> GETSET key value  设置值并返回原有值

获取 
> GET key

> MGET key...

追加
> APPEND key value

获取子串
> GETRANGE key start end

设置子串
> SETRANGE key offset value

获取字符串键值长
> STRLEN key

### 2. 列表（链表）
* 支持从列表左边或者右边推入或推出元素，支持指定位置值设置，指定位置前插入
* 支持获取指定位置，指定范围元素
* 支持修剪元素，保留指定范围

**命令以L|R打头，L代表list，R表示Right**
> LPUSH｜RPUSH key value...

> LPOP|RPOP key

> LINDEX key offset

> LRANGE key start end

> LTRIM key start end

> LLEN key

### 3. 集合
* 无序，不可重复，支持快速对元素进行操作
* 支持添加和移除1个或多个元素
* 支持查询集合元素数量及是否包含指定元素，支持获取随机的几个元素
* 支持元素移动到其他集合
* 支持集合操作，如交集、差集、并集等

**命令以S打头,S表示SET**
添加
> SADD key item...

移除
> SREM key item...

元素是否存在
> SISMEMBER key item

元素数量
> SCARD key

获取所有元素
> SMEMBERS key

随机获取1个或多个元素
> SRANDMEMBER key count

随机弹出1个元素
> SPOP key

集合间元素移动
> SMOVE soure-key dest-key item

差集（存在于第一个集合而不存在其他集合）
> SDIFF key key...

计算差集并存储在dest-key中
> SDIFFSTORE dest-key key key...


交集运算
> SINTER key key...

计算交集并存储
> SINTER dest-key key key...

并集运算
> SUNION key key...

计算并集并存储
> SUNION dest-key key key...


### 4. 散列
**命令以H打头**
设置值
> HMSET key [key value]...

获取1个或多个键的值
> HGET key key...

删除散列里面一个或多个键
> HDEL key

获取散列里面键值对数
> HLEN key

散列中是否存在指定键
> HEXISTS key key

获取散列中所有的键
> HKEYS key

获取散列中所有的值
> HVALS key

获取散裂中所有的键值对
> HGETALL key

将散列表中的指定键的值增加
> HINCRBY | HINCRBYFLOAT key key increment


### 5. 有序集合

结构类似于散列表，不允许重复的元素，有序集合里存储着成员及成员对应分值，并且提供分值处理命令，排序规则即通过分值来的。

**命令以Z打头，集合计算Z命令一般有对应的ZREV，分数逆序计算**

添加带分值的成员
> ZADD key [score member]...

删除成员
> ZREM key member...

成员数量
> ZCARD key

成员值加分
> ZINCRBY key increment member

返回分值介于min和max之间的成员数量
> ZCOUNT key min max

返回成员member在集合中的排名
> ZRANK key member （从小到大，默认）
> ZREVRANK key member (从大到小)

返回成员member的分值
> ZSCORE key 

> ZPOPMAX key [count]

> ZPOPMIN key [count]

返回有序集合中排名介于start和stop之间的成员，指定withscores选项将同时返回分值
> ZRANGE key start stop [WITHSCORES]
> ZREVRANGE start stop [WITHSCORES]

返回有序集合中分数介于min和max之间的成员(注意正序和反序的参数差异)
> ZRANGEBYSCORE key min max [WITHSCORES]
> ZREVRANGEBYSCORE key max min [WITHSCORES]

移除集合元素，根据分数或排名
> ZREMRANGEBYSCORE key min max
> ZREMRANGEBYRANK key start stop

交集和差集
> ZINTERSTORE dest-key key key [WEIGHT weight...] [AGGREGATE SUM|MIN|MAX]
> ZUNIONSTORE dest-key key key [WEIGHT weight...] [AGGREGATE SUM|MIN|MAX]


### 事务命令
* WATCH,监视指定key，配合MULTI...EXEC使用，如果watch键值变化则事务失败
> WATCH key...
* UNWATCH,重置连接,不在监视。
* MULTI redis事物开启标识，该命令之后，EXEC之前的命令将存储在redis的执行队列，调用EXEC之后才会连续执行队列里的任务。
* EXEC 事物执行
* DISCARD 该命令用在MULTI之后，EXEC之前，命令之前的内容将被重置丢弃。

### 调试命令
* PING
* ECHO
* OBJECT
通过OBJECT命令可以从内部察看给定 key 的 Redis 对象， 它通常用在除错(debugging)或者了解为了节省空间而对 key 使用特殊编码的情况。 当将Redis用作缓存程序时，你也可以通过 OBJECT 命令中的信息，决定 key 的驱逐策略(eviction policies)。
    > OBJECT  subcommand [arguments...]
可选的subcommand为：
    * OBJECT REFCOUNT key
    * OBJECT ENCODING key  
    * OBJECT IDLETIME key 返回空闲时间,以秒为单位
    * OBJECT REFQ key
    * OBJECT HELP
* DEBUG OBJECT key
用于服务优化时查询key相关的内部数据，如数据编码
* SLOWLOG
用于记录慢查询的日志
    * 可设置要记录的查询最低耗时和最大日志记录数，日志记录采用队列方式，当日志记录超过最大日志记录数，老的记录先删掉
    * 可以获取当前日志记录，当前记录数
    * 可以情况当前日志记录

* MONITOR
用于监控redis接收到的执行命令，该命令对性能影响比较大，启动一个监控命令可能降低服务吞吐50%甚至更多。

* INFO
该命令包含的redis服务器的当前状态有关的信息

### 故障处理命令
* redis-check-aof
* redia-check-dump

### 其他常用命令

列出匹配的键列表
> KEYS pattern

随机获取一个key
> RANDOMKEY

清空库(慎用)
> FLUSHDB

查看简直对个数
> DBSIZE

迭代获取键列表,返回值包含两列数据，第一列为下一次迭代参数，第二列为当前表页数据,默认每页返回10，可以使用count参数指定每页大小，每页返回的数据等于或者略大于该数；使用MATCH参数过滤返回数据满足匹配内容
> SCAN num [COUNT num] [MATCH pattern]

HSCAN | SSCAN | ZSCAN使用方式类似SCAN，只是需要指定key
> HSCAN | SSCAN | ZSCAN num [COUNT num] [MATCH pattern]

删除一个或多个键
> DEL key...

返回存在的键的个数
> EXISTS key...

重命名key
> RENAME key newkey
> RENAMENX key newkey (newkey不存在，即不会覆盖原key)

设置key的过期时间/时间点（命令中带AT为时间点）
> EXPIRE key seconds
> EXPIREAT key timestamp
> PEXPIRE key millseconds
> PEXPIREAT key timestamp

移动key到另一个db
> MOVE key db

移除key的过期时间
> PERSIST key

获取键过期时间
> PTTL key  (以微秒为单位)
> TTL key （以秒为单位

更新一个或多个key的最后访问时间
> TOUCH key...

排序
> SORT key [BY pattern] [LIMIT offset count] [GET pattern [GET pattern …]] [ASC | DESC] [ALPHA] [STORE destination]


## 数据安全及高可用
### 数据备份
* redis可以通过快照持久化（RDB）或者AOF（Append Only File）来对数据进行持久化，以便恢复后重启。
* 快照持久化（全量）。redis可以通过创建快照获取存储在内容里面的数据在某个时间点上的副本，并对其进行存储或者复制到其他服务器。
    * 快照可以配置从时间和写入条数两个维度控制快照的生成频率
    * 可以配置是否使用压缩来降少存储空间使用
    * 手动触发
        * SAVE 慎用，会阻塞redis服务，但是效率快
        * BGSAVE redis fork子进程异步处理，效率较低。
* AOF（增量）
    * 文件追加策略appendfsync参数选项
        * always 每执行一条写入命令追加一次，对性能影响较大，受限于磁盘的写入速度，如果为固态硬盘次选项的设定会对其寿命严重影响，可能从几年降低到几个月（写入放大问题）。
        * everysec 每秒执行一次追加，显式的将多个命令同步到硬盘
        * no 让操作系统来决定应该何时同步
    * 重写/压缩AOF文件BGREWRITEAOF
        * 重写原因：随着redis长时间运行，AOF文件会变得庞大，占用存储空间且在重启恢复数据时耗时，所以需要通过删除冗余命令减小文件。
        * 手动触发
            * BGREWRITEAOF
        * 配置策略,两个配置同时满足
            * auto-aof-rewrite-percentage 每次重写需要超过上次重写的百分比
            * auto-aof-rewrite-min-size 重写的最小文件大小

### redis主从节点
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


### [哨兵模式](https://redis.io/topics/sentinel)

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


## 性能优化相关
* 查看机器运行redis进行各项服务性能，该性能仅为执行计算命令性能，不包行对客户端的应答，实际客户单不实用pipeline的情况下大概有测试结果的50%～60%，如果达不到该性能指标要关注是否每次发送命令时都创建了新连接。
    > redis-benchmark -c 1 -q
* 通信优化
    * 使用一次性多值处理命令代替单值处理命令
    * 使用pipeline
    * 主从模式下主节点不要有过多从节点
* 硬件提升
    * 内存
    * 存储磁盘，如SSD
    * 宽带
* 使用连接持，不要每次都新建连接

## 内存空间优化
* 短结构
    * 压缩列表表示（列表、hash、有序集合）
        * 包含两个配置选项，允许包含最大元素数量，压缩列表每个节点的最大体积占用字节
        * 当任意一个配置选项被突破，redis将使用其他结构，内存也会因此增加。
* 分片结构

## redis构建应用程序组建
### 分布式锁
* 实现方式
    * watch实现事务。简单，但是事务性能比较低，当并发比较高时，出现重试的次数较多，浪费计算机资源
    * 通过setnx实现事务。推荐的分布式事务实现方式。
* 锁实现注意事项
    * 性能
    * 客户端获取锁后崩溃引起的锁无法释放问题
        * 使用键超时 
        * 使用超时后，如果超时客户端未执行完成相关操作怎么办？
### 计数信号量
* 计数信号量是对有限资源使用限制的支持，比如某资源仅允许同时被5个线程访问，如何限制可以通过计数信号量的方式来处理。
* 技术实现基于有序集合的基本实现
    * 基本原理：以资源名称作为键，客户端请求时使用uuid作为唯一表示，unix时间戳作为分数，以分数排名，排名在资源允许的访问数之内的即为有效，之外的未获取到资源。
    * 非公平信号量
        * 当有多台机器时，如果各及其的时钟不同，时钟慢的可能总会优先获得信号量，时钟快的可能存在一直拿不到信号量的情况以及信号量提早过期。
        * 解决方法：
            * 各个系统之间时间差调整不超过1秒，以上问题会得到好的规避。
            * 统一使用redis服务器的时间
    * 信号量更新
        * 当信号量超过过期时间将被删除，长时间使用信号量时为了避免被删除需要频繁更新信号量。
    * 注意事项：
        * 客户端在获取锁的第一步是清理过期的信号量持有者
        * 在判断获取失败后需要删除之前添加的标识符
        * 使用完信号量后需要及时释放
        * 消除竞争条件消除
            * 由于计数信号量的获取需要多步操作，可能出现时间戳虽然在前面但是在后面插入有序集合中的造成不正常的信号量获取和释放，所以需要使用分布式锁锁定来控制信号量获取时的并发问题。