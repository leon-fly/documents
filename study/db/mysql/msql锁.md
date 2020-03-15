# 一、锁分类

1. 共享锁（S）/排他锁 (X) （Shared and Exclusive Locks）
    * InnoDB实现的标准的行级锁
    * 共享锁允许持有锁的事务进行读行数据。该类锁允许多个事务同时持有。
    * 排他锁允许持有锁的事务进行数据更行和删除。该类锁同一时间紧允许一个事务持有。
2. 意向锁（Intention Locks）
    * InnoDB支持的多粒度的锁（行锁和表锁）
    * 意图锁包含两类
        * 意图共享锁（intention shared lock->IS）
            * SELECT ... LOCK IN SHARE MODE sets an IS lock
        * 意图排他锁(intention exclusive lock ->IX)
            * SELECT ... FOR UPDATE sets an IX lock.
    * 意图锁协议
        * 在事务获取共享行锁之前必须先获取该表到意图共享锁
        * 在事务获取排他行锁之前必须先获取该表到意图排他锁。
    * 表级锁类型兼容性

        ||X|IX|S|IS|
        |:----|:----|:----|:----|:----|
        |X   |**<font color=red>Conflict</red>**|**<font color=red>Conflict</red>**|**<font color=red>Conflict</red>**|**<font color=red>Conflict</red>**|
        |IX  |**<font color=red>Conflict</red>**| Compatible |**<font color=red>Conflict</red>**|Compatible|
        |S   |**<font color=red>Conflict</red>**|**<font color=red>Conflict</red>**| Compatible| Compatible|
        |IS  |**<font color=red>Conflict</red>**| Compatible| Compatible| Compatible|
        总结：
        排他锁与任务锁都互斥，共享锁与共享锁兼容。

3. 记录锁/行锁（Record Locks）
    * 加在单行索引记录上的锁。

    ```sql
    SELECT * FROM person where pid='1' FOR UPDATE;
    ```
4. 间隙锁（Gap Locks）
    * 加在where条件限定的整个索引记录上，可能是一行，多行，也可能为空。**锁定一个范围，但不包括记录本身**
    ```sql
    SELECT * FROM person WHERE pid BETWEEN '10' AND '20' FOR UPDATE;
    ```
5. Next-Key Locks
    * 行锁和间隙锁的组合

6. 插入意图锁（Insert Intention Locks）
    * 插入意图锁定是一种由INSERT行插入之前的操作设置的间隙锁定 。该锁定表示以这样的方式插入的意图：如果插入到相同索引间隙中的多个事务不插入间隙内的相同位置，则不需要等待彼此。假设存在值为4和7的索引记录分别尝试插入值5和6的事务分别在获取插入行上的排它锁之前用插入意图锁定锁定4和7之间的间隙，但是不要互相阻塞，因为这些行是非冲突的。

7. 自增锁（AUTO-INC Locks）
    * 一个AUTO-INC锁是通过交易将与表中取得一个特殊的表级锁 AUTO_INCREMENT列。在最简单的情况下，如果一个事务正在向表中插入值，则任何其他事务必须等待对该表执行自己的插入，以便第一个事务插入的行接收连续的主键值。

8. 空间索引的谓词锁（Predicate Locks for Spatial Indexes）
    * 要处理涉及SPATIAL索引的操作的锁定 ，下一键锁定不能很好地支持REPEATABLE READ或 SERIALIZABLE事务隔离级别。在多维数据中没有绝对排序概念，因此不清楚哪个是 “ 下一个 ”密钥。

# 二、另类的锁分类

1. 悲观锁
总是假设最坏的情况，认为竞争总是存在，每次拿数据的时候都认为会被修改，因此每次都会先上锁，其他线程阻塞等待释放锁。可以使用for update进行加锁。
**应用场景** 比较适合写入操作比较频繁的场景，如果出现大量的读取操作，每次读取的时候都会进行加锁，这样会增加大量的锁的开销，降低了系统的吞吐量。
2. 乐观锁
总是假设最好的情况，认为竞争总是不存在，每次拿数据的时候都认为不会被修改，因此不会先上锁，在最后更新的时候比较数据有无更新，可通过版本号或CAS实现。
**应用场景** 比较适合读取操作比较频繁的场景，如果出现大量的写入操作，数据发生冲突的可能性就会增大，为了保证数据的一致性，应用层需要不断的重新获取数据，这样会增加大量的查询操作，降低了系统的吞吐量。

# 三、事务
mysql支持四种事务隔离级别，由常用到不常用如下：

* REPEATABLE READ

	mysql默认的隔离级别

* READ COMMITTED
* READ UNCOMMITTED
* SERIALIZABLE

# 三、思考
1. 意向锁存在的意义是什么？
意向锁是表级别的锁，主要为了优化需要获取表级别的锁时快速确定当前是否有记录或表所被其他事务持有，类似于短路策略。不面向mysql用户，可以理解为mysql内部性能方面的优化。
2. gap锁对于时间字段是否有效果？处理时有什么特殊之处？
3. 多个查询条件，查询条件匹配多个索引时，使用什么锁？


# 四、mysql数据表

1. INFORMATION_SCHEMA.INNODB_LOCKS  当前实例中的锁（无互斥的锁不在记录中）
2. INFORMATION_SCHEMA.INNODB_LOCK_WAITS 当前等待获取锁的请求记录
3. INFORMATION_SCHEMA.INNODB_TRX 当前冲突的锁记录


说明：mysql 版本5.7 InnoDB