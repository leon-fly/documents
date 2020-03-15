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
以下示例
```
#!/usr/bin/expect
# 进入git目录
cd /home/ops/git-doc

# 使用expect内部命令spawn运行需要交互的命令
spawn git pull

# 等待命令返回
set timeout 5

# 判断命令返回中预期内容
expect "*passphrase*"

# 交互信息（模拟输入密码）,\r 代表回车,重要
send "mypassword\r"

# 执行完成后保持交互状态，控制权交给控制台(手工操作)。否则会完成后会退出。
interact
```

## 3. 相关技术文档
[传送门](https://man.linuxde.net/expect1)