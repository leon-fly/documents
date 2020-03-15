---
title: "mysql常用DDL语句"
date: 2018-01-01T00:00:00+08:00
draft: true
---
# 一、创建数据库

* 示例

    ```mysql
    CREATE DATABASE IF NOT EXISTS dbname DEFAULT CHARSET utf8 COLLATE utf8_general_bin;
    ```

* 关键参数说明：
  * 数据库名
  * 字符集 charset
  * 字符序/排序规则 collate

# 二、建表语句

1. 完整示例
    ```mysql
    --删除原表
    DROP TABLE IF EXISTS `person`;
    --建表
   CREATE TABLE `person` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(16) COLLATE utf8_bin NOT NULL COMMENT '姓名',
    `sex` enum('F','M') COLLATE utf8_bin DEFAULT NULL COMMENT '性别',
    `pid` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '身份id',
    `birthday` date DEFAULT NULL,
    PRIMARY KEY (`id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
    ```
    * 说明
    建表时可以指定表默认使用的引擎，字符集和字符序，每个char/varcharß字段可以单独设置这些属性

2. 巧用 - 复制表
    ```mysql
    CREATE TABLE person_copy AS SELECT * FROM person;
    ```

# 三、修改表

1. 重命名表名
    ```txt
    格式：
    RENAME TABLE 原表名 TO 新表名;
    示例：
    RENAME TABLE person TO people;
    ```
2. 新增列
    ```txt
    示例：给person表新增列address
    ALTER TABLE person ADD COLUMN address VARCHAR(255) COMMENT '地址' NOT NULL;
    ```
3. 修改列
    ```txt
    示例：修改person表的sex列数据类型为enum
    ALTER TABLE person CHANGE COLUMN sex gender enum('M','F') NOT NULL;
    ```
4. 新增注释
    ```txt
    示例:给表person增加注释[个人信息表]
    ALTER TABLE person COMMENT='个人信息表'
    ```
5. 删除列
    ```txt
    示例：删除person表的birthday列
    ALTER TABLE person DROP COLUMN birthday;
    ```

# 四、索引

1. 增加索引
    ```txt
    示例：给表person的pid创建唯一
    CREATE UNIQUE INDEX ind_person_pid ON person(pid);
    ----------------------------
    UNIQUE为索引类型，可替换索引类型为：
    UNIQUE|FULLTEXT|SPATIAL，mysql 支持的其他索引类型分别为primary key，非唯一索引（默认）
    ```
2. 删除索引
    ```txt
    示例：删除表person的ind_person_pid索引
    DROP INDEX ind_person_pid ON person;
    ```
3. 查询索引
    ```txt
    SHOW index FROM person;
    SHOW keys FROM person;
    ```