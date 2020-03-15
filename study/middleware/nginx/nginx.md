---
date: "2018-01-01"
draft: false
lastmod: "2018-01-01"
publishdate: "2018-01-01"
tags:
- middleware
- nginx
title: nginx
---
# 1. nginx基本配置示例
```
# For more information on configuration, see:
#   * Official English Documentation: http://nginx.org/en/docs/
#   * Official Russian Documentation: http://nginx.org/ru/docs/

# 使用的用户及群组
user root root;

# 工作进程数（一般等于CPU总核数）
worker_processes auto;

# 错误日志路径
error_log /var/log/nginx/error.log;

# pid存放路径
pid /run/nginx.pid;

# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;


events {
    # 使用都I/O模型，Linux系统推荐采用epoll模型，FreeBSD系统推荐采用kqueue模型
    use epoll;

    # 允许都链接数，配置准则？？？？？TODO
    worker_connections 1024;
}

http {
   # log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
   #                   '$status $body_bytes_sent "$http_referer" '
   #                   '"$http_user_agent" "$http_x_forwarded_for"';


   # 日志格式定义（名称 格式），此处只是定义一个格式，具体使用哪个由access_log指令决定
   log_format main  ' [$time_local] | $host |  $remote_addr |  $request | $request_time |  $body_bytes_sent  |  $status |'
                            '| $upstream_addr | $upstream_response_time  |  $upstream_status  |'
                            ' "$http_referer"  | "$http_user_agent" | "$request_uri"';

    # 日志存储路径及格式（日志格式名），可以设置使用缓存
    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;

    # 会话保持超时时间
    keepalive_timeout   65;
    types_hash_max_size 2048;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.

    # 子项配置（可以根据配置划分维度划分多个配置文件）
    include /etc/nginx/conf.d/*.conf;

    # 配置一个虚拟服务
    server {
        listen       80 default_server;
        listen       [::]:80 default_server;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;
        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        location / {
        }

        error_page 404 /404.html;
            location = /40x.html {
        }

        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
    }

# Settings for a TLS enabled server.
#
#    server {
#        listen       443 ssl http2 default_server;
#        listen       [::]:443 ssl http2 default_server;
#        server_name  _;
#        root         /usr/share/nginx/html;
#
#        ssl_certificate "/etc/pki/nginx/server.crt";
#        ssl_certificate_key "/etc/pki/nginx/private/server.key";
#        ssl_session_cache shared:SSL:1m;
#        ssl_session_timeout  10m;
#        ssl_ciphers HIGH:!aNULL:!MD5;
#        ssl_prefer_server_ciphers on;
#
#        # Load configuration files for the default server block.
#        include /etc/nginx/default.d/*.conf;
#
#        location / {
#        }
#
#        error_page 404 /404.html;
#            location = /40x.html {
#        }
#
#        error_page 500 502 503 504 /50x.html;
#            location = /50x.html {
#        }
#    }

}
```


# 2. 虚拟主机
http节点下每一个server配置即为一个虚拟主机，每一个虚拟主机可以指定监听主机及端口，主机可以是ip或者域名。每个物理机可以绑定多个ip，每个ip可以绑定多个域名，所以可以使用ip或者域名或者端口把一个物理机配置成多个虚拟机。

```
server
{
    listen 80
    # 主机名称，通过请求时请求的主机名进行匹配
    server_name www.mydomain.com   

    # 访问日志文件存放路径及格式指定
    access_log /var/log/nginx/nginx.log combined

    location / {
        # 默认首页文件，从左至右优先查找返回，直到找到或到最后一个
        index index.html index.htm

        # html网页文件存放的目录
        root /home/ops/workspace/domain
    }
}


server
{
    listen 80
    server_name www.mydomain2.com   

    ...
}

```

# 3. 日志
## 3.1. 设置日志名称及对应格式（日志格式的定义）
> log_format name format [format ...]

name必须唯一，format由一个个子项组成。nginx有一个默认的日志格式combined。

**日志定义示例：**
```
log_format upstream_time '$remote_addr - $remote_user [$time_local] '
                             '"$request" $status $body_bytes_sent '
                             '"$http_referer" "$http_user_agent"'
                             'rt=$request_time uct="$upstream_connect_time" uht="$upstream_header_time" urt="$upstream_response_time"';
```

## 3.2. 日志文件
日志文件可以关闭，可以使用静态，也可以使用动态，即允许在路径中使用参数，比如 **$server_name** 代表服务名。
如果使用动态路径，写日志缓存将不可用，每次写入都要打开-写入-关闭文件，需要通过open_log_file_cache指令设置经常被使用的日志文件描述符缓存，该指令默认是禁止的。

## 3.3. 日志文件切割
nginx本身不支持按照时间来切割日志文件，需要借助mv、kill及crontab实现。

