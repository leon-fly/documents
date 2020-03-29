---
date: "2018-01-01"
draft: false
lastmod: "2018-01-01"
publishdate: "2018-01-01"
tags:
- os
- linux
title: linux通过ssh登陆
---

## 1. linux通过ssh登陆方式
### 1.1. 用户名密码登录
* 命令
	> ssh username@hostname
* 优缺点
	* 操作简单
	*  不能针对单一用户控制是否可登陆
### 1.2. 公钥认证
*  配置方式
	* /etc/ssh/sshd_config文件中配置启用公钥
	
	```
	PubkeyAuthentication yes
	AuthorizedKeysFile 	.ssh/authorized_keys .ssh/authorized_keys2
	```
	*  在需要使用公钥登录的用户目录创建公钥文件 /home/user/.ssh/authorized_keys，文件内容即为登录的客户端的公钥。
	*  客户端没有公钥？linux命令ssh-keygen可生成，私钥放在存储在客户端
			
		> ssh-keygen  -t  rsa
	* 登录失败问题排查。进入/var/log下查看登录日志，ubantu的日志文件名为auth.log,centos日志文件名为secure

