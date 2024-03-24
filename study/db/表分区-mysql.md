---
date: "2024-03-24"
draft: false
lastmod: "2024-03-24"
publishdate: "2024-03-24"
tags:
- db
- mysql
title: mysql表分区
---

## 一个示例了解分区基本操作

示例:我有一张订单表，该表每个月几百万的订单数据，那么考虑到未来因为数据量大可能造成的问题，那么除了分表，分库等方案，表分区也是一个可以考量的方案，分区按照创建时间每个月一张表。

* 创建分区表

  ```
  CREATE TABLE partition_test.t_order (
      id BIGINT AUTO_INCREMENT NOT NULL,
      order_no VARCHAR(30) NOT NULL,
      created_at DATETIME NOT NULL,
      CONSTRAINT order_pk PRIMARY KEY (id,created_at)
  )
  ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci
  PARTITION BY RANGE (TO_DAYS(created_at)) (
      PARTITION p202312 VALUES LESS THAN (TO_DAYS('2024-01-01')),
      PARTITION p202401 VALUES LESS THAN (TO_DAYS('2024-02-01')),
      PARTITION p202402 VALUES LESS THAN (TO_DAYS('2024-03-01'))
  );
  ```

​	注意主键必须包含分区字段，否则可能出现如下类似的错误提示。

​	`SQL 错误 [1503] [HY000]: A PRIMARY KEY must include all columns in the table's partitioning function (prefixed columns are not considered).`

* 数据插入

  ```
  -- 插入数据到 p202312 分区
  INSERT INTO partition_test.t_order (order_no, created_at) VALUES ('ORD001', '2023-12-15 08:00:00');
  INSERT INTO partition_test.t_order (order_no, created_at) VALUES ('ORD002', '2023-12-20 12:30:00');
  
  -- 插入数据到 p202401 分区
  INSERT INTO partition_test.t_order (order_no, created_at) VALUES ('ORD003', '2024-01-15 14:45:00');
  INSERT INTO partition_test.t_order (order_no, created_at) VALUES ('ORD004', '2024-01-25 10:20:00');
  
  -- 插入数据到 p202402 分区
  INSERT INTO partition_test.t_order (order_no, created_at) VALUES ('ORD005', '2024-02-10 16:00:00');
  
  ```


* 数据查询及优化分析

  使用分区表查询可以使用和普通表一样的查询方式（不考虑分区），只是可能存在性能问题。比如如下查询会扫描所有分区（并不会根据你的分区规则自动选在分区）：

  ```
  > EXPLAIN SELECT * from t_order to2 where to2.created_at > '2024-01-25';
  
  id|select_type|table|partitions             |type|possible_keys|key|key_len|ref|rows|filtered|Extra      |
  --+-----------+-----+-----------------------+----+-------------+---+-------+---+----+--------+-----------+
   1|SIMPLE     |to2  |p202312,p202401,p202402|ALL |             |   |       |   |   5|   33.33|Using where|
  
  ```

  所以存在分区的表在编写sql时如果能确定在哪个分区，那么手动进行指定，避免不必要的全区扫描。如以上sql可以调整为：

  ```
  > SELECT * FROM partition_test.t_order PARTITION (p202402) WHERE created_at > '2024-01-25';
  > EXPLAIN SELECT * FROM partition_test.t_order PARTITION (p202402) WHERE created_at > '2024-01-25';
  id|select_type|table|partitions             |type|possible_keys|key|key_len|ref|rows|filtered|Extra      |
  --+-----------+-----+-----------------------+----+-------------+---+-------+---+----+--------+-----------+
   1|SIMPLE     |to2  |202402									|ALL |             |   |       |   |   5|   33.33|Using where|
  ```

  其他的优化如使用索引跟单表类似，如当前示例中可以通过给created_at创建单个索引

* 分区表变更（增加/删除分区） 

  * 新增分区

    ```
    ALTER TABLE partition_test.t_order2 
    ADD PARTITION (
        PARTITION p202403 VALUES LESS THAN (TO_DAYS('2024-04-01'))
    );
    ```

  * 删除分区

    ```
    ALTER TABLE partition_test.t_order2 
    DROP PARTITION p202312;
    ```

​	  新增分区时对原有数据不影响，新数据会根据新的分区规则进行插入。删除分区会将当前分区数据删除掉，谨慎操作。

## 分区表类型

* RANGE分区（使用较多）：基于行数据的某一列进行范围划分，不同范围所属列放到指定的分区

  比如基于记录创建时间，可以使用的范围划分函数有YEAR(field), MONTH(field), TO_DAYS(field)等

* LIST分区：类似于按RANGE分区，区别在于LIST分区是基于列值匹配一个离散值集合中的某个值来进行选择。示例：

  把上面的例子中订单按照年份来分区即属于此类型

  ```
  CREATE TABLE partition_test.t_order (
      id BIGINT AUTO_INCREMENT NOT NULL,
      order_no VARCHAR(30) NOT NULL,
      created_at DATETIME NOT NULL,
      CONSTRAINT order_pk PRIMARY KEY (id,created_at)
  )
  ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci
  PARTITION BY LIST (YEAR(created_at)) (
      PARTITION p2023 VALUES IN (2023),
      PARTITION p2024 VALUES IN (2024),
      PARTITION p2025 VALUES IN (2025))
  );
  ```

* HASH分区：基于用户定义的表达式的返回值来进行选择的分区，该表达式使用将要插入到表中的这些行的列值(某一列)进行计算。这个函数可以包含MySQL中有效的、产生非负整数值的任何表达式.

  把上面的例子中id进行hash分区

  ```
  CREATE TABLE partition_test.t_order_by_hash (
      id BIGINT AUTO_INCREMENT NOT NULL,
      order_no VARCHAR(30) NOT NULL,
      created_at DATETIME NOT NULL,
      CONSTRAINT order_pk PRIMARY KEY (id,created_at)
  )
  ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci
  PARTITION BY HASH (id)
  PARTITIONS 4;
  ```

  这种类型使用比较局限，仅仅支持通过确定的分区键进行快速查询。

* KEY分区：类似于按HASH分区，区别在于KEY分区支持计算一列或多列，且MySQL服务器提供其自身的哈希函数。必须有一列或多列包含整数值（但key不指定列名时会自动选择主键或非空唯一键作为默认参数，如果不存在这样的列会报错）

## 分区的原理

分区表对于用户来说是一个逻辑表，但是底层是由多个物理字表组成实现。存储引擎管理分区的底层表和管理普通表一样（所有底层表使用的必须是相同的存储引擎），分区表的索引只是在各个地层表上各自加一个完全相同的索引。从存储引擎角度看，地层表和一个普通表没有任何不同，存储引擎也无需知道这是一个普通表还是一个分区表的一部分。

## 分区表的局限

* 一个表只能有1024个分区
* 如果分区字段中有主键或者唯一索引的列，那么所有主键列和唯一索引列都必须包含进来。
* 分区表无法使用外键约束

## 分区 vs 水平分表

分区和水平分表都是在数据量大时可以考虑使用的方案，基本分区能解决的问题水平分表都能解决，二者主要的区别在于分区相对于水平分表而言其分区逻辑在数据库层面建立和控制，而水平分表在应用层（通过分库分表框架或者开发者自行编写相关规则）。

## 参考资料

[官方资料 - 分区](https://dev.mysql.com/doc/refman/8.0/en/partitioning.html)



