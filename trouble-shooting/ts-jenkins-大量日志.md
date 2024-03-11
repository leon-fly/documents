---
date: "2018-01-01"
draft: false
lastmod: "2018-01-01"
publishdate: "2018-01-01"
tags:
- trouble-shooting
title: ts-jenkins-大量日志
---
# jenkins问题

## 💣 大量日志 

**Time : 2019/11/14**
**Issue Description:**

jenkins运行过程中短时间产生几十GB的日志

```
        question:      [DNSQuestion@1797746173 type: TYPE_IGNORE index 0, class: CLASS_UNKNOWN index 0, name: ]
        question:      [DNSQuestion@714133012 type: TYPE_IGNORE index 0, class: CLASS_UNKNOWN index 0, name: ]
        question:      [DNSQuestion@487856828 type: TYPE_IGNORE index 0, class: CLASS_UNKNOWN index 0, name: ]
        question:      [DNSQuestion@506788622 type: TYPE_IGNORE index 0, class: CLASS_UNKNOWN index 0, name: ]
        question:      [DNSQuestion@1319904688 type: TYPE_IGNORE index 0, class: CLASS_UNKNOWN index 0, name: ]
        question:      [DNSQuestion@1650500127 type: TYPE_IGNORE index 0, class: CLASS_UNKNOWN index 0, name: ]
        question:      [DNSQuestion@1595708693 type: TYPE_IGNORE index 0, class: CLASS_UNKNOWN index 0, name: ]
        question:      [DNSQuestion@1724508531 type: TYPE_IGNORE index 0, class: CLASS_UNKNOWN index 0, name: ]
        question:      [DNSQuestion@1231540671 type: TYPE_IGNORE index 0, class: CLASS_UNKNOWN index 0, name: ]
```

**👉 解决方案：**
方案一、临时方案
配置日志相关参数，[关掉不必要的日志](https://my.oschina.net/mrpei123/blog/1810647);

方案二、 终极方案 [官方参考资料](https://issues.jenkins-ci.org/browse/JENKINS-10160)

注意清理空间删除日志文件时，如果你的jenkins是运行的需要先停掉再重新启动，不然没法释放空间。