## 3.4. 错误日志级别
格式：
> error_log logpath level

错误级别分为 debug｜info|notice|warn|error|crit

## 3.5. 日志缓冲
在指定日志的时候指定缓冲大小，关键一点，当日志路径为动态时缓冲失效，具体优化见日志文件说明。

# 4. 压缩
nginx通过gzip压缩技术可以将页面大小变为原来的30%甚至更小，提高用户浏览页面的速度，一般浏览器都支持。处理过程：服务端压缩-浏览器解压-浏览器展示。使用gzip相关的一系列指令。

# 5. nginx自动列目录
通过autoindex指令可以实现自动列出访问的当前路径下的目录，配置在location下。
示例：
```
location / {
    autoindex on;
}
```
相关指令：
autoindex_exact_size on|off
autoindex_localtime on|off

# 6. nginx浏览器本地缓存
* expires指令格式
  > expires [time|epoch|max|off]
  
  * 默认值 off，表示不修改Expires和Cache-Control值
  * 指定time为负数将不缓存
  * 指定time格式为数字+时间单位（d表示天 h代表小时...）为正数或0时表示有效多少秒。Cache-Control: max-age=time设定值的秒数
  * 作用域 http / server / location (对应配置文件各个节点)

# 7. nginx负载均衡与方向代理

## 7.1. 负载之DNS做负载
    * 可靠性低。某台故障，即使从DNS服务器去掉故障机器，由于网络运营商为了提升效率低缓存策略，生效可能需要几个小时，那么分发到这台的请求将不能正常处理。
    * 负载分配不均衡，DNS采用简单轮询策略，不能区分服务性能差异和负载差异，另外本地DNS服务器会缓冲已解析的域名ip，一段时间内访问的都是同一台服务器。

## 7.2. nginx负载均衡配置简单示例
仅负载和转发部分简要配置示例
```
# 定义一条负载均衡（负载名称和该负载对应的服务信息及负载规则）
upstrame my_server_cluster_name {
    # 负载策略
    ip_hash;
    server 192.168.1.10:80 weight=4 max_fails=2 fail_timeout=30s;
    server 192.168.1.10:80 weight=4 max_fails=2 fail_timeout=30s;
    server 192.168.1.10:80 weight=2 max_fails=2 fail_timeout=30s;    

    # down表示目前在负载中标记不可用，但是还是作为一个节点，不会影响ip_hash负载策略。
    server 192.168.1.10:80 weight=2 max_fails=2 fail_timeout=30s down;    
    
}

server {
    listen 80;
    server_name www.mydomain.com;

    # 负载使用，用负载均衡定义中的命名作为服务主机名。
    location / {
        # 代理服务配置
        proxy_pass http://my_server_cluster_name

        # 配置故障转移（根据返回状态码502、504、执行超时等错误自动将请求转发到upsteam负载均衡池中低另一台服务器）
        proxy_next_upstream http_502 http_504 error timeout invalid_header;
    }
}
```

## 7.3. HTTP Upsteam负载均衡模块
### 7.3.1. ip_hash指令
对ip进行hash操作，分配到指定的服务器上。通过这种方式能达到有会话状态要求的转发要求。采用这种负载策略且有会话状态要求情况下，如果要下线某台服务器直接注释还是down，直接注释后原来的ip再次请求分配的可能不是原来那台机器，服务器可能没有请求相关的会话信息。

### 7.3.2. upstream的server指令
语法：
> server name [parameters]

参数：
* weight=NUMBER 权重值，权重越高，分配的请求越多,默认为1
* max_fails=NUMBER 允许服务器无法链接及发生服务器错误的次数（404除外）则标记为失败，默认为1
* fail_timeout=TIME 标记失败后暂停服务时间
* down 标记服务器离线。

### 7.3.3. upstream指令
* 语法： 
  > upsteam name {...}

使用环境是http，默认负载均衡方式为轮询。

* upstream相关变量：
    > \$upstream_addr 处理请求的upstream服务器地址

    > \$upstream_status  表示upstream服务器的 应答状态

    > \$upstream_response_time

    >\$upstream_http_\$HEADER 任意的http协议头，如：\$upstream_http_host
## 7.4. nginx负载均衡服务器的双机高可用（避免nginx单点故障）
虚拟IP（漂移IP）实现，基于Linux/Unix的IP别名技术。

两种方式实现高可用：
* 热备 （使用1个公网ip绑定到主机上，当主机故障，热备接管公网ip）
* 双活  (使用两个公网ip分别绑定到两台主机，当其中一台故障，另一台接管故障机器的虚拟ip)


# 8. 书单
实战nginx - 张宴

[路径匹配问题](https://www.cnblogs.com/kevingrace/p/6566119.html)