---
date: "2018-01-04"
draft: false
lastmod: "2018-01-04"
publishdate: "2018-01-04"
tags: 
- docker
title: 使用命令和docker-compose方式部署mongobd与mongo-express
---
# 1. 命令方式使用docker启动mongoDB 和mongo-express

* 下载mongoDB和mongo-express的镜像

  >  docker pull mongo:4.0

  > docker pull mongo-express:0.49.0

* 分别启动

  启动mongo

  > docker run -d -p 27017:27017 --name mongo  -e MONGO_INITDB_ROOT_USERNAME=mongoadmin -e MONGO_INITDB_ROOT_PASSWORD=my1qaz2wsx  mongo:4.0

  启动mongo-express
  
  >  docker run -it --restart=always --name mongo-express --link mongo:mongo -d -p 8081:8081 -e ME_CONFIG_OPTIONS_EDITORTHEME="3024-night" -e ME_CONFIG_BASICAUTH_USERNAME="mongoexpress" -e ME_CONFIG_BASICAUTH_PASSWORD="my1qaz2wsx" -e ME_CONFIG_MONGODB_ADMINUSERNAME="mongoadmin" -e ME_CONFIG_MONGODB_ADMINPASSWORD="my1qaz2wsx" mongo-express:0.54.0
  
  

# 2. DockerCompose方式启动MongoDB和Mongo-express

1. 创建配置文件mongo-and-express.yaml

   ```
   version: '3'
   services:
     mongo:
       image: mongo:4.0
       container_name: mongo
       ports:
         - 27017:27017
       restart: always
       environment:
         MONGO_INITDB_ROOT_USERNAME: mongoadmin
         MONGO_INITDB_ROOT_PASSWORD: my1qaz2wsx
     mongo-express:
       depends_on:
         - mongo
       image: mongo-express:0.54.0
       container_name: mongo-express
       restart: always
       ports:
         - 8002:8081
       environment:
         ME_CONFIG_OPTIONS_EDITORTHEME: 3024-night
         ME_CONFIG_BASICAUTH_USERNAME: mongoexpress
         ME_CONFIG_BASICAUTH_PASSWORD: my1qaz2wsx
         ME_CONFIG_MONGODB_ADMINUSERNAME: mongoadmin
         ME_CONFIG_MONGODB_ADMINPASSWORD: my1qaz2wsx
   ```

2. 启动

   > docker-compose -f mongo-and-express.yaml up

3. 停止

   > docker-compose -f mongo-and-express.yaml down
