---
date: "2019-01-01"
draft: false
lastmod: "2019-01-01"
publishdate: "2019-01-01"
tags:
- middleware
- monitor
- statsd_grafana_graphite
title: statsd_grafana_graphite监控相关组件安装
---

# statsd_grafana_graphite监控相关组件安装

## 1. [statsd](https://github.com/etsy/statsd)服务端安装

1. Install node.js
2. Clone the project
3. Create a config file from exampleConfig.js and put it somewhere
4. Start the Daemon
    > node stats.js /path/to/config

## 2. [Graphite安装](https://graphite.readthedocs.io/en/latest/index.html)

[graphite项目](https://github.com/graphite-project)共计四个子项目，需要分别安装

1. Graphite-web
2. Carbon
3. Whisper
4. Ceres

### 2.1. 操作步骤：

1. clone各个子项目
2. 查看python是否已安装
   > python --version
3. python未安装则安装
    > sudo apt install python3
    > sudo ln -s /usr/bin/python3 /usr/bin/python
4. 进入各子项目目录运行如下命令进行安装（默认安装方式）
    > sudo python3 setup.py install

    若出错: No module named 'distutils.core'
    > sudo apt-get install python3-distutils

## 3. [Graphite-web配置](https://graphite.readthedocs.io/en/latest/config-webapp.html)

* 该子模块服务需要http服务支持，可选组件：[nginx](https://nginx.org/en/docs/beginners_guide.html) + [gunicorn](https://gunicorn.org/#docs)

* 安装操作(python和pip使用一致版本,比如都使用3.xx或2.xx)：

  1. 安装nginx
     > sudo apt install nginx
     > nginx --version
  2. 安裝python包管理器[python3-pip](https://pip.pypa.io/en/latest/)

      ```txt
      sudo apt install python3-pip -y
      sudo ln -s /usr/bin/pip3 /usr/bin/pip
      pip --v
      ```

  3. 安装pkg-config (pycairo依赖该项)
     > sudo apt-get install pkg-config
  4. 安装cairo(pycairo依赖该项)
     > sudo apt-get install libcairo2-dev
  5. 安装python-dev(pycairo依赖该项)
     > sudo apt-get install python3-dev
  6. 安装django(web应用框架)

      ```txt
     pip install django==2.0.5
     sudo ln -s ~/.local/bin/django-admin /usr/local/bin/django-admin
     django-admin --version

     pip install django-tagging
     pip install pyparsing
     pip install pycairo
      ```

  7. 安装gunicorn-19.7.1
     > pip install gunicorn==19.7.1

* [配置](https://graphite.readthedocs.io/en/latest/config-webapp.html#)

  1. nginx配置

      文件环境准备

      ```txt
      sudo touch /var/log/nginx/graphite.access.log
      sudo touch /var/log/nginx/graphite.error.log
      sudo chmod 640 /var/log/nginx/graphite.*
      sudo chown www-data:www-data /var/log/nginx/graphite.*
      ```

      nginx配置文件(/etc/nginx/sites-available/graphite)

      ```config
      upstream graphite {
          server 127.0.0.1:8080 fail_timeout=0;
      }

      server {
          listen 80 default_server;

          server_name HOSTNAME;

          root /opt/graphite/webapp;

          access_log /var/log/nginx/graphite.access.log;
          error_log  /var/log/nginx/graphite.error.log;

          location = /favicon.ico {
              return 204;
          }

          # serve static content from the "content" directory
          location /static {
              alias /opt/graphite/webapp/content;
              expires max;
          }

          location / {
              try_files $uri @graphite;
          }

          location @graphite {
              proxy_pass_header Server;
              proxy_set_header Host $http_host;
              proxy_redirect off;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Scheme $scheme;
              proxy_connect_timeout 10;
              proxy_read_timeout 10;
              proxy_pass http://graphite;
          }
      }
      ```

      Enable this configuration for nginx:

      > sudo ln -s /etc/nginx/sites-available/graphite  /etc/nginx/sites-enabled
      > sudo rm -f /etc/nginx/sites-enabled/default

      Reload nginx to use the new configuration:

      > sudo service nginx reload

  2. carbon配置
      日志配置
      udp打开
      时间区域设置 local_setting.py
      配置数据文件目录

* 启动

    gunicorn启动

    > sudo PYTHONPATH=/opt/graphite/webapp gunicorn wsgi --workers=4 --bind=127.0.0.1:8080 --log-file=/var/log/gunicorn.log --preload --pythonpath=/opt/graphite/webapp/graphite &

    nginx启动

    > sudo nginx

    carbon启动(carbon-cache.py文件在carbon工程bin目录下)
    > carbon-cache.py start

    django数据库sqlite初始化，关键manage.py,这个文件在/opt/graphite/webapp/下，如果没有则从源码中拷贝一份出来，初始化数据库python manage.py migrate

* 访问验证

浏览器访问<http://nginx-host/render>,出现一张330x250的"No Data"的图片

## 4. Grafana安装
  