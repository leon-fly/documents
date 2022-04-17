---
date: "2018-01-02"
draft: false
lastmod: "2018-01-02"
publishdate: "2018-01-02"
tags: 
- docker
title: docker小练
---

## 创建一个小java项目docker-demo
[demo地址](https://github.com/leon-fly/demo/tree/master/docker-demo)
### demo项目说明：
* 由maven构建
* 测试主java类一个,类中启动了一个HttpServer监听请求

目录结构
```
|--docker-demo
    |--src
        |--main
            |--java
                |--com
                    |--leon
                        |--demo
                            |--App.java
    |--Dockerfile
    |--pom.xml

```

### Dockerfile说明

```
# 基于openjdk7创建image
FROM openjdk:7

# docker运行主机的工作项目跟目录
WORKDIR /home/ops/workspace/docker-demo

# 对外暴露的端口
EXPOSE 9999

# 复制的jar文件
COPY target/docker-demo-1.0.jar .

# 运行的docker命令(命令不能串联，比如CMD ["java -jar docker-demo-1.0.jar"]是没法正常运行的)
CMD ["java","-jar", "docker-demo-1.0.jar"]
```
关于Dockerfile的说明：
* Dockerfile是否要放在项目中？在Docker操作上并无强制，Dockerfile只是一个用于构建image的指令集合。理论上只要docker命令可以访问就可以。

## 操作

### docker镜像生成准备
* 在docker运行的服务器上创建工作目录/home/ops/workspace/docker-demo，这也是项目目录
* 项目根目录下运行 mvn clean install 将在target目录下生成jar包

### 生成镜像
生成
```
ops@leon-aliyun:~/workspace/docker-demo$ sudo docker build -t docker-demo:1.0 .
Sending build context to Docker daemon  51.71kB
Step 1/5 : FROM openjdk:7
 ---> d735a2057e60
Step 2/5 : WORKDIR /home/ops/workspace/docker-demo
 ---> Using cache
 ---> 8ff9439bed6e
Step 3/5 : EXPOSE 9999
 ---> Using cache
 ---> 33ed3ef74c6e
Step 4/5 : COPY target/docker-demo-1.0.jar .
 ---> Using cache
 ---> 7c26ab12c30b
Step 5/5 : CMD ["java","-jar","docker-demo-1.0.jar"]
 ---> Using cache
 ---> 2fb1fff1d5ff
Successfully built 2fb1fff1d5ff
Successfully tagged docker-demo:1.0
```

查看镜像
```
ops@leon-aliyun:~/workspace/docker-demo$ sudo docker image ls
[sudo] password for ops: 
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
docker-demo         1.0                 2fb1fff1d5ff        43 minutes ago      475MB
openjdk             7                   d735a2057e60        10 months ago       475MB
```

### 构建并启动Docker容器
```
ops@leon-aliyun:~/workspace/docker-demo$ sudo docker run --publish 9999:9999 --name dd docker-demo:1.0
Server is listening on port 9999
```


### 查看Docker容器运行情况

```
ops@leon-aliyun:~/workspace/docker-demo$ sudo docker container ls
[sudo] password for ops: 
CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS                    NAMES
c2b19a51a686        docker-demo:1.0     "java -jar docker-de鈥   About a minute ago   Up About a minute   0.0.0.0:9999->9999/tcp   dd
```

### 验证
访问http://localhost:9999/server 验证

### 例外处理
当出现启动docker出错时可能是CMD命令问题。如果需要进入docker查看docker中的内容可以进行如下两步操作：

```
# 启动docker环境并运行bash
ops@leon-aliyun:~/workspace/docker-demo$ sudo docker run -itd docker-demo:1.0 /bin/bash              
c8d1c39376c2eb6bd105a437acb1261f0ccb761b763567e92dcba508179bd6f0

# 进入启动的docker中
ops@leon-aliyun:~/workspace/docker-demo$ sudo docker attach c8d1c39376c2eb
root@c8d1c39376c2:/home/ops/workspace/docker-demo# 
```

### 避坑及其他说明
* maven编译的插件jdk版本要与docker创建image使用基础镜像一致
* 本次docker镜像创建过程张总并未在docker生成步骤中进行jar的生成，而是提前生成好的，实际可以根据需要去调整。



