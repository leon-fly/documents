---
date: "2018-01-01"
draft: false
lastmod: "2018-01-01"
publishdate: "2018-01-01"
categorys:
- 中间键
tags:
- db
- mysql
- handbook
title: mysql 命令基础操作
---

## 1. 数据库连接操作

1. 连接

    ```text
    mysql -h host -u user -p databaseName
    #本机操作可以省略主机信息
    mysql -u user -p
    #databasName可以不指定，不指定时仅建立连接
    ```
2. 退出

    ```mysql
    QUIT
    ```
3. 清屏
    > system clear

## 2. 数据库信息查询

1. 查询数据库版本

    ```mysql
    SELECT VERSION();
    ```
2. 查询数据库

    ```mysql
    #当前所有数据库
    SHOW DATABASES;
    
    #当前使用数据库
    SELECT database();
    ```
3. 选择/进入要操作的数据库

    ```mysql
    USE dbname;
    ```
4. 查询用户

    ```mysql
    SELECT USER();
    ```

## 3. 数据库操作

1. 创建


```
CREATE DATABASE IF NOT EXISTS dbname DEFAULT CHARSET utf8 COLLATE utf8_general_ci;
```

2. 删除数据库

```
DROP DATABSE dbname;
```


## 4. 表操作

1. 查询表列表

    ```mysql
    SHOW TABLES;
    ```

2. 查询表结构信息；

    ```mysql
    DECRIBE tablename;
    ```

## 5. 索引操作

### 5.1. 创建索引

#### 5.1.1. ALTER TABLE 创建普通索引、唯一索引、主键
给表创建普通索引
> ALTER TABLE table_name ADD INDEX index_name (column1,column2..columnN)

给表创建唯一索引
> ALTER TABLE table_name ADD UNIQUE index_name (column1,column2..columnN)

给表创建主键
> ALTER TABLE table_name ADD PRIMARY KEY key_name (column1,column2..columnN)

#### 5.1.2. CREATE INDEX 创建普通索引和唯一索引

创建普通索引
> CREATE INDEX index_name ON table_name (column1,column2..columnN)

创建唯一索引
> CREATE UNIQUE INDEX index_name ON table_name (column1,column2..columnN)1

### 5.2. 删除索引
> DROP INDEX index_name ON talbe_name

> ALTER TABLE table_name DROP INDEX index_name

> ALTER TABLE table_name DROP PRIMARY KEY

### 5.3. 查看索引
> SHOW INDEX FROM tblname;

> SHOW KEYS FROM tblname;


## 6. 事务操作
1. **查看当前会话事务隔离级别**
    > SELECT @@tx_isolation;

    ```
    +-----------------+
    | @@tx_isolation  |
    +-----------------+
    | REPEATABLE-READ |
    +-----------------+
    ```
2. **查看当前数据库默认事务隔离级别** 
    > select @@global.tx_isolation;

2. **事务基本操作**

    ```mysql
    SET [GLOBAL | SESSION] TRANSACTION
    transaction_characteristic [, transaction_characteristic] ...
    transaction_characteristic: {
    ISOLATION LEVEL level
    | READ WRITE
    | READ ONLY
    }
    level: {
    REPEATABLE READ
    | READ COMMITTED
    | READ UNCOMMITTED
    | SERIALIZABLE
    }
    ```
    **说明**
    通过以上语句可以设置事务操作类型:读写/仅读，以及事务的隔离级别（四类），对事务的设置影响范围为当前会话或全局。

    **示例**
    ```mysql
    #设置当前会话隔离级别为可重复读
    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    #启动事务
    START TRANSACTION; [或者SET AUTOCOMMIT=FALSE;]
    #执行语句
    UPDATE person SET gender='F' where pid='1'; 
    #提交|回滚
    COMMIT;|ROLLBACK;
    ```
3. 还原点

    ```mysql
    #创建还原点
    SAVEPOINT a;
    dml语句 ...
    #回滚到还原点
    ROLLBACK TO SAVEPOINT a;
    #释放还原点
    RELEASE SAVEPOINT a;
    
    ```
    **说明**
    在事务中可以创建多个还原点用用于回滚；