---
date: "2018-01-01"
draft: false
lastmod: "2018-01-01"
publishdate: "2018-01-01"
tags:
- corejava
- nio
title: java-spi
---
# 1. java spi
**spi是一种java规范**，规范大致如下：
1. 由制定规范的一方定义好接口，制定规范的一方开发中面向接口编程，不依赖于具体实现类。具体实现类在运行时通过如下方法进行获取：
    > ServiceLoader.load()
    
    该方法实现类Iterable接口，可以通过遍历获取到实现类实例，具体实例就是步骤2中配置的实例。
2. 在服务方实现接口后提供相应的实现包，规范方将其放入类路径并在按照规范在resources目录下创建“配置文件”作为其实现类。配置文件如下：

    ```
    --resources
        --META-INF
            --接口全限定名命名的文件
    ```
    文件内容为具体实现类的权限定名，一个实现类一行。

这种方式类似与spring的ioc，不依赖于具体实现。

# 2. 相关计数文档
[云栖社区Java中SPI机制](https://yq.aliyun.com/articles/640161)