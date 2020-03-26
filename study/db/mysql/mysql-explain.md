---
date: "2020-03-26"
draft: false
lastmod: "2020-03-26"
publishdate: "2020-03-26"
tags:
- db
- mysql
title: mysql explain
---

## 1. 关于mysql explain
* explain是mysql提供的用于查看对于一条sql语句mysql的执行计划，比如查询次数，查询是否使用索引，预期扫描行数等等，可以使用该工具进行mysql优化。

* 使用方法：在select语句前加explain。

以下为一个简单的使用索引查询的解释计划：
```
mysql> EXPLAIN SELECT * FROM employees t WHERE t.`emp_no`='10001';
+----+-------------+-------+------------+-------+---------------+---------+---------+-------+------+----------+-------+
| id | select_type | table | partitions | type  | possible_keys | key     | key_len | ref   | rows | filtered | Extra |
+----+-------------+-------+------------+-------+---------------+---------+---------+-------+------+----------+-------+
|  1 | SIMPLE      | t     | NULL       | const | PRIMARY       | PRIMARY | 4       | const |    1 |   100.00 | NULL  |
+----+-------------+-------+------------+-------+---------------+---------+---------+-------+------+----------+-------+
1 row in set, 1 warning (0.00 sec)
```

## 2. explain结果各个数据项详解
### 2.1. 数据行
explain结果可能会出现多行有序数据，表示执行所需要的查询次数及次序。比如在涉及子查询、union等操作时。

示例1：
```
mysql> EXPLAIN SELECT t.*,e.* FROM employees t LEFT JOIN dept_emp e ON t.`emp_no`=e.`emp_no`;
+----+-------------+-------+------------+------+----------------+--------+---------+--------------------+--------+----------+-------------+
| id | select_type | table | partitions | type | possible_keys  | key    | key_len | ref                | rows   | filtered | Extra       |
+----+-------------+-------+------------+------+----------------+--------+---------+--------------------+--------+----------+-------------+
|  1 | SIMPLE      | t     | NULL       | ALL  | NULL           | NULL   | NULL    | NULL               | 299343 |   100.00 | NULL        |
|  1 | SIMPLE      | e     | NULL       | ref  | PRIMARY,emp_no | emp_no | 4       | employees.t.emp_no |      1 |   100.00 | Using index |
+----+-------------+-------+------------+------+----------------+--------+---------+--------------------+--------+----------+-------------+
```

示例2 
当使用union时会有额外的行信息：
```
EXPLAIN SELECT 1 UNION SELECT 1;
+----+--------------+------------+------------+------+---------------+------+---------+------+------+----------+-----------------+
|  id  | select_type  | table      | partitions | type | possible_keys | key  | key_len | ref  | rows | filtered | Extra           |
+------+--------------+------------+------------+------+---------------+------+---------+------+------+----------+-----------------+
|  1   | PRIMARY      | NULL       | NULL       | NULL | NULL          | NULL | NULL    | NULL | NULL |     NULL | No tables used  |
|  2   | UNION        | NULL       | NULL       | NULL | NULL          | NULL | NULL    | NULL | NULL |     NULL | No tables used  |
| NULL | UNION RESULT | <union1,2> | NULL       | ALL  | NULL          | NULL | NULL    | NULL | NULL |     NULL | Using temporary |
+----+--------------+------------+------------+------+---------------+------+---------+------+------+----------+-----------------+
```

使用union all不同于union，union不产生临时表
```
mysql> mysql> EXPLAIN SELECT 1 UNION ALL SELECT 1;
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+----------------+
| id | select_type | table | partitions | type | possible_keys | key  | key_len | ref  | rows | filtered | Extra          |
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+----------------+
|  1 | PRIMARY     | NULL  | NULL       | NULL | NULL          | NULL | NULL    | NULL | NULL |     NULL | No tables used |
|  2 | UNION       | NULL  | NULL       | NULL | NULL          | NULL | NULL    | NULL | NULL |     NULL | No tables used |
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+----------------+
```

