---
date: "2018-01-01"
draft: false
lastmod: "2020-04-18"
publishdate: "2018-01-01"
tags:
- os
- linux
title: linux常用操作
---
## 1. 系统信息查看

### 1.1. cpu信息查看

1.1 查看CPU个数

> cat /proc/cpuinfo | grep "physical id" | uniq | wc -l

1.2 查看CPU核数

> cat /proc/cpuinfo | grep "cpu cores" | uniq

1.3 查看CPU型号
> cat /proc/cpuinfo | grep 'model name' |uniq

### 1.2. 磁盘空间查看

2.1 查看系统空间
>  df -h

2.2 查看文件夹文件

> du -h [目录名]  查看指定文件夹下的所有文件大小（包含子文件夹）

> du -sh [目录名] 返回该文件夹大小

### 1.3. 查看系统版本

> uname -a

### 1.4. 系统使用情况查看

> free 查看瞬间运行存储空间

free -h 以更易于人读取的单位展示

显示示例如下：

```
              total        used        free      shared  buff/cache   available
Mem:       16266388     8114548      180968         768     7970872     2283412
Swap:             0           0           0
```

> uptime  

查看系统启动时间，用户数，平均负责.显示示例一下：

```
12:49:27 up 49 days, 18:27,  2 users,  load average: 1.17, 1.18, 1.07
```

> iostat 

用于监控统计系统输入输出设备和 CPU 的使用情况,格式：iostat [参数] [间隔时间] [报告次数]

iostat英文 I/O statistics 的缩写。它的特点是汇报磁盘活动统计情况，同时也会汇报出 CPU 使用情况

**常用参数**

```
-c 显示 CPU 使用情况
-d 显示磁盘使用情况
-k 以 KB 为单位显示
-m 以 M 为单位显示
-N 显示磁盘阵列(LVM) 信息
-n 显示 NFS 使用情况
-p[磁盘] 显示磁盘和分区的情况
-t 显示终端和 CPU 的信息
-x 显示详细信息
-V 显示版本信息
```

> vmstat
* 可以查看内存、交互分区、I/O操作、上下文切换、时钟中断以及CPU的使用情况
* 可以指定采样频率和采样次数，如每秒采样1次，共5次：vmstat 1 5 
显示示例：

```
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 0  0      0 1185628 271488 1725416    0    0     0     2    2    1  0  0 99  0  0
 0  0      0 1185660 271488 1725416    0    0     0     0 1381 2696  1  0 99  0  0
 0  0      0 1185660 271488 1725416    0    0     0     0 1287 2516  0  1 99  0  0
 0  0      0 1185544 271488 1725416    0    0     0     0 1447 2794  2  1 97  0  0
 0  0      0 1185568 271488 1725416    0    0     0     0 1288 2508  1  0 99  0  0
```

> pidstat

