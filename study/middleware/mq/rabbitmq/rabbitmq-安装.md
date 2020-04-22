---
date: "2018-01-01"
draft: false
lastmod: "2018-01-01"
publishdate: "2018-01-01"
tags:
- middleware
- mq
- rabbitmq
title: rabbitmq-安装
---
## 1. 系统环境环境

```
uname -a

Linux leon-aliyun 4.15.0-52-generic #56-Ubuntu SMP Tue Jun 4 22:49:08 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
```

## 2. rabbitmq安装
安装版本 V3.6.10

### 2.1. 本服务器使用apt进行安装

> sudo apt update

> sudo apt install rabbitmq-service

### 2.2. 启动
> rabbitmq-server

以上命令将启动一个前台rabbitmq实例，如果需要后台守护进程方式启动加参数[-detached]，如下:
> rabbitmq-server -detached


### 2.3. 服务器管理：
* 启动管理服务rabbitmq-plugins enable rabbitmq_management(如果服务是启动的需要重启生效)
* 访问：http://hosthost:15672/  (15672是默认端口)  默认用户guest/guest

### 2.4. 关闭

#### 2.4.1. 关闭整个节点(包括应用程序)
* rabbitmqctl stop 

    该命令可以指定（远程）节点，示例：
    > rabbitmqctl stop -n rabbitmq@hostname

#### 2.4.2. 关闭应用程序
* rabbitmqctl stop_app

    该命令仅停止rabbitmq上的应用，可以指定关闭的（远程）节点，示例：
    > rabbitmqctl -n rabbit@leon-aliyun stop_app


