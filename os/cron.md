---
date: "2020-03-15"
draft: false
lastmod: "2020-03-15"
publishdate: "2020-03-15"
tags:
- os
- linux
title: linux定时任务
---

# Linux定时任务

## 1. cron
cron是定时任务核心库,可以作为linux一个服务运行，用于定时执行任务。常用命令（通用服务的命令）：

```
# 服务启动
service cron start

# 查看定时任务状态
service cron status

# 重新加载cron服务配置
service cron reload

# 重新启动cron服务
service cron restart

# 关闭cron服务
service cron stop
```

## 2. crontab
用来管理定时任务,使用方法较简单，参数如下：

```
usage:	crontab [-u user] file
	crontab [ -u user ] [ -i ] { -e | -l | -r }
		(default operation is replace, per 1003.2)
	-e	(edit user's crontab)
	-l	(list user's crontab)
	-r	(delete user's crontab)
	-i	(prompt before deleting user's crontab)
```

## 3. 任务配置
**命令：**
> crontab -e 

**配置格式：**
> cron-express command

示例：
> 0 0 * * *  /home/ops/start.sh  #每天0晨执行start.sh脚本

cron表达格式为： 
> 分钟  小时    日期    月份    星期

分钟　（0-59）
小時　（0-23）
日期　（1-31）
月份　（1-12）
星期　（0-6）//0代表星期天

示例：
> */2 * * * *   #每2分钟

> \* */2 * * * #每2小时

> 0 0 * * * #每天0晨

