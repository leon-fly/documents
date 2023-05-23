# 数据库optimize

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

