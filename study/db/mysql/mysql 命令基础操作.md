# mysql 命令基础操作

## 一、数据库连接操作

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

## 二、数据库信息查询

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

## 三、数据库操作

1. 创建


```
CREATE DATABASE IF NOT EXISTS dbname DEFAULT CHARSET utf8 COLLATE utf8_general_ci;
```

2. 删除数据库

```
DROP DATABSE dbname;
```


## 四、表操作

1. 查询表列表

    ```mysql
    SHOW TABLES;
    ```

2. 查询表结构信息；

    ```mysql
    DECRIBE tablename;
    ```

## 五、事务操作

1. **事务基本操作**

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
    # 设置当前会话隔离级别为可重复读
    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    #启动事务
    START TRANSACTION; [或者SET AUTOCOMMIT=FALSE;]
    #执行语句
    UPDATE person SET gender='F' where pid='1'; 
    #提交|回滚
    COMMIT;|ROLLBACK;
    ```
2. 还原点

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