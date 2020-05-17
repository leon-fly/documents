---
date: "2018-01-01"
draft: false
lastmod: "2018-01-01"
publishdate: "2018-01-01"
tags:
- middleware
- redis
title: redis安装及常用命令
---
## 1. 安装及启动
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

    > redis-cli -h host -p port -a password  

    默认端口6379

    ```
    $ src/redis-cli
    redis> set foo bar
    OK
    redis> get foo
    "bar"
    ```

* 关闭服务
    通过redis-cli连接到服务之后执行shutdown


## 2. 数据类型及常用命令
[官方命令清单](https://redis.io/commands#)
[中文版命令参考](http://redisdoc.com/)

redis默认内部16个子库，通过select命令进行库的切换。默认是用0号索引库如：

> select 5

### 2.1. String
* 可以存储字符串和数字类型（整型和浮点型，整形支持长度相当于long，浮点型相当于double）。
* 字符串支持追加，长度，指定截取等操作。
* 数字类型支持数据加减指定值。

设置
> SET key value 

> MSET [key value]...  一次性设置多个，高效

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

自增1
> INCR key

增加N
> INCRBY key N

自减1
> DECR key

自减N
> DECRBY key N

### 2.2. 列表（链表）
* 支持从列表左边或者右边推入或推出元素，支持指定位置值设置，指定位置前插入
* 支持获取指定位置，指定范围元素
* 支持修剪元素，保留指定范围

**命令以L|R打头，L代表list，R表示Right**
> LPUSH｜RPUSH key value...

> LPOP|RPOP key

> LINDEX key offset

> LRANGE key start end

> LTRIM key start end

> LLEN key

### 2.3. 集合
* 无序，不可重复，支持快速对元素进行操作
* 支持添加和移除1个或多个元素
* 支持查询集合元素数量及是否包含指定元素，支持获取随机的几个元素
* 支持元素移动到其他集合
* 支持集合操作，如交集、差集、并集等

**命令以S打头,S表示SET**
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


### 2.4. 散列
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
> HEXISTS key key

获取散列中所有的键
> HKEYS key

获取散列中所有的值
> HVALS key

获取散裂中所有的键值对
> HGETALL key

将散列表中的指定键的值增加
> HINCRBY | HINCRBYFLOAT key key increment


### 2.5. 有序集合

结构类似于散列表，不允许重复的元素，有序集合里存储着成员及成员对应分值，并且提供分值处理命令，排序规则即通过分值来的。

**命令以Z打头，集合计算Z命令一般有对应的ZREV，分数逆序计算**

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


### 2.6. 事务命令
* WATCH,监视指定key，配合MULTI...EXEC使用，如果watch键值变化则事务失败
> WATCH key...
* UNWATCH,重置连接,不在监视。
* MULTI redis事物开启标识，该命令之后，EXEC之前的命令将存储在redis的执行队列，调用EXEC之后才会连续执行队列里的任务。
* EXEC 事物执行
* DISCARD 该命令用在MULTI之后，EXEC之前，命令之前的内容将被重置丢弃。

### 2.7. 调试命令
* PING
* ECHO
* OBJECT
通过OBJECT命令可以从内部察看给定 key 的 Redis 对象，它通常用在除错(debugging)或者了解为了节省空间而对 key 使用特殊编码的情况。 当将Redis用作缓存程序时，你也可以通过 OBJECT 命令中的信息，决定 key 的驱逐策略(eviction policies)。
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
    * 可设置要记录的查询最低耗时和最大日志记录数，日志记录采用队列方式，当日志记录超过最大日志记录数，老的记录先删掉
    * 可以获取当前日志记录，当前记录数
    * 可以情况当前日志记录

* MONITOR
用于监控redis接收到的执行命令，该命令对性能影响比较大，启动一个监控命令可能降低服务吞吐50%甚至更多。

* INFO
该命令包含的redis服务器的当前状态有关的信息

### 2.8. 故障处理命令
* redis-check-aof
* redia-check-dump

### 2.9. 其他常用命令

列出匹配的键列表
> KEYS pattern

随机获取一个key
> RANDOMKEY

清空库(慎用)
> FLUSHDB

查看键值个数
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

[参考 - redis配置](https://zhuanlan.zhihu.com/p/50101602)



## 3. 复制集命令



## 4. sentinel 常用命令

[官网完整](https://redis.io/topics/sentinel)

## 5. 集群命令

