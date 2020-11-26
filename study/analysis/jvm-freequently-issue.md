---
date: "2018-01-01"
draft: false
lastmod: "2018-01-01"
publishdate: "2018-01-01"
tags:
- analysis
title: jvm-freequently-issue
---
## 1. CPU使用超高

整体思路：找到耗费CPU的进程，再定位到线程，最后定位代码。线程代码定位使用jstack，其信息中线程id是用十六进制（Ox）表示的，所以定位具体线程需要进行将十进制的线程id转换为16进制再查找。

* step 1: 找到cpu使用多的进程

    > top > T(CPU占用可视化) > c(显示完整命令) > P(按照cpu使用率来来排行找到最耗cpu的进程)

* step 2: 找到cpu占用最多的进程,time最长的就是对应的线程

    > top -Hp pid (time最长的即最耗cpu的，pid即为对应的线程id)
    或者

    > ps -Lfp pid (time最长的即最耗cpu的，LWP即为对应的线程id)

* step 3: 转换16进制线程id

    > printf "%x\n" pid   time最长的即最耗cpu的，pid即为对应的线程id

* step 4: 通过jstack找到对应消耗cpu的代码块

    > jstack pid > jstackinfo.txt 导出后查找16进制的线程id，便找到来相关代码行


## 2. 死锁检查

使用jstack获取栈信息，如果存在死锁，信息末尾汇总会有相关死锁信息打印。

> jstack pid

示例死锁信息（行首的数字是行号，忽略）

```
101 Found one Java-level deadlock:
102 =============================
103 "Thread-0":
104   waiting for ownable synchronizer 0x00000000c6158db0, (a java.util.concurrent.locks.ReentrantLock$NonfairSync),
105   which is held by "Thread-1"
106 "Thread-1":
107   waiting for ownable synchronizer 0x00000000c6158d80, (a java.util.concurrent.locks.ReentrantLock$NonfairSync),
108   which is held by "Thread-0"
109
110 Java stack information for the threads listed above:
111 ===================================================
112 "Thread-0":
113         at jdk.internal.misc.Unsafe.park(java.base@11.0.6/Native Method)
114         - parking to wait for  <0x00000000c6158db0> (a java.util.concurrent.locks.ReentrantLock$NonfairSync)
115         at java.util.concurrent.locks.LockSupport.park(java.base@11.0.6/LockSupport.java:194)
116         at java.util.concurrent.locks.AbstractQueuedSynchronizer.parkAndCheckInterrupt(java.base@11.0.6/AbstractQu    euedSynchronizer.java:885)
117         at java.util.concurrent.locks.AbstractQueuedSynchronizer.acquireQueued(java.base@11.0.6/AbstractQueuedSync    hronizer.java:917)
at java.util.concurrent.locks.AbstractQueuedSynchronizer.acquire(java.base@11.0.6/AbstractQueuedSynchroniz    er.java:1240)
119         at java.util.concurrent.locks.ReentrantLock.lock(java.base@11.0.6/ReentrantLock.java:267)
120         at DeadLockDemo.lambda$main$0(DeadLockDemo.java:21)
121         at DeadLockDemo$$Lambda$1/0x0000000840060840.run(Unknown Source)
122         at java.lang.Thread.run(java.base@11.0.6/Thread.java:834)
123 "Thread-1":
124         at jdk.internal.misc.Unsafe.park(java.base@11.0.6/Native Method)
125         - parking to wait for  <0x00000000c6158d80> (a java.util.concurrent.locks.ReentrantLock$NonfairSync)
126         at java.util.concurrent.locks.LockSupport.park(java.base@11.0.6/LockSupport.java:194)
127         at java.util.concurrent.locks.AbstractQueuedSynchronizer.parkAndCheckInterrupt(java.base@11.0.6/AbstractQu    euedSynchronizer.java:885)
128         at java.util.concurrent.locks.AbstractQueuedSynchronizer.acquireQueued(java.base@11.0.6/AbstractQueuedSync    hronizer.java:917)
129         at java.util.concurrent.locks.AbstractQueuedSynchronizer.acquire(java.base@11.0.6/AbstractQueuedSynchroniz    er.java:1240)
130         at java.util.concurrent.locks.ReentrantLock.lock(java.base@11.0.6/ReentrantLock.java:267)
131         at DeadLockDemo.lambda$main$1(DeadLockDemo.java:33)
132         at DeadLockDemo$$Lambda$2/0x0000000840061040.run(Unknown Source)
133         at java.lang.Thread.run(java.base@11.0.6/Thread.java:834)
134
135 Found 1 deadlock.
```

## 3. 内存泄漏（堆溢出宕机）

内存泄漏是生产故障的一种常见问题，避免这种问题首先要在编码过程中注意，期次需要必要的预警系统对服务器内存进行监控，当内存使用达到设定阀值进行告警，防患于未然，当然也会存在告警之后不能快速解决最终还是宕机对情况。

此类问题分析需要提供jvm堆栈信息信息，通过对堆栈信息分析找出大量占用空间对数据，并对其分析是否存在泄漏情况。而堆栈信息可以通过手动和（宕机时）自动生成。

* 配置自动生成dump文件(java启动命令追加参数)：

    > -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=your_file_name.hprof

* 手动生成dump文件

    > jmap -dump:live,format=b,file=m.hprof PID

    说明：m.hprof为导出对文件，自行指定
* dump文件分析
    * 使用visualVM、JConsole等可视化工具将dump文件导入分析
    * 使用mat（memory analyzer tool）进行分析，当dump文件比较大时使用此工具可以很好当解决传输耗时、工具无法加载当问题

## 4. 栈溢出
栈溢出问题出现对原因一般有以下集中：
* 栈空间设置不合理，过小导致。
* 递归嵌套过深或者调用循环等 

通过堆栈打印错误信息结合以上比较容易分析出具体原因

## 5. 未明原因卡顿/响应慢

有时候生产问题并非明确的知道原因，比如用户反馈操作太慢了。针对这类问题我们需要收集相关信息（用户的反馈、系统信息收集）从全局角度出发进行分析解决。

**解决思路**
明确是全部功能还是局部功能，缩小问题范围并针对可疑点进行检测及解决


**导致大范围服务响应慢的可能因素：**
* 集群服务器硬件资源使用过高
* 数据库层面的链接数不足等资源等待
* 链路网络问题
* jvm设置参数不合理导致资源使用率上不去，高频率的fullgc

**导致小范围服务响应慢的可能因素：**
* 数据库锁等待
* 内部资源锁等待
* 查询数据量过多
* 依赖第三方服务响应慢
* 程序设计性能较低