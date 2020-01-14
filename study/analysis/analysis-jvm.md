<!-- TOC -->

- [jvm分析](#jvm分析)
    - [一、常用命令及参数](#一常用命令及参数)
        - [查看当前java参数](#查看当前java参数)
        - [查看](#查看)
        - [打印GC相关日志](#打印gc相关日志)
        - [类加载及卸载跟踪](#类加载及卸载跟踪)
        - [打印系统运行相关参数](#打印系统运行相关参数)
        - [堆的设置](#堆的设置)
        - [方法区配置](#方法区配置)
        - [栈配置](#栈配置)
        - [直接内存配置](#直接内存配置)
    - [二、垃圾回收算法](#二垃圾回收算法)
        - [引用计数法](#引用计数法)
        - [标记清除法](#标记清除法)
        - [复制算法](#复制算法)
        - [标记压缩法（标记清除压缩算法）](#标记压缩法标记清除压缩算法)
        - [分代算法](#分代算法)
        - [分区算法](#分区算法)
    - [三、java引用及垃圾回收](#三java引用及垃圾回收)
    - [垃圾收集器](#垃圾收集器)
        - [串行回收器](#串行回收器)
        - [并行回收器（ParNew）](#并行回收器parnew)
        - [CMS回收器（Concurrent Mark Sweep）](#cms回收器concurrent-mark-sweep)
        - [G1回收器（自1.7）](#g1回收器自17)
    - [四、性能监控](#四性能监控)
        - [监控命令](#监控命令)
        - [jdk性能监控工具](#jdk性能监控工具)
        - [图形化监控工具](#图形化监控工具)

<!-- /TOC -->

# jvm分析
参考书单
* <实战java虚拟机 jvm故障诊断及性能调优>  葛一鸣

## 一、常用命令及参数
### 查看当前java参数
> java -XshowSettings:all

### 查看
java -XX:+PrintFlagsFinal -version

示例
```
VM settings:
    Max. Heap Size (Estimated): 1.78G
    Ergonomics Machine Class: server
    Using VM: Java HotSpot(TM) 64-Bit Server VM

Property settings:
    awt.toolkit = sun.lwawt.macosx.LWCToolkit
    file.encoding = UTF-8
    file.encoding.pkg = sun.io
    file.separator = /
    ...
```

### 打印GC相关日志
* 打印GC普通信息
> -XX:+PrintGC

GC示例
```
[GC (Allocation Failure)  311109K->311878K(454144K), 0.1617940 secs]
[Full GC (Ergonomics)  311878K->310823K(622592K), 0.0647834 secs]
```

第一行为普通GC第一个数据[311109k]为回收前堆空间使用量，第二个数据[311878K]为回收后堆内存使用量，第三个数据[454144K]为当前申请的总堆空间大小（注意并非未使用的空间），当堆内存大小未达到最大时可以持续申请。第四个数据[0.1617940 secs]为当前GC耗时。
第二行为FullGC,并非每次GC都会伴随FullGC


* 打印GC详细信息
> -XX:+PrintGCDetails

示例
```
[GC (Allocation Failure) [PSYoungGen: 37134K->4752K(71680K)] 61719K->61080K(159232K), 0.0220931 secs] [Times: user=0.02 sys=0.04, real=0.02 secs] 
[Full GC (Ergonomics) [PSYoungGen: 4752K->0K(71680K)] [ParOldGen: 56328K->60962K(133120K)] 61080K->60962K(204800K), [Metaspace: 3203K->3203K(1056768K)], 0.0123164 secs] [Times: user=0.02 sys=0.00, real=0.01 secs] 
```
说明：
**PSYoungGen** 年轻代，同DefNew
**ParOldGen** 年老代，同Tenured
**Metaspace** 永久代（类方法存储区）,同Perm

* 在GC时打印堆信息
> -XX:+PrintHeapAtGC
加入该参数后，jvm会在每次GC前后分别打印堆信息
堆信息示例：
```
 PSYoungGen      total 208384K, used 4128K [0x0000000795580000, 0x00000007ab980000, 0x00000007c0000000)
  eden space 203264K, 0% used [0x0000000795580000,0x0000000795580000,0x00000007a1c00000)
  from space 5120K, 80% used [0x00000007a1c00000,0x00000007a2008040,0x00000007a2100000)
  to   space 5120K, 0% used [0x00000007ab480000,0x00000007ab480000,0x00000007ab980000)
 ParOldGen       total 652800K, used 646703K [0x0000000740000000, 0x0000000767d80000, 0x0000000795580000)
  object space 652800K, 99% used [0x0000000740000000,0x000000076778bca0,0x0000000767d80000)
 Metaspace       used 3238K, capacity 4496K, committed 4864K, reserved 1056768K
  class space    used 350K, capacity 388K, committed 512K, reserved 1048576K
```

说明：
**used数据**[0x0000000795580000,0x0000000795580000,0x00000007a1c00000)分别表示下界、当前上界、上界，可以通过这三个数据计算出当前已使用和当前可使用空间以及当前总申请空间。

* 额外打印GC发生的时间，以JVM启动偏移时间
> -XX:+PrintGCTimeStamps

* 打印应用时间执行时间和停顿时间
> -XX:+PrintGCApplicationConcurrentTime

> -XX:+PrintGCApplicationStoppedTime

* 跟踪系统内软引用、弱引用、虚幻引用和finallize队列
> -XX:+PrintReferenceGC

* GC日志输出指定
> -Xloggc:path

### 类加载及卸载跟踪

* 跟踪加载及卸载
> -verbose:class

* 跟踪加载
> -XX:+TraceClassLoading

* 跟踪卸载
> -XX:+TraceClassUnloading

### 打印系统运行相关参数
* 打印系统运行的参数
> -XX:+PrintVMOptions

* 打印传递给虚拟机的显式或饮式参数
> -XX:+PrintCommandLineFlags

* 打印所有系统参数
> -XX:+PrintFlagsFinal

### 堆的设置

* 初始堆空间
> -Xms 

* 最大堆空间
> -Xmx

* 新生代空间
> -Xmn

说明:
新生代增大会减小老年代的大小，堆GC影响较大，新生代大小一半设置整个堆空间的1/3到1/4。

* 设置新生代eden与from/to到空间比例
> -XX:SurvivorRatio=

说明:
正常设置2，即eden:from:to = 2:1:1。特殊情况需要特别考虑。

* 设置新生代和老年代的比例,改比例=老年代/新生代
> -XX:NewRatio=

* **堆溢出处理**

堆溢出导出整个堆信息
> -XX:+HeapDumpOnOutOfMemoryError

指定到处路径
> -XX:HeapDumpPath=

堆溢出时执行一个脚本文件
> -XX:OnOutOfMemoryError=

### 方法区配置
jdk 1.6/1.7 
> -XX:PermSize
> -XX:MaxPermSize

jdk 1.8
> -XX:MaxMetaspaceSize=

说明：1.8默认情况下永久区最大只受系统可用内存限制。

### 栈配置

栈空间是每个线程到私有空间，参数配置：
> -Xss

### 直接内存配置

被NIO广泛使用，直接内存跳过了java堆，使java程序可以直接访问堆空间，一定成程度上加快了内存空间访问速度。
> -XX:MaxDirectMemorySize

直接内存适合申请次数较少，访问较频繁堆场合。


## 二、垃圾回收算法

### 引用计数法
* 原理：每个对象创建一个计数器，当有一个对象引用它时计数加1，当引用失效时计数减1，当计数为0时不可再引用。
* 存在如下问题，jvm垃圾回收未使用该算法
    * 循环引用导致内存泄漏（如A、B互相引用，无第三个对象对A或B引用，但是A、B的计数都不为0无法回收）
    * 引用计算器在引用和失效时需要对计数器进行操作，对系统性能有影响。

### 标记清除法
* 原理：从根结点开始遍历可达对象并标记，清理阶段对未标记的对象进行清理
* 缺点：回收的空间不连续，在对象的堆空间分配过程中，工作效率地下。

### 复制算法
* 原理：将原有空间分成两块，每次使用一块，在垃圾回收时把正在使用中的内存中的存活对象沪指到未使用的内存中，之后清理正在使用的内存中的所有对象，交换两个内存角色。
* 优点：无内存碎片，
* 缺点：空间使用率折半，当存活对象较多时，需要复制的对象也多。
* 复制算法比较适合新生代，新生代垃圾对象通常多余存活对象。

### 标记压缩法（标记清除压缩算法）
* 原理：优化标记清除，清除阶段将所有存活对象压缩到内存另一端，之后清理边界外多所有空间。相当于在标记清除多基础上加了内存整理。

### 分代算法
* 新生代使用复制算法，老年代使用标记压缩或者标记清除算法
* 卡表数据结构优化高频率多新生代回收（卡表多1位来表示老年代一个4k空间多老年代中多对象是否持有新生代对象，如果该位为1表示有，GC时需要扫描该空间多引用关系，为0跳过）

### 分区算法
* 原理：将大的堆内存空间分成若干小块，每次回收若干块，而不是一次性回收，根据目标停顿时间来合理的回收。这种方法容易控制在GC多卡顿时间。


## 三、java引用及垃圾回收
* 强引用
* 软引用-内存紧张时回收
* 弱引用-发现即回收
* 虚引用-最弱，发现即回收，必须和引用队列一起使用，用于对象回收跟踪

**说明：**
软引用和弱引用适用于缓存处理。


## 垃圾收集器

### 串行回收器
* java最古老的垃圾回收器之一，仅仅使用单线程进行独占式的垃圾回收，造成其他线程进入等待，产生糟糕的用户体验。

* jvm client运行模式下的默认垃圾回收器

### 并行回收器（ParNew）

* 垃圾回收器指定

### CMS回收器（Concurrent Mark Sweep）

* 该回收器关注系统停顿时间

### G1回收器（自1.7）

* 作为CMS回收器都替代者

## 四、性能监控
### 监控命令
* top 实时显示个进程资源占用及系统统计信息
* vmstat 查看内存、交互分区、I/O操作、上下文切换、时钟中断以及CPU使用情况
* iostat io监控
* pidstat 可以监视 **进程** 和 **线程** 的性能(内存、cpu、io等)情况，结合jstack可以很快等查处相关性能问题代码
示例：查看进程号为1108的cpu使用情况，并详细显示其线程。
> pidstat -p 1108 1 5 -u -t 

* jstack 查看java应用程序下所有线程
>jstack -l pid

### jdk性能监控工具
* jps 显示当前所有java进程的相关信息
> jps -q  只显示进程id

> jps -m 输入传递给java进程（主函数）的参数

> jps -l 输出主函数的完整路径

> jps -v 显示传递给java虚拟机的参数

* jstat 用于观察java应用程序运行时相关信息的工具，极其强大。

* jinfo 查看虚拟机参数

* jmap 导出堆信息到文件

> jmap -histo 2792 > ./map.txt  生成进程号2972的java程序的对象统计信息并输出到map.txt

> jmap -dump:format=b,file=./heap.hprof 2792 导出进程为2972的堆快照到heap.hprof,可用于进行分析

> jmap -permstat 2792  查看系统的ClassLoader信息

> jmap -finalizerinfo 2792   查看系统finalizer队列中的对象

* jhat 分析java应用程序堆快照内容
> jhat ./heap.hprof 分析完成后访问 http://127.0.0.1:7000 可以查看相关分析结果信息

* jstack查看线程堆栈
> jstack -l pid  参数l用于输出锁相关信息

* jstatd 远程主机信息收集。可以理解为一个代理服务，服务启动后一些本地命令可以收集远程主机的信息

* jcmd (from 1.7) 多功能工具，可以用它来导出堆、查看java进程、导出线程信息、执行GC

> jcmd -l 列出当前系统中的所有java虚拟机

> jcmd pid help 列出指定虚拟机所支持的命令

```
~$ jcmd 4835 help
e
4835:
The following commands are available:
JFR.stop
JFR.start
JFR.dump
JFR.check
VM.native_memory
VM.check_commercial_features
VM.unlock_commercial_features
ManagementAgent.stop
ManagementAgent.start_local
ManagementAgent.start
GC.rotate_log
Thread.print
GC.class_stats
GC.class_histogram
GC.heap_dump
GC.run_finalization
GC.run
VM.uptime
VM.flags
VM.system_properties
VM.command_line
VM.version
help
```

* hprof 性能统计工具，非独立监控工具，只是一个java agent工具。使用该工具可以查看各个函数的CPU占用时间

> java -agentlib:hprof=help 查看hprof的帮助文档

### 图形化监控工具

* JConsole 查看应用程序情况，包括堆内存使用情况、系统线程数量、加载类的数量及CPU使用率,虚拟机参数，检测死锁等。
    * 该工具在javahome的bin目录下

* Visual VM 功能强大等多合一故障诊断和性能监控的可视化工具，可以替代jstat、jmap、jhat、jstack升至JConsole，支持各类插件扩展