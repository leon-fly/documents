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

   全局安全配置->安全域-> jenkins专有用户数据库
   
7. 










