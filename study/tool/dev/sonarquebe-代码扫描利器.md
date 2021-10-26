---
date: "2018-01-01"
draft: false
lastmod: "2018-01-01"
publishdate: "2018-01-01"
tags:
- dev
- tool
title: sonarquebe-代码扫描利器
---
## 关于sonarquebe



## Quick start the server （示例6.7）

[社区版使用及下载](https://www.sonarqube.org/downloads/),链接中有所有历史版本，一般使用哪个版本扫描需要看你的项目使用的jdk, sonarquebe 6.x.x支持open jdk1.8。 每个版本都有具体的document。

sonarquebe不需要安装，解压压缩包进入bin目录下，找到当前系统的子目录，选择sonar脚本启动即可。比如对于mac:

进入启动命令目录:

> cd sonarqube-6.7.7/bin/macosx-universal-64

执行启动：

> ./sonar.sh start

访问：

http://localhost:9000/

登录



## Scan the project

基于maven的项目执行如下：

> mvn clean package -Dmaven.test.skip=true sonar:sonar  -Dsonar.host.url=http://localhost:9000 -Dsonar.login=ef558e59e27597c88eb34ab5acb8a254c3c63d7c 

login值为一个token，登录管理平台获取：

> Administration -> Security -> Users 

如果缺少package参数可能报错 ：

```
Please provide compiled classes of your project with sonar.java.binaries
```

对于依赖包的问题扫描可以通过安装dependency-checker插件来支持，这个插件需要高版本的sonar支持，6.x.x下不支持。

