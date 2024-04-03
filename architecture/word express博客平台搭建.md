# word express博客平台搭建

使用环境

```
$ uname -a
Linux VM-4-11-ubuntu 5.4.0-153-generic #170-Ubuntu SMP Fri Jun 16 13:43:31 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux
```

## 操作过程

* 安装docker & docker compose

* 创建博客根目录，并在根目录下创建docker-compose.yml 文件，文件内容：

  ```
  version: '3'
  
  services:
    wordpress:
      image: wordpress
      ports:
        - "8000:80"
      environment:
        WORDPRESS_DB_HOST: db
        WORDPRESS_DB_USER: wordpress
        WORDPRESS_DB_PASSWORD: wordpress
        WORDPRESS_DB_NAME: wordpress
      volumes:
        - ./my-word-express-blog:/var/www/html
      depends_on:
        - db
      restart: always
  
    db:
      image: mysql:5.7
      environment:
        MYSQL_DATABASE: wordpress
        MYSQL_USER: wordpress
        MYSQL_PASSWORD: wordpress
        MYSQL_RANDOM_ROOT_PASSWORD: '1'
      volumes:
        - ./mysql-data-of-docker:/var/lib/mysql
      restart: always
  ```

​	以上内容定义了两个容器，一个word express，一个word express使用的mysql数据库

* 运行docker-compose启动容器， 这个过程中会下载word express和mysql的镜像并启动两个容器，下载过程可能超时，需要切换镜像仓库

  > docker-compose up -d

* # 启动完成之后通过http://localhost:8000来进行访问，如果是在云上部署的需要打开防火墙对应端口。

