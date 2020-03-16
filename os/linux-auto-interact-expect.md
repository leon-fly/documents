---
date: "2020-03-15"
draft: false
lastmod: "2020-03-15"
publishdate: "2020-03-15"
tags:
- os
- linux
title: linux自动交互-expect
---

# linux自动交互-expect
在linux脚本执行中有时需要进行交互输入，比如输入密码。expect是一个不错的方式。

## 1. expect安装

* apt安装
    > sudo apt install expect

* 验证
    > whereis expect

    结果：
    > expect: /usr/bin/expect /usr/share/man/man1/expect.1.gz

## 2. 使用示例
示例: 执行git pull, 过程需要输入密码完成操作
```
#!/usr/bin/expect
# 进入git目录
cd /home/ops/git-doc

# 使用命令spawn运行git命令（需要交互的命令），会fork一个子进程，后续的expect的相关命令都是围绕该进程通信
spawn git pull

# 等待命令返回时间，超时之后执行后面的命令。-1代表不超时
set timeout 60

# 判断命令返回中预期内容
expect "*passphrase*"

# 交互信息（模拟输入密码）,\r 代表回车,重要
send "mypassword\r"

# 执行完成后保持交互状态，控制权交给控制台(手工操作)。否则会完成后会退出。
interact
```

## 3. bash环境下使用expect
有时候expect需要在bash环境下执行，比如cron(运行在bash环境) + expect，上面示例中的脚本将无法正常执行。需要通过改写为bash环境：

```
#!/bin/sh
echo "$(date) git pull start..."
expect <<!
cd /home/ops/git-doc
set timeout 120
spawn git pull
expect "*passphrase*"
send "mypassword\r"
expect eof
!
echo "$(date) git pull finished"
```

## 4. 相关技术文档 
[命令清单传送门](https://man.linuxde.net/expect1)