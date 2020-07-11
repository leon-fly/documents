---
date: "2020-07-11"
draft: false
lastmod: "2020-07-11"
publishdate: "2020-07-11"
tags:
- trouble-shooting
- nginx
title: ngin sub_filter指令问题
---
# ngin sub_filter指定配置无效问题


**Time : 2020/07/11**
**Issue Description:**

本地使用nginx配置进行反向代理jenkins。location配置如下：

```
location /jenkins/ {
    proxy_pass http://localhost:8081/;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Forwarded-Port $server_port;
    proxy_redirect / /jenkins/;
    proxy_redirect http://localhost:9000/ $scheme://$host:$server_port/jenkins/;
    sub_filter_once off;
    sub_filter 'src="/' 'src="/jenkins/';
    sub_filter 'src=\'/' 'src=\'/jenkins/';
    sub_filter 'url="/static/' 'url="/jenkins/static/';
    sub_filter 'url=/' 'url=/jenkins/';
    sub_filter 'window.location.replace(\'/' 'window.location.replace(\'/jenkins/';
    sub_filter 'href="/' 'href="/jenkins/';
}
```

配置说明：

由于location使用子路径对jenkins进行代理，所以会出现第一次请求正常，在后续的返回页面链接或者其他类型的请求时会出现404，因为实际地址应该增加上一级目录jenkins。 为解决这个问题使用sub_filter指令对返回的资源中请求地址进行替换。



问题：

进行如上配置后进行浏览器访问查看网页源代码发现返回内容并未如预期被替换，使用curl或者wget返回内容却如预期。开始查看分析请求头及响应头，发现浏览器请求时请求头指定Accept-Encoding: gzip, deflate，响应头Content-Encoding: gzip。根源为sub_filter无法对压缩类型进行替换。

**👉 解决方案：**

配置增加proxy_set_header Accept-Encoding ''强行对请求头修改。该方式简单粗暴，不支持压缩后会增加请求带宽，需要看情况使用。