### 2.2. 数据列
#### 2.2.1. id
唯一标识sql中的每一个（子）查询，内层的select语句一般会顺序编号，对应于其在原始语句中的位置。
#### 2.2.2. select_type
该列显示了对应行是简单还是复杂select。simple代表只有简单查询，不含有子查询和union。如果查询含有任何复杂查询则最外层查询为primary，其他部分标记为如下：
* SUBQUERY
包含在select的属性列表中select标记为SUBQUERY.SUBQUERY有很多派生类型

示例：
```
EXPLAIN SELECT t.`emp_no`, (SELECT it.`first_name` FROM employees it WHERE t.`emp_no`=it.`emp_no` AND it.`emp_no`='10001' ) FROM employees t;
+----+--------------------+-------+------------+-------+---------------+------------------------+---------+-------+--------+----------+-------------+
| id | select_type        | table | partitions | type  | possible_keys | key                    | key_len | ref   | rows   | filtered | Extra       |
+----+--------------------+-------+------------+-------+---------------+------------------------+---------+-------+--------+----------+-------------+
|  1 | PRIMARY            | t     | NULL       | index | NULL          | ind_employees_birthday | 3       | NULL  | 299343 |   100.00 | Using index |
|  2 | DEPENDENT SUBQUERY | it    | NULL       | const | PRIMARY       | PRIMARY                | 4       | const |      1 |   100.00 | NULL        |
+----+--------------------+-------+------------+-------+---------------+------------------------+---------+-------+--------+----------+-------------+
```
* DERIVED
包含在From子句中的子查询中的select，mysql会递归执行并将结果放到一个临时表中，服务器内部称其为派生表。
示例：

* UNION
在union中的第二个和随后的select被标记为union
* UNION RESULT
用来从union的匿名临时表检索结果的select被标记我iunion result

#### 2.2.3. table
标识当前行查询的表的名称或表的别名。特别的表明：derivedN，表示为内部查询匿名临时表，N表示向前引用计数，N指向EXPLAIN输出中后面的一行。

#### 2.2.4. partitions

#### 2.2.5. type
该列显示访问类型，从最差到最优依次为：
* ALL
全表扫描。例外：当使用了limit或者Extra列中显示Using distinct/not exists时，非全表扫描。
* index
跟全表扫描一样，只是mysql扫描表时按索引次序进行而不是行。
* range
有限制的索引扫描，优于全索引扫描。关键信息：索引+基于索引的范围查找
* ref
索引访问或者索引查找。返回所有匹配某个单个值的行，可能找到多个符合条件的行。关键信息：非唯一索引/唯一索引的非唯一性前缀 + 匹配当个值
示例：
```
-- birth_date建立了普通索引
mysql> EXPLAIN SELECT * FROM employees t WHERE t.birth_date='1990-01-01';
+----+-------------+-------+------------+------+------------------------+------------------------+---------+-------+------+----------+-------+
| id | select_type | table | partitions | type | possible_keys          | key                    | key_len | ref   | rows | filtered | Extra |
+----+-------------+-------+------------+------+------------------------+------------------------+---------+-------+------+----------+-------+
|  1 | SIMPLE      | t     | NULL       | ref  | ind_employees_birthday | ind_employees_birthday | 3       | const |    1 |   100.00 | NULL  |
+----+-------------+-------+------------+------+------------------------+------------------------+---------+-------+------+----------+-------+
```
**ref_or_null**, ref的变体，表示mysql必须在初次查找的结果里进行第二次查找以找出NULL条目。
* eq_ref
mysql知道最多返回一条符合条件的记录。关键信息：主键/唯一索引+匹配单个值.
示例：
```
-- emp_no为主键
mysql> EXPLAIN SELECT * FROM employees t WHERE t.emp_no IN (SELECT emp_no FROM dept_emp WHERE dept_no='d005');
+----+-------------+----------+------------+--------+------------------------+---------+---------+---------------------------+--------+----------+-------------+
| id | select_type | table    | partitions | type   | possible_keys          | key     | key_len | ref                       | rows   | filtered | Extra       |
+----+-------------+----------+------------+--------+------------------------+---------+---------+---------------------------+--------+----------+-------------+
|  1 | SIMPLE      | dept_emp | NULL       | ref    | PRIMARY,emp_no,dept_no | dept_no | 12      | const                     | 148054 |   100.00 | Using index |
|  1 | SIMPLE      | t        | NULL       | eq_ref | PRIMARY                | PRIMARY | 4       | employees.dept_emp.emp_no |      1 |   100.00 | NULL        |
+----+-------------+----------+------------+--------+------------------------+---------+---------+---------------------------+--------+----------+-------------+
```

* const, system
当mysql能对查询到某部分进行优化并将其转换成一个常量，将会使用该访问类型。

示例
```
-- emp_no为主键
mysql> EXPLAIN SELECT * FROM employees t WHERE t.emp_no='10001';
+----+-------------+-------+------------+-------+---------------+---------+---------+-------+------+----------+-------+
| id | select_type | table | partitions | type  | possible_keys | key     | key_len | ref   | rows | filtered | Extra |
+----+-------------+-------+------------+-------+---------------+---------+---------+-------+------+----------+-------+
|  1 | SIMPLE      | t     | NULL       | const | PRIMARY       | PRIMARY | 4       | const |    1 |   100.00 | NULL  |
+----+-------------+-------+------------+-------+---------------+---------+---------+-------+------+----------+-------+
```

* NULL
这种方式表示mysql能在优化阶段分解查询语句，在执行阶段甚至用不着再访问或者索引。

```
-- emp_no为主键
EXPLAIN SELECT max(emp_no) FROM employees;
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+------------------------------+
| id | select_type | table | partitions | type | possible_keys | key  | key_len | ref  | rows | filtered | Extra                        |
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+------------------------------+
|  1 | SIMPLE      | NULL  | NULL       | NULL | NULL          | NULL | NULL    | NULL | NULL |     NULL | Select tables optimized away |
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+------------------------------+
```

#### 2.2.6. possible_keys
可能使用到对索引，在优化早起创建，有些在后续优化过程可能用不到。

#### 2.2.7. key
mssql实际使用对索引，该值不一定是在possible_keys中。

示例：
```
-- 覆盖索引
mysql> EXPLAIN SELECT emp_no FROM employees;
+----+-------------+-----------+------------+-------+---------------+------------------------+---------+------+--------+----------+-------------+
| id | select_type | table     | partitions | type  | possible_keys | key                    | key_len | ref  | rows   | filtered | Extra       |
+----+-------------+-----------+------------+-------+---------------+------------------------+---------+------+--------+----------+-------------+
|  1 | SIMPLE      | employees | NULL       | index | NULL          | ind_employees_birthday | 3       | NULL | 299343 |   100.00 | Using index |
+----+-------------+-----------+------------+-------+---------------+------------------------+---------+------+--------+----------+-------------+
```

#### 2.2.8. key_len
mysql在索引里使用对字节数。

#### 2.2.9. ref


#### 2.2.10. rows
mysql估计为了找到所需的行而要读取对行数，估算不精确。

#### 2.2.11. filtered
显示的是针对表里符合某个条件对记录数的悲观比例估算。

#### 2.2.12. Extra
在其他列不适合展示对信息。常见信息如下：
* Using inxex
此值表示mysql将使用覆盖索引
* Using where
此值表示mysql将在存储引擎检索行后再进行过滤

* Using temporary
此值表示对查询结果排序时会使用一个临时表。
* Using filesort
此值表示mysql会对结果使用一个外部索引排序，而不是按索引次序从表里读取行。

* Range checked for each record(index map:N)
此值表示没有好用的索引，新的索引将在链接的每一行上重新估算。N是显示在possible_keys列中索引的位图，并且是冗余的。