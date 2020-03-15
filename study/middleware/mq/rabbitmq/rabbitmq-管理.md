---
title: "rabbitmq-管理"
date: 2018-01-01T00:00:00+08:00
draft: true
---
# admin 下看不到exchanges和queues队列问题

当使用admin登陆rabbitmq管理平台，打开overview标签看到有很多exchange和queue，打开exchange和queue标签却显示为0，可能原因为admin权限或vhost权限不够大，可以在管理用户对其进行设置。
