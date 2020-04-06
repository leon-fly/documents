---
date: "2018-01-01"
draft: false
lastmod: "2018-01-01"
publishdate: "2018-01-01"
tags:
- spring
title: spring-annotation
---
**Spring version : V4.2** 
## 1. Bean管理类

### 1.1. 声明spring bean
> @Repository 作用在Dao层类上

> @Service 作用在服务层类上

> @Controller 作用在controller类上

> @Component 作用在其他不好划分的类上

> @Bean 一般作用在方法上



### 1.2. bean策略管理
> @Lazy 懒加载
> @Scope 指定生命周期

### 1.3. 注入

> @Autowire 默认按类型装配，配合@Qualifier可以指定名称装配

> @Resource
默认按照名称装配，指定名称或类型或者两者都指定则完全按照指定去装配。

> @Qualifier
可以与@Autowire配合使用，用来指定装配名称

## 2. 事务类
> @Transactional 作用在方法上
* value/transactionManager 指定事务管理器
* propagation 指定事务传播性
    * REQUIRED 默认。支持事务，如果当前不存在事务则创建一个
    * SUPPORTS 支持事务，如果不存在就在非事务模式执行
    * MANDATORY 支持事务，如果当前不存在事务则抛出异常
    * REQUIRES_NEW 创建一个新事务，并且如果当前存在事务则会对其暂停
    * NOT_SUPPORTED 不支持事务，如果当前存在事务对其暂停
    * NEVER 不支持事务，如果存在事务则抛出异常
    * NESTED 如果当前事务存在则使用一个内嵌事务，行为类似Required,不是所有的事务管理器都支持
* isolation
    * DEFAULT 使用底层数据库的默认隔离级别
    * READ_UNCOMMITTED
    * READ_COMMITTED
    * REPEATABLE_READ
    * SERIALIZABLE
* timeout 事务超时时间
* readOnly 是否只读事务
* rollbackFor 指定回滚类型
* rollbackForClassName  指定回滚类型（通过类名）
* noRollbackFor 指定不回滚类型
* noRollbackForClassName 指定不回滚类型（通过类名）

## 3. Mapping类

### 3.1. 声明Controller为Spring bean
> @Controller

> @RestController 结合@Controller与@ResponseBody两者

### 3.2. Url映射
> @RequestMapping 添加属性method，可以支持多种请求类型

> @GetMapping

> @PostMapping

> @PutMapping

> @DeleteMapping

> @PatchMapping

### 3.3. 请求数据

> @RequestBody

> @RequestHeader

> @RequestParam

> @RequestAttribute

> @RequestPart 用于关联multipart/form-data请求

> @PathVariable 用于关联Path中的变量

> @CookieValue 用于关联请求cookie

### 3.4. 返回数据

> @ResponseBody 作用在方法上

> @ResponseStatus 作用在异常类上用于定义异常返回状态码与异常信息

### 3.5. 会话级数据
> SessionAttribute

> SessionAttributes

### 3.6. 安全
> @CrossOrigin 标记一个请求允许跨域访问

## 4. 异常处理类
> @ExceptionHandler 作用在方法上对本controller中的异常进行处理。结合

> @ControllerAdvice 作用在类上，为croller指定的一个切面，结合@Exception可以对指定的controller进行异常控制处理。
