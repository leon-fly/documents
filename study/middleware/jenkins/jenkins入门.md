---
date: "2020-07-11"
draft: false
lastmod: "2020-07-11"
publishdate: "2020-07-11"
tags:
- middleware
- nginx
title: jenkins入门
---

#  jenkins入门

## 1. jenkins下载及安装

系统环境Linux leon-aliyun 4.15.0-52-generic #56-Ubuntu SMP Tue Jun 4 22:49:08 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux

[官方安装手册](https://www.jenkins.io/doc/book/installing/)

当前jenkins版本2.235.1



1. 安装

```
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
    /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install jenkins
```

2. 修改相关配置

   配置目录/etc/default/jenkins，端口设置如下

   > HTTP_PORT=8081  #启动端口设置为8081

3. nginx配置，参考如下(非工业版)：

   ```
   server {
         listen          80;
         listen          [::]:80;
         root            /usr/share/nginx/html;
         server_name     jenkins.leonwang.tech;
         location / {
         		proxy_pass http://localhost:8081/;
         }
   }
   ```

4. 启动

   > service jenkins start

   日志目录 /var/log/jenkins/jenkins.log

5. 访问http://jenkins.leonwang.tech 进行登录并安装相关插件

   密码位置 /var/lib/jenkins/home/secrets/initialAdminPassword

6. 插件安装完成后需要修改密码，修改配置并重启

   修改配置文件/var/lib/jenkins/config.xml 配置段：

   ```
   <useSecurity>false</useSecurity>
   ```

   全局安全配置->安全域-> jenkins专有用户数据库。

   （ps：授权策略设置为登录用户可以做任何事。默认为任务用户可以做任何事，存在安全风险）

7. 配置一个任务

   **普通的基于github进行代码管理的java cicd任务配置关键如下：**

   1. 新建任务->输入任务名称->选择要创建的任务类型为流水线

   2. 配置构建触发器，选择触发远程构建，并设置令牌。

   3. 配置流水线，流水线选择pipeline script from SCM，SCM选择git。 

   4. 脚本路径填写进行编译、测试、部署的一个pipeline脚本文件，这个文件需要在工作空间（jenkins会根据项目名称生成工作空间名）下，否则会有提示该文件找不到。编译、测试、部署三阶段pipeline脚本框架文件示例：

      ```
      pipeline {
      	agent any
      		stages {
      			stage('build'){
      				steps {
      					echo 'start build!'
      					echo 'building...'
      					echo 'build finished!'
      				}
      			}
      			stage('test'){
      				steps {
      					echo 'start test!'
      					echo 'test...'
      					echo 'test finished!'
      				}
      			}
      			stage('depoly'){
      				steps {
      					echo 'depoly test!'
      					echo 'depoly...'
      					echo 'depoly finished!'
      				}
      			}
      		}
      }
      ```

      实际应用脚本中的操作步骤应该用具体的命令替换echo，如build阶段可能使用maven的命令进行编辑。

## 2. 避坑

### 2.1  构建触发器相关问题

按照平台指示生成的链接配置到github上时可能会出现http 403,提示No valid crumb was included in the request 

配置界面指示webhook配置地址为:

> JENKINS_URL`/job/my%20git%20document/build?token=`TOKEN_NAME` 或者 /buildWithParameters?token=`TOKEN_NAME

如：jenkins地址为http://www.leonwang.tech:9000/jenkins，则webhook配置地址为http://www.leonwang.tech:9000/jenkins/job/my%20git%20document/build?token=xxx

这种方式生成之后可能直接访问是可以触发的，当时配置到github会报错，需要在域名前加用户id值和token值：

> userid:token@JENKINS_URL`/job/my%20git%20document/build?token=`TOKEN_NAME

用户token可以在用户管理配置里面找到。

### 2.2 凭据管理

在配置任务的流水线定义使用pipeline script from SCM方式时，界面提供了凭据添加入口，添加完成后无变动，凭据选择列表不出现，可能是bug，需要在系统管理的 凭证管理进行配置。






