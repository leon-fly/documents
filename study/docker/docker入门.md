---
date: "2018-01-01"
draft: false
lastmod: "2018-01-01"
publishdate: "2018-01-01"
tags: 
- docker
title: docker入门
---
<!-- TOC -->

- [1. docker安装](#1-docker安装)
- [2. image文件](#2-image文件)
- [3. 容器文件](#3-容器文件)
- [4. docker file](#4-docker-file)
- [5. docker常用命令](#5-docker常用命令)
- [6. 参考文档](#6-参考文档)

<!-- /TOC -->
# 1. docker安装
使用apt-get可以很快完成相关安装，[官网](https://docs.docker.com/install/linux/docker-ce/ubuntu/)操作步骤已很清晰，可参考。

**<font color='red'>注意：</font>**

当安装好后直接运行docker会提示：

```
Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get http://%2Fvar%2Frun%2Fdocker.sock/v1.24/images/json: dial unix /var/run/docker.sock: connect: permission denied
```

**原因：**

docker进程使用Unix Socket而不是TCP端口。而默认情况下，Unix socket属于root用户，需要root权限才能访问。

**解决方案：**

* 方式一：用sudo权限执行docker

* 方式二：docker守护进程启动的时候，会默认赋予名字为docker的用户组读写Unix socket的权限，因此只要创建docker用户组，

  并将当前用户加入到docker用户组中，那么当前用户就有权限访问Unix socket了，进而也就可以执行docker相关命令。

  ```
  sudo groupadd docker     # 添加docker用户组 （如果该组已经存在直接忽略）
  sudo gpasswd -a $USER docker     # 将登陆用户加入到docker用户组中
  newgrp docker     # 更新用户组
  docker ps    # 测试docker命令是否可以直接使用(不用sudo)
  ```

# 2. image文件
docker把应用程序打包到image中，通过该文件生成docker容器。image 是二进制文件。实际开发中，一个 image 文件往往通过继承另一个 image 文件，加上一些个性化设置而生成。

# 3. 容器文件
通过image文件生成的容器实例本身也是文件，称为容器文件。关闭容器不会删除容器文件。

# 4. docker file
用来生成image文件的配置文件，它包含了Docker映像所需要的指令。通过docker file，docker能够自动读取并解析其中的指令，并构建docker映像包
docker file分为四部分：
* 基础映像信息
* 维护者信息
* 映像操作命令
* 容器启动命令
主要内容如下：

|  命令     |   描述    |
|  ---  |  ---  |
|   FROM \<image>:\<tag>    |  表示获取docker基本映像。如果不指定映像url则默认从docker hub获取     |
|  MAINTAINMAINTAINER \<name> \<email>     |   指定维护者的姓名和联系方式    |
|  RUN <command>     | 在docker里面运行shell命令，等价于docker run \<image> \<command>      |
|  WORKDIR \<path>     |   添加到应用的目录、文件到docker容器中，src是相对于应用程序的相对文件路径，可以是文件，也可以是目录；\<des>是docker容器内文件或者目录的绝对路径    |
|  EXPOSE \<port>     |   docker容器和docker主机的端口映射关系    |
|  CMD \<command>     |   docker容器运行时的默认命令    |


[dockerfile 官方完整内容](https://docs.docker.com/engine/reference/builder/)


# 5. docker常用命令
获取镜像列表
> $ docker image ls

删除镜像
> $ docker image rm [imageName]

镜像拉取
> $ docker image pull library/hello-world

镜像运行(命令会从 image 文件，生成一个正在运行的容器实例)
> $ docker container run hello-world

镜像运行停止
> $ docker container kill [containID]

列出本机正在运行的容器
> $ docker container ls

列出本机所有容器，包括终止运行的容器
> $ docker container ls --all

移除容器文件
> $ docker container rm [containerID]

进入容器(有多种方式，以下为简洁方式)

> sudo docker exec -it [containerID] /bin/bash   

[参考命令大全](https://www.runoob.com/docker/docker-command-manual.html)



# 6. 参考文档
👉 [阮一峰 Docker 入门教程](https://www.ruanyifeng.com/blog/2018/02/docker-tutorial.html)

👉 《微服务架构与实践》王磊著
