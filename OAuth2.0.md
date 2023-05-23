---
date: "2018-01-01"
draft: false
lastmod: "2018-01-01"
publishdate: "2018-01-01"
tags:
- git-doc
title: OAuth2.0
---
# OAuth2.0

## 1. OAuth2.0的四种认证模式

先介绍两个角色：

1. 客户端
2. 认证中心

### 授权码模式

用户登录到认证中心申请到授权码，给到客户端，客户端通过自己服务端再到认证中心换取access token 和 fresh token.

### 简化模式

简化模式跳过了客户端的服务器，用户登录认证后直接申请access token。

### 密码模式

密码模式是用户向客户端提供自己的登录用户名和密码，客户端使用这些信息向认证中心拿access token和fresh token. 这种场景代表客户端持有了用户信息，考虑到安全，这种模式只有在内部可信的系统群可以使用。

### 客户端模式

客户端模式是指客户端以自己的名义而不是以用户的名义向认证中心认证。一般这种模式的使用有一种前提，该用户已经通过客户端平台的认证获取access token。这种模式就存在客户端可以随意获取用户的资源的风险而不需要用户的许可。





[OAuth site](https://oauth.net/)

[理解OAuth2.0](https://www.ruanyifeng.com/blog/2014/05/oauth_2_0.html)



