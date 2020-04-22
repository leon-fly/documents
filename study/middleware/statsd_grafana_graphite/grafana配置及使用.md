---
date: "2019-01-01"
draft: false
lastmod: "2019-01-01"
publishdate: "2019-01-01"
tags:
- middleware
- monitor
- statsd_grafana_graphite
title: grafana配置及使用
---

# [grafana安装配置](http://docs.grafana.org/)

grafana安装比较简单,按照官网操作即可。
关键问题在通过nginx进行反向代理时若代理中有子目录，grafana.int配置文件需要调整（此处有坑），设置其root_url.具体操作方法如下：

* **假设grafana服务器域名为test.service.com**
默认配置启动后访问 <http://test.service.com:3000/> 即可进行访问.

## 1. 通过nginx进行反向代理访问<http://test.service.com/>进行如下设置：

> grafana配置

```text
    [server]
    domain = foo.bar
 ```

> nginx配置

```text
server {
  listen 80;
  root /usr/share/nginx/www;
  index index.html index.htm;

  location / {
   proxy_pass http://localhost:3000/;
  }
}
```

## 2. 通过nginx进行反向代理访问<http://test.service.com/grafana>进行如下设置：

> grafana配置

```text
    [server]
    domain = foo.bar
    root_url = %(protocol)s://%(domain)s:%(http_port)s/grafana/
 ```

> nginx配置

```text
server {
  listen 80;
  root /usr/share/nginx/www;
  index index.html index.htm;

  location /grafana/ {
   proxy_pass http://localhost:3000/;
  }
}
```

以上内容在官网均有说明，但是根据官网调整完之后似乎不起作用，坑点如下：
默认配置文件中每行均以“;”开头，需**将root_url行的";"去掉。**