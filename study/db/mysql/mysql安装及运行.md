#一、安装

##1.在线安装
在线安装安装和启动方式较简单，可以使用yum/homebrew/apt 等方式进行安装。

##2.离线安装(解压版)
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


#二、配置

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

