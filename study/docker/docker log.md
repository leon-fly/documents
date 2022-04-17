---
date: "2018-01-05"
draft: false
lastmod: "2018-01-05"
publishdate: "2018-01-05"
tags: 
- docker
title: docker日志查看
---

# docker日志

在我们使用docker运行相关服务时经常出现服务无法启动或者服务异常问题，这时候就需要通过日志来诊断问题根源，那么docker有哪些方式可以进行日志查看呢？

## 方式一：宿主机内查看

docker日志可以在宿主机内通过cat/more/less/vi等查看，默认存储目录为**/var/lib/docker/containers** , 该路径可以进行配置变更。可以通过docker inspect命令查找到 : 

> docker inspect [ContainerID/ContainerName]  |grep LogPath

示例:

```
ops@leon-aliyun:~$ docker ps
CONTAINER ID   IMAGE           COMMAND                  CREATED      STATUS      PORTS                      NAMES
29dfdd408c9a   mongo-express   "tini -- /docker-ent…"   4 days ago   Up 4 days   0.0.0.0:8002->8081/tcp     mongo-express
70203e2e07cf   mongo           "docker-entrypoint.s…"   4 days ago   Up 4 days   0.0.0.0:27017->27017/tcp   mongo

ops@leon-aliyun:~$ docker inspect mongo | grep LogPath
        "LogPath": "/var/lib/docker/containers/70203e2e07cfafe41e22f3720120c95f5c031d1fa1fc05e298baa12bd7598b93/70203e2e07cfafe41e22f3720120c95f5c031d1fa1fc05e298baa12bd7598b93-json.log",
```



## 方式二：直接通过docker log命令查看

**示例：**

```
ops@leon-aliyun:~$ docker logs mongo-express
Welcome to mongo-express
------------------------


(node:8) [MONGODB DRIVER] Warning: Current Server Discovery and Monitoring engine is deprecated, and will be removed in a future version. To use the new Server Discover and Monitoring engine, pass option { useUnifiedTopology: true } to the MongoClient constructor.
(node:8) UnhandledPromiseRejectionWarning: MongoError: command listDatabases requires authentication
    at Connection.<anonymous> (/node_modules/mongodb/lib/core/connection/pool.js:453:61)
    at Connection.emit (events.js:314:20)
    at processMessage (/node_modules/mongodb/lib/core/connection/connection.js:456:10)
    at Socket.<anonymous> (/node_modules/mongodb/lib/core/connection/connection.js:625:15)
    at Socket.emit (events.js:314:20)
    at addChunk (_stream_readable.js:297:12)
    at readableAddChunk (_stream_readable.js:272:9)
    at Socket.Readable.push (_stream_readable.js:213:10)
    at TCP.onStreamRead (internal/stream_base_commons.js:188:23)
(node:8) UnhandledPromiseRejectionWarning: Unhandled promise rejection. This error originated either by throwing inside of an async function without a catch block, or by rejecting a promise which was not handled with .catch(). To terminate the node process on unhandled promise rejection, use the CLI flag `--unhandled-rejections=strict` (see https://nodejs.org/api/cli.html#cli_unhandled_rejections_mode). (rejection id: 1)
(node:8) [DEP0018] DeprecationWarning: Unhandled promise rejections are deprecated. In the future, promise rejections that are not handled will terminate the Node.js process with a non-zero exit code.
```

**详细用法：**

```
docker logs [OPTIONS] CONTAINER
-------------------------------------
OPTIONS说明：
-------------------------------------

-f : 跟踪日志输出

--since :显示某个开始时间的所有日志

-t : 显示时间戳

--tail :仅列出最新N条容器日志
```

