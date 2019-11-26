# mysql字符集及字符序

* [参考文档-MySQL字符集及字符序概念及设置](https://www.cnblogs.com/chyingp/p/mysql-character-set-collation.html)
*  [参考文档-MySQL字符集及校对规则(一)](https://mp.weixin.qq.com/s/3se2C3ew7-IeLvYzOyZJiA)
* [参考文档-MySQL字符集及校对规则(二)](https://mp.weixin.qq.com/s/em8hPsCjsB9WCBR1LPn0Cw)
* [参考文档-官方](https://dev.mysql.com/doc/refman/5.7/en/charset.html)


## 总结
---
### 概念
* 字符集（character set）：定义了字符以及字符的编码。
* 字符序（collation）：定义了字符的比较规则/排序。

### 字符集集字符序的设置

* 字符集及字符序可以在server、数据库实例、数据表及字段进行设置，字符集与字符序的使用以粒度越细越优先，即优先级字段>表>数据库>server，当当前层级未指定字符集和字符序时使用上级指定字符。
* server级别的设置可以在配置文件、启动及运行时指定，运行时修改的配置在重启后会失效，临时使用。


###