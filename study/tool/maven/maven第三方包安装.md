---
title: "maven第三方包安装"
date: 2018-01-01T00:00:00+08:00
draft: true
---
| version  | updated by  | update at | remark |
|:-------------: |:---------------:| -------------:|-------------:|
| v1.0      | LeonWang |         20180926 | Create

# 方式一：mvn命令方式

>完整命令

```mvn
mvn install:install-file -Dfile=<path-to-file> -DgroupId=<group-id> \
    -DartifactId=<artifact-id> -Dversion=<version> -Dpackaging=<packaging>
```

>指定pom-file代替命令参数

```mvn
mvn install:install-file -Dfile=<path-to-file> -DpomFile=<path-to-pomfile>
```

> 如果jar包是apache maven（version 2.5及以上）打出来的，子包中已包含pom文件，可以使用如下命令

```mvn
mvn install:install-file -Dfile=<path-to-file>
```

# 方式二：插件+命令方式

```mvn
<build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-install-plugin</artifactId>
                <version>2.5.2</version>
                <executions>
                    <execution>
                        <id>install-kftsdk</id>
                        <phase>validate</phase>
                        <configuration>
                            <file>${project.basedir}/lib/kft-3.9.5.jar</file>
                            <repositoryLayout>default</repositoryLayout>
                            <groupId>kft.gateway.client</groupId>
                            <artifactId>kft</artifactId>
                            <version>3.9.5</version>
                            <packaging>jar</packaging>
                            <generatePom>true</generatePom>
                        </configuration>
                        <goals>
                            <goal>install-file</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
        </plugins>
</build>
```

> 运行 ：mvn validate && mvn clean install;

<font color=red>关键：触发安装第三方包的命令必须与其他命令分开，否则maven执行解析不到本地参考或远程有依赖的第三方文件，出错</font>

## 传送门

> [参考中文站](https://www.yiibai.com/maven/install-project-into-maven-local-repository.html)
> [官方文档](http://maven.apache.org/users/index.html)