> [top](https://www.cnblogs.com/kelamoyujuzhen/p/10125512.html) 查看实时运行存储,显示示例：

```

top - 12:53:09 up 49 days, 18:31,  2 users,  load average: 1.18, 1.18, 1.09
Tasks: 129 total,   1 running, 128 sleeping,   0 stopped,   0 zombie
%Cpu(s): 21.8 us,  9.4 sy,  0.0 ni, 66.6 id,  2.3 wa,  0.0 hi,  0.0 si,  0.0 st
KiB Mem : 16266388 total,   182252 free,  8106548 used,  7977588 buff/cache
KiB Swap:        0 total,        0 free,        0 used.  2291220 avail Mem

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
 2570 mysql     20   0 2656316 464440    528 S 112.3  2.9   9133:17 mysqld
27285 jenkins   20   0  318644  97080   6556 S   5.7  0.6   4:25.36 python3
 2030 root      20   0  395572 101868   1600 S   2.3  0.6  70:11.45 falcon-agent
 3275 root      20   0    8024   7676    120 S   1.0  0.0   1:49.06 apps.plugin
19908 root      20   0  248188 109228   1656 S   1.0  0.7  85:13.31 YDService
20596 jenkins   20   0 5607864   1.1g  14260 S   0.7  7.4   3:28.53 java
 1611 root      20   0 3943024 193984      0 S   0.3  1.2 625:43.09 java
 6111 netdata   20   0    1612    960    604 S   0.3  0.0   0:02.16 bash
17757 netdata   20   0  105548 103700    452 S   0.3  0.6   7:21.55 netdata
17826 netdata   20   0  148256  11880   1672 S   0.3  0.1   2:23.75 python
    1 root      20   0   51748   2608   1220 S   0.0  0.0   4:39.50 systemd
    2 root      20   0       0      0      0 S   0.0  0.0   0:01.37 kthreadd
    3 root      20   0       0      0      0 S   0.0  0.0   1:53.38 ksoftirqd/0
    5 root       0 -20       0      0      0 S   0.0  0.0   0:00.00 kworker/0:0H
    7 root      rt   0       0      0      0 S   0.0  0.0   0:55.04 migration/0
    8 root      20   0       0      0      0 S   0.0  0.0   0:00.00 rcu_bh
    9 root      20   0       0      0      0 S   0.0  0.0  11:49.47 rcu_sched
   10 root       0 -20       0      0      0 S   0.0  0.0   0:00.00 lru-add-drain
   11 root      rt   0       0      0      0 S   0.0  0.0   0:13.13 watchdog/0
   12 root      rt   0       0      0      0 S   0.0  0.0   0:13.24 watchdog/1
   13 root      rt   0       0      0      0 S   0.0  0.0   0:55.58 migration/1
   14 root      20   0       0      0      0 S   0.0  0.0   1:51.16 ksoftirqd/1
   16 root       0 -20       0      0      0 S   0.0  0.0   0:00.00 kworker/1:0H
   17 root      rt   0       0      0      0 S   0.0  0.0   0:13.08 watchdog/2
   18 root      rt   0       0      0      0 S   0.0  0.0   0:54.48 migration/2
   19 root      20   0       0      0      0 S   0.0  0.0   1:48.75 ksoftirqd/2
   21 root       0 -20       0      0      0 S   0.0  0.0   0:00.00 kworker/2:0H
   22 root      rt   0       0      0      0 S   0.0  0.0   0:10.30 watchdog/3
   23 root      rt   0       0      0      0 S   0.0  0.0   0:57.33 migration/3
```

**关键参数说明：**

```
第一行
up  49days表示系统运行49天
2 users 表示当前登录用户两个
load average 表示1分钟、5分钟、15分钟内的平均负载。

第二行表示各状态下的任务数/进程数

第三行表示cpu使用占比
us, user： 运行(未调整优先级的) 用户进程的CPU时间
sy，system: 运行内核进程的CPU时间
ni，niced：运行已调整优先级的用户进程的CPU时间
wa，IO wait: 用于等待IO完成的CPU时间
hi：处理硬件中断的CPU时间
si: 处理软件中断的CPU时间
st：这个虚拟机被hypervisor偷去的CPU时间（译注：如果当前处于一个hypervisor下的vm，实际上hypervisor也是要消耗一部分CPU处理时间的）。

第四行和第五行表示内存使用情况

```


**交互模式命令：**

```
================================  综合： ================================
h 查看帮助
f 查看列全称,进入之后可以对列进行设置显示或不显示
u 查看指定用户的进程
c 查看完整的进程命令
k 给予某个 PID 一个讯号 (signal),杀掉进程
r 给予某个 PID 重新制订一个 nice 值。
q 离开 top 软件的按键。
s 更改top刷新时间，默认3s
i 隐藏idle状态的进程，只显示当前活跃的进程
1 查看各个cpu使用情况
H 线程查看

================================  图形化展示： ================================
m 查看图形化内存百分比
t 查看cpu使用百分比

================================  排序： ================================M 根据内存占用排序
P 根据cpu占用排序
M 根据内存使用排序
N 根据pid来排序
T 由该Process使用的cpu时间累计（TIME+）排序
```

* top -Hp pid 查看进程的线程信息

* [关于top的load average](http://www.ruanyifeng.com/blog/2011/07/linux_load_average_explained.html)

三个数据分别是1分钟、5分钟、15分钟内的系统负荷。

1. 单CPU下:
为了电脑顺畅运行，系统负荷最好不要超过1.0，这样就没有进程需要等待了，所有进程都能第一时间得到处理。很显然，1.0是一个关键值，超过这个值，系统就不在最佳状态了，你要动手干预了。

2. 系统负荷经验：
1.0是系统负荷的理想值吗？
不一定，系统管理员往往会留一点余地，当这个值达到0.7，就应当引起注意了。经验法则是这样的：
当系统负荷持续大于0.7，你必须开始调查了，问题出在哪里，防止情况恶化。
当系统负荷持续大于1.0，你必须动手寻找解决办法，把这个值降下来。
当系统负荷达到5.0，就表明你的系统有很严重的问题，长时间没有响应，或者接近死机了。你不应该让系统达到这个值。

3. 多核处理器
以上内容均为单核心的理论数据情况，当有多核或者多个CPU时，系统可以承受的值应该翻倍，如系统有两个CPU，每个CPU均为4核，那么负荷不超过8.0就表明电脑正常运行。

> htop


### 1.5. 系统进程查看

> ps

### 1.6. 网络状况查看

* 网络联通性查看
  > ping hostname/ip
  
  示例：
  ```
  ping www.baidu.com
  ping 118.132.34.211
  ```

* 端口可联通性
  > telnet hostname/ip port

  示例:
  ```
  telnet wwww.baidu.com 22
  ```


* 本地网络端口启用情况
  > netstat 

  示例:
  ```
  netstat -an
  netstat -tnlp
  ```
  > lsof -i
  示例： lsof -i tcp:8080 
* 查看域名映射信息（比如该域名有几台服务器负载）
  > dig

  示例：dig www.baidu.com

  > netstat -antlp
  
## 2. 字符处理

### 2.1. [awk文本分析工具](http://www.ruanyifeng.com/blog///awk.html)

1.1  基本语法

```
## 格式
$ awk 动作 文件名

## 示例
$ awk '{print $0}' demo.txt

```

* awk会根据空格和制表符，将每一行分成若干字段，依次用\$1,\$2,\$3代表第一个字段、第二个字段、第三个字段等等, $0代表整行

```
$ echo 'this is a test' | awk '{print $3}'

结果：
a
```

* 分隔符指定使用 -F

```
$ echo root:x:0:0:root:/root:/usr/bin/zsh|awk -F ':' '{ print $1 }'

结果：
root
```

1.2 变量

```
NF  当前行有多少个字段
NR  当前处理的是第几行
FILENAME    当前文件名
FS：字段分隔符，默认是空格和制表符。
RS：行分隔符，用于分割每一行，默认是换行符。
OFS：输出字段的分隔符，用于打印时分隔字段，默认为空格。
ORS：输出记录的分隔符，用于打印时分隔记录，默认为换行符。
OFMT：数字输出的格式，默认为％.6g。
```

示例

```
$ echo 'this is a test' | awk '{print $NF}'
结果：
test

$ awk -F ':' '{print $1, $(NF-1)}' demo.txt
结果：
root /root
```

1.3 函数

可以通过函数对字符串进行处理，常用函数如下：

```
toupper()：字符转大写
tolower()：字符转为小写。
length()：返回字符串长度。
substr()：返回子字符串。
sin()：正弦。
cos()：余弦。
sqrt()：平方根。
rand()：随机数。
```

示例

```
$ echo 'this is a test' | awk '{print toupper($3)}'
结果：
A
```

1.4 条件

awk允许指定输出条件，格式：
> awk '条件 动作' 文件名

示例

```
## 输出奇数行
$ awk -F ':' 'NR % 2 == 1 {print $1}' demo.txt


## 输出第三行以后的行
$ awk -F ':' 'NR >3 {print $1}' demo.txt

```

1.5 if语句

awk提供了if结构，用于编写复杂的条件。

示例: 输出第一个字段的第一个字符大于m的行

```
 $ awk -F ':' '{if ($1 > "m") print $1}' demo.txt
```

 if及else结构示例

 ```
$ awk -F ':' '{if ($1 > "m") print $1; else print "---"}' demo.txt
 ```

 1.5 for及while循环语句  

 ## 3. [grep文本搜索工具]()

 ## 4. [sed文本编辑工具]()

## 5. 文件操作

### 5.1. [find查找文件]()


## 6. 软件安装

> brew

> apt

> yum

## 7. 命令技巧
* ctrl+r  历史命令搜索

* history 历史命令

* 命令行快速操作

  > ctrl+a  跳行首

  > ctrl+e 跳行尾

  > ctrl+k 删除至行尾

  > esc+b 左移一个单词

  > esc+f 右移一个单词