---
date: "2020-04-03"
draft: false
lastmod: "2020-04-03"
publishdate: "2020-04-03"
tags:
- spring
title: starter in spring boot
---
## 1. 关于spring boot中的starter
官方说法，starters是一系列可以包含在应用中的依赖描述。通过starter可以一站式获取所有的依赖和相关技术，而不用自己去一个个去查找。
其实这里还有一个重要的作用就是自动装配，根据个人需要对功能进行插拔式支持，甚至对配置进行重新规范。

## 2. starter中涉及的相关技术内容
### 2.1. 注解@Configuration
该注解用来定义spring的bean，一般需要与作用在方法上的@Bean进行配合使用来生成bean。它的作用形同xml的bean配置文件。

### 2.2. 基于条件自动装配注解
spring支持基于条件来创建类的实例或加载配置等，比如 **@ConditionalOnClass** 与 **@Configuration** 结合使用表示只有类路径下有ConditionalOnClass指定的类存在时才会包含其所注解的类是否被包含。

👉 [官方详细说明](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#boot-features-bean-conditions)

基于类条件决定 @Configuration 所注解的类是否被包含
* @ConditionalOnClass 表示基于类路径要有指定的类
* @ConditionalOnMissingClass 表示基于类路径下没有指定的类

基于@Bean 所注解指定的实例决定该方法的返回的类是否应该被实例化
* @ConditionalOnBean 表示基于容器中要有指定的实例
* @ConditionalOnMissingBean 表示基于容器中要有指定的实例

    ⚠️⚠️这些注解严重依赖于当前spring的实例化情况，加载的顺序影响实例化结果，所以官方建议这些注解仅仅在auto-configuration类上使用，因为这个类的加载顺序确保在用户自定义的类之后。

基于配置来决定configuration是否应该被包含
* @ConfigurationProperties

基于资源来决定configuration是否应该被包含
* @ConditionalOnResource

基于是否为web应用来决定configuration应该被包含
* @ConditionalOnWebApplication
* @ConditionalOnNotWebApplication

基于SpEL表达式来决定configuration是否应该被包含
* @ConditionalOnExpression

基于java版本决定configuration是否应该被包含
* @ConditionalOnJava

基于jndi是否可用和查找指定资源定位的能力来确定configuration是否应该被包含
* @ConditionalOnJndi

其他
* @ConditionalOnSingleCandidate
* @ConditionalOnCloudPlatform

### 选择性导入相关技术
* @Import
* ImportSelecter接口进行选择性导入

### 2.3. java spi技术规范规范
详见blog其他章节说明

## 3. starter命名规范
* springboot官方定义的starter命名模式为spring-boot-starter-*， *代表一个特定类型的应用，比如以下：
    ```
    spring-boot-starter
    spring-boot-starter-activemq
    spring-boot-starter-amqp
    spring-boot-starter-batch
    ...
    ```
* 非官方定义命名不应以spring-boot开头，而是以项目名称(projectname)projectname-spring-boot-starter.

## 4. spring boot对starter的处理逻辑
springboot应用首先会加载@ComponentScan指定的路径下配置的bean到容器,加载完成后加载AutoConfiguration中的bean。

关注 **@SpringBootApplication**注解上的注解 **@ComponentScan**

```
@ComponentScan(excludeFilters = {
		@Filter(type = FilterType.CUSTOM, classes = TypeExcludeFilter.class),
		@Filter(type = FilterType.CUSTOM, classes = AutoConfigurationExcludeFilter.class) })
```


## 5. 定义自己的starter
* step 1. 创建一个springboot项目，定义starter的所有依赖
* step 2. 创建AutoConfiguration类型.
    AutoConfiguration类在编码上满足类上有 **@Configuration**注解，可以基于以上各类条件进行灵活控制比如模块是否启用，模块中类的配置调整等。
* step 3. 在resources/META-INF/下创建spring.factories文件创建spring.factories文件，并指定AutoConfiguration类
    ```
    org.springframework.boot.autoconfigure.EnableAutoConfiguration=com.leon.starter.MyAutoConfigure
    ```


## 6. 参考文档
👉 [官网对于starter说明](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#using-boot-starter)

👉 [官网对于自定义starter说明](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#boot-features-custom-starter)

👉 [SpringBoot 自动配置原理](https://juejin.im/post/5ce5effb6fb9a07f0b039a14#heading-10)

👉 [自动配置示例参考](https://www.xncoding.com/2017/07/22/spring/sb-starter.html)