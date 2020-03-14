# 系统环境环境

> 
```
uname -a

Linux leon-aliyun 4.15.0-52-generic #56-Ubuntu SMP Tue Jun 4 22:49:08 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
```

# rabbitmq安装

## 本服务器使用apt进行安装

> sudo apt update

> sudo apt install rabbitmq-service

## 启动
> rabbitmq-server

## 服务器管理：
* 启动管理服务rabbitmq-plugins enable rabbitmq_management(如果服务是启动的需要重启生效)
* 访问：http://hosthost:15672/  (15672是默认端口)  默认用户guest/guest