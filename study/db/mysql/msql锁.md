# mysql之锁（版本5.7 InnoDB）

## 一、锁分类

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
    * 插入意图锁定是一种由INSERT行插入之前的操作设置的间隙锁定 。该锁定表示以这样的方式插入的意图：如果插入到相同索引间隙中的多个事务不插入间隙内的相同位置，则不需要等待彼此。假设存在值为4和7的索引记录。分别尝试插入值5和6的事务分别在获取插入行上的排它锁之前用插入意图锁定锁定4和7之间的间隙，但是不要互相阻塞，因为这些行是非冲突的。

7. 自增锁（AUTO-INC Locks）
    * 一个AUTO-INC锁是通过交易将与表中取得一个特殊的表级锁 AUTO_INCREMENT列。在最简单的情况下，如果一个事务正在向表中插入值，则任何其他事务必须等待对该表执行自己的插入，以便第一个事务插入的行接收连续的主键值。

8. 空间索引的谓词锁（Predicate Locks for Spatial Indexes）
    * 要处理涉及SPATIAL索引的操作的锁定 ，下一键锁定不能很好地支持REPEATABLE READ或 SERIALIZABLE事务隔离级别。在多维数据中没有绝对排序概念，因此不清楚哪个是 “ 下一个 ”密钥。

## 二、设置锁

## 零散

1. 可重复读隔离级别下