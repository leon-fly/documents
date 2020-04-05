---
date: "2018-01-01"
draft: false
lastmod: "2018-01-01"
publishdate: "2018-01-01"
tags:
- spring
title: springboot workflow
---
**springboot version:** v1.5.6

## 1. spring boot workflow
![springboot-workflow.png](../../picture/springboot-workflow.png)

[springboot-workflow.svg](../../picture/springboot-workflow.svg)

## 2. 重点流程梳理


## 3. 关键接口及类
### 3.1. BeanFactory

### 3.2. ApplicationContext

### 3.3. SpringApplicationRunListener
SpringApplication的run方法的监听器，spring应用级别的监听器，spring内部只有一个实现。
* EventPublishingRunListener

### 3.4. ApplicationListener
Spring的事件监听器
* ScheduledAnnotationBeanProcessor
* ConfigurationPropertiesbindingPostProcessor
* ConfigFileApplicationListener
* LoggingApplicationListener
* DelegatingApplicationListener

### 3.5. BeanFactoryPostProcessor


### 3.6. BeanPostProcessor


### 3.7. Aware
* ApplicationContextAwareProcessor


## 4. 模式
* 观察者模式（listener）