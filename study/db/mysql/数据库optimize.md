---
date: "2018-01-05"
draft: false
lastmod: "2018-01-05"
publishdate: "2018-01-05"
categorys:
- 中间键
tags: 
- db
- mysql
title: mysql数据库optimize
---

# mysql数据库optimize

查看当前表存储状态

> show table status like 'tm_order%'

-- optimize

> OPTIMIZE TABLE table name

可能出现如下错误信息：

Table does not support optimize, doing recreate + analyze instead

=>

```
ALTER TABLE tablename ENGINE=InnoDB;
ANALYZE TABLE tablename;
```

