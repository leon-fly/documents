---
date: "2018-01-01"
draft: false
lastmod: "2018-01-01"
publishdate: "2018-01-01"
tags:
- trouble-shooting
title: ts-cps
---
# 1. 背景
公司紧急接入合作方某保险产品，采用api将非常耗时，合作方提供了一个产品页面，经由我方页面跳转至合作方页面，这样产品流程是通的。那么有一个问题，业务流程顺了，但是合作方暂不支持提供业务关键数据给我方，我方纯粹为合作方做了引流。
**问题：如何才能既能让整个流程通畅，还能将业务数据保留至我司。**

# 2. 解决方案

## 2.1. 替换合作方的录单页面为我司页面，后续转至保司页面


## 2.2. 对合作方请求做代理，代理过程对指定页面数据进行处理。
spring zuul对请求拦截保存数据并转发请求



