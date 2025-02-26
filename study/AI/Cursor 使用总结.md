---
date: 2024-04-19 
draft: false
lastmod : 2025-02-20 
publishdate: 2025-02-20
categories: 
- AI
tags: 
- 工具
title: Cursor 使用总结
author: Leonwang
---

## 关于 cursor 

[Cursor](https://www.cursor.com/cn) 是一款整合了 vscode 的 AI 编程工具，可有限免费/付费使用。它与类似于 copilot 对比突出的核心能力是你只需要描述你的需求，它直接的帮你在对应的位置生成代码，你需要做的只是描述你的需求，接受/拒绝它生成的代码，重复这个动作。你也可以像普通编程工具一样编写代码，它会预测你的后续输入，更快速帮你的编程。对于它生成代码的能力是通过持续集成优秀的大模型来使自己更强大。至于它到底能释放多大的能量基于使用者对 AI 的掌握情况具体而定，越是熟悉它的人越是高效。

当前说明版本【0.45.14】

## cursor 能支持开发角色的场景

### 代码生成

* 初始需求，通过精准表述需求范式

  ```
  [需求描述模板]
  目标：创建带JWT认证的Spring Security用户系统
  功能要求：
   - 用户注册/登录端点
   - 密码哈希存储
   - JWT令牌生成与验证中间件
   - 用户信息更新接口
  技术栈：java17, Spring Boot3, Spring Security, JPA
  ```

* 上下文敏感生成

  ```
  // 在现有Service中添加新方法
  public class OrderService {
      private final OrderRepository repository;
      
      // 已有方法：createOrder, getOrderById
      
      // 新需求：添加分页查询方法，查询条件为 a,b,c 按创建时间倒序
      // 生成位置：在已有方法下方
  }
  ```

  此场景可以选中关联文件OrderService.java,  OrderRepository.java, Order.java，然后描述具体需求:

  ```
  新增分页查询订单方法，查询条件封转一个查询对象，查询对象放在com.order.model包下，按创建时间倒序，在最后一个方法后追加改方法
  ```

  提供的已知信息越具体，生成的结果也就越是接近你需要的内容。

### 代码重构

随着需求的变更，部分方法/类开始变得臃肿，或者你总感觉某一段代码写的比较啰嗦，此时需要对其进行重构或者优化。操作方式类似于上下文敏感生成，需要选择需要重构的对象，描述具体要求。

### 代码 review

你是否对某一段代码没有信心？比如某段代码并发控制是否合理，会不会存在死锁，那你可以直接关联那段代码提出你的疑问。

### 单元测试

单元测试的覆盖尤其是关键代码以及逻辑复杂的代码，使用 Cursor 代码生成带来的便捷性非常明显。示例：

```
生成 ExtractTask 的 fastCheckIsContentCorrect 方法, 要求基于 junit4 / mockito / 多组参数 @ParameterizedTest / 私有方法使用 hutool 的反射工具进行测试
```

### 快速项目视图

在新接手一个项目时作为开发者如何快速的了解一个项目？一般我们会有代码，好一点的情况下我们会有对应的文档，当时文档编写内容层次不齐，有时候可能得不到我们想要的内容，从项目中一点点啃？效率有点太慢。这个时候我们可以让 cursor 作为我们的眼睛和大脑，通过@codebase 对项目进行提问，比如你可以这样问：

```
- 介绍项目的核心服务能力
- 项目是否有集群支持？
- 项目中的定时任务是如何支持的？
- 项目中监控埋点的实现方式是什么？项目中的示例请指出。
```

##  cursor rule

在使用 cursor 是否经常需要设定一些重复的规则才能更精确生成需要的内容？  比如单元测试时指定使用的技术，测试覆盖要求等等

团队内部是不是有约定俗成的规范需要遵守？ 如命名规范，注释

**那么了解一下 cursor rule :**

Cursor Rules是一套强大的智能规则系统，旨在帮助开发团队编写更优质、更一致的代码。通过自动化建议和实时反馈，Cursor Rules能够提高开发效率，减少常见错误。它可以提供智能代码建议和自动补全，确保团队代码风格统一，自动执行最佳实践，从而提高代码的可维护性

**java 示例：**

```

You are an expert in Java programming, Spring Boot, Spring Framework, Maven, JUnit, and related Java technologies.

Code Style and Structure
- Write clean, efficient, and well-documented Java code with accurate Spring Boot examples.
- Use Spring Boot best practices and conventions throughout your code.
- Implement RESTful API design patterns when creating web services.
- Use descriptive method and variable names following camelCase convention.
- Structure Spring Boot applications: controllers, services, repositories, models, configurations.

Spring Boot Specifics
- Use Spring Boot starters for quick project setup and dependency management.
- Implement proper use of annotations (e.g., @SpringBootApplication, @RestController, @Service).
- Utilize Spring Boot's auto-configuration features effectively.
- Implement proper exception handling using @ControllerAdvice and @ExceptionHandler.

Naming Conventions
- Use PascalCase for class names (e.g., UserController, OrderService).
- Use camelCase for method and variable names (e.g., findUserById, isOrderValid).
- Use ALL_CAPS for constants (e.g., MAX_RETRY_ATTEMPTS, DEFAULT_PAGE_SIZE).

Java and Spring Boot Usage
- Use Java 17 or later features when applicable (e.g., records, sealed classes, pattern matching).
- Leverage Spring Boot 3.x features and best practices.
- Use Spring Data JPA for database operations when applicable.
- Implement proper validation using Bean Validation (e.g., @Valid, custom validators).

Configuration and Properties
- Use application.properties or application.yml for configuration.
- Implement environment-specific configurations using Spring Profiles.
- Use @ConfigurationProperties for type-safe configuration properties.

Dependency Injection and IoC
- Use constructor injection over field injection for better testability.
- Leverage Spring's IoC container for managing bean lifecycles.

Testing
- Write unit tests using JUnit 5 and Spring Boot Test.
- Use MockMvc for testing web layers.
- Implement integration tests using @SpringBootTest.
- Use @DataJpaTest for repository layer tests.

Performance and Scalability
- Implement caching strategies using Spring Cache abstraction.
- Use async processing with @Async for non-blocking operations.
- Implement proper database indexing and query optimization.

Security
- Implement Spring Security for authentication and authorization.
- Use proper password encoding (e.g., BCrypt).
- Implement CORS configuration when necessary.

Logging and Monitoring
- Use SLF4J with Logback for logging.
- Implement proper log levels (ERROR, WARN, INFO, DEBUG).
- Use Spring Boot Actuator for application monitoring and metrics.

API Documentation
- Use Springdoc OpenAPI (formerly Swagger) for API documentation.

Data Access and ORM
- Use Spring Data JPA for database operations.
- Implement proper entity relationships and cascading.
- Use database migrations with tools like Flyway or Liquibase.

Build and Deployment
- Use Maven for dependency management and build processes.
- Implement proper profiles for different environments (dev, test, prod).
- Use Docker for containerization if applicable.

Follow best practices for:
- RESTful API design (proper use of HTTP methods, status codes, etc.).
- Microservices architecture (if applicable).
- Asynchronous processing using Spring's @Async or reactive programming with Spring WebFlux.

Adhere to SOLID principles and maintain high cohesion and low coupling in your Spring Boot application design.
```

参考：[一些比较经典的 cursor rule](https://cursor.directory/rules/popular)

## 大模型选择和使用

cursor 工具可以分为两大组成部分，一部分为大脑，即AI 的部分，一部分为操作的部分即基于 vscode 能对代码精准操作。而大脑的部分就显得尤为重要，cursor 集成了很多大模型，比如 claude-3.5-sonnet / cursor-fast / deepseek-r1 等等，每个大模型有他们擅长的内容，合理的设置非常重要。大模型选择好如何使用也尤为关键，推荐[deepseek 从入门到精通](https://pan.baidu.com/s/19MjoRi8Zsd7WuCFALSiJIA?pwd=k2yn)开拓思路。

##  Cursor 最佳实践

* 上下文环境法则：始终确保打开相关文件（要修改的类，要参考类，要参考的示例）或代码后再生成代码
* 渐进式生成策略：复杂的功能可以分多次迭代生成，先整体后局部。
* 验证工作流：
  * 生成代码
  * 代码审查
  * 生成对应的单元测试
* 做项目一定要掌握cursor rule

## 个人体会

* AI 不会银弹， 不是所有的问题都能解决。
* 在使用AI 的道路上是一个循序渐进的过程，不要碰到问题就放弃使用，有可能只是自己使用方法需要纠正，有时我们要打破思维局限。
* 在使用 cursor 时输入或者数据考虑脱敏



