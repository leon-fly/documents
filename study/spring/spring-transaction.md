---
date: "2018-01-01"
draft: false
lastmod: "2018-01-01"
publishdate: "2018-01-01"
tags:
- spring
title: spring-transaction
---

## spring事务失效经典场景

1. 注解的方法必须是public，如果是其他修饰会失效

2. 类中方法自调用的事务，不能满足事务的传播特性，只支持一个事务。如下调用methodA，内部调用了methodB(),methodB虽然生命重新启用一个新事物，但是不会生效的。

   ```
   public class A {
   	 @Transactional
   	 void methodA(){
   	 		...
   	 		methodB();
   	 }
   	 
   	 @Transactional(propagation = Propagation.REQUIRES_NEW)
   	 void methodB(){
   	 
   	 }
   }
   ```

