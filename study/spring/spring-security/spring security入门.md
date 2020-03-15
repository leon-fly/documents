---
title: "spring security入门"
date: 2018-01-01T00:00:00+08:00
draft: true
---
# spring security

* 相关链接
[spring security架构说明](https://spring.io/guides/topicals/spring-security-architecture)
[相关示例](https://segmentfault.com/a/1190000015191298)
## 核心功能

* Authentication 认证
* Authorization 授权（访问控制）

## 核心认证类及接口

* Authentication 认证，包含认证书，唯一的id，处理处理授权动作，获取是否已被授权等
* AuthenticationManager 认证管理器，该类唯一任务就是认证。
* AuthenticationProvider
    * 进行认证
    * 告知支持的认证类型
* ProviderManager，AuthenticationManager的一个实现类
* AuthenticationManagerBuilder，认证工具类，生成认证管理器。支持以下多种：
    * in-memory
    * JDBC
    * LDAP user details
    * userDetailService(用户自定义封装)

* SecurityContextHolder 用于存储安全上下文信息
* WebSecurityConfigurerAdapter，WebSecurityConfigurer的子类

