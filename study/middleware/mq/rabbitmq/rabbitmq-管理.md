---
date: "2018-01-01"
draft: false
lastmod: "2018-01-01"
publishdate: "2018-01-01"
tags:
- middleware
- mq
- rabbitmq
title: rabbitmq-管理
---
# admin 下看不到exchanges和queues队列问题

当使用admin登陆rabbitmq管理平台，打开overview标签看到有很多exchange和queue，打开exchange和queue标签却显示为0，可能原因为admin权限或vhost权限不够大，可以在管理用户对其进行设置。
