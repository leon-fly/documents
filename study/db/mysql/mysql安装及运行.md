---
date: "2018-01-01"
draft: false
lastmod: "2018-01-01"
publishdate: "2018-01-01"
categorys:
- 中间键
tags:
- db
- mysql
- hands-on
title: mysql安装及运行
---
# 一、安装

## 1.在线安装
在线安装安装和启动方式较简单，可以使用yum/homebrew/apt 等方式进行安装。

### mac安装示例：

> brew install mysql@5.7

启动

> brew services start mysql@5.7

查看启动情况

> brew services list --json

###  mac M1 基于docker安装mysql 5.7:

拉取镜像（不可以使用mysql:5.7，存在内核不匹配问题）：

> docker pull ibex/debian-mysql-server-5.7

启动容器

> docker run --name mysql-test -p 3306:3306 -d -e MYSQL_ROOT_PASSWORD=1qaz2wsx -e MYSQL_ROOT_HOST=% ibex/debian-mysql-server-5.7

[详细参考这里](https://juejin.cn/post/7039024521159901197)



**考虑到该数据库会被多次使用，可以为其建立本地存储卷，后续即使容器删除，仍然可以通过关联使用原有数据。**

创建本地存储卷

> docker volume create mysql-docker-volume

查看创建结果

> docker volume ls

将mysql数据库数据关联到本地卷

> docker run --name mysql-test -p 3306:3306 -v mysql-docker-volume:/var/lib/mysql -d -e MYSQL_ROOT_PASSWORD=1qaz2wsx MYSQL_ROOT_HOST=% ibex/debian-mysql-server-5.7





## 2.离线安装(解压版)

1. 官方下载安装包mysql-5.7.23-el7-x86_64.tar.gz
2. 创建mysql管理用户及组，使用该用户组进行操作。
3. 解压到软件目录，当前为/usr/local,将根目录修改为mysql(原命名太长繁琐)

	```
	参考：
	tar zxvf mysql-5.7.23-el7-x86_64.tar.gz
	cp  mysql-5.7.23-el7-x86_64  /usr/local/
	mv mysql-5.7.23-el7-x86_64  mysql
	
	```
4. 确认文件所属为后期mysql使用用户

	```
	参考命令：
	sudo chown username:groupname  mysql
	
	```

# 二、配置

1. 编辑配置文件/etc/my.cnf

	```
	参考配置：
	[client]
	default-character-set=utf8
	
	[mysqld]
	#以下参数设置后可以不用密码直接连接，root密码忘记时使用。
	#skip-grant-tables
	default-storage-engine=INNODB
	character-set-server=utf8
	collation-server=utf8_general_ci

	```

2. 编辑启动、关闭文件

	```
	启动文件/usr/local/mysql/startmysql.sh :
	/usr/local/mysql/bin/mysqld_safe --defaults-file=/etc/my.cnf --user=mysql &
	
	关闭文件/usr/local/mysql/shutdownmysql.sh :
	/usr/local/mysql/bin/mysqladmin -u root -p shutdown
	
	```

3. 启动服务
	```
	使用startmysql.sh
	
	```
	说明：mysql centos（mysql-5.7.23）安装及运行

# 三、避坑

1. mysql 版本8.0+ 服务连接时客户端报错 **Public Key Retrieval is not allowed**

   原因：mysql 8.0添加了**caching_sha2_password**作为默认认证插件，这个插件使用RSA公钥加密来保护用户密码传输, 在连接时没有使用ssl时 

   1. 客户端连接url增加sslMode=required （优先方案）
   2. 客户端连接时增加参数serverRSAPublicKeyFile=path/to/file.pem, 路径需求修改为密钥实际存放的文件位置，密钥通过如下sql查询`SHOW STATUS LIKE 'Caching_sha2_password_rsa_public_key';`（ 客户端连接失败时在服务器端通过mysql客户端连接 `mysql -uroot -p密码`）
   3. 客户端连接url增加参数allowPublicKeyRetrieval=true， 该方案存在一定的安全隐患,可能允许恶意代理执行 MITM 攻击以获取明文密码，不推荐。

