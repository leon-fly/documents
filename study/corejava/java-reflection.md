---
date: "2018-01-01"
draft: false
lastmod: "2018-01-01"
publishdate: "2018-01-01"
categorys:
- Core Java
tags:
- java特性
title: java-reflection
---

## 1. java reflection简介

java反射是java的一个重要特性，它允许用户在运行期间获取类的内部信息。这个特性也就预示着它的主要作用是在运行期间动态的处理一些在编译器不确定等类信息，一般在一些框架的底层实现可以看到它等身影。比如spring的IOC框架，框架本身在编译器并不知道容器中需要生成或者注入哪些类的实例，但是通过反射机制，扫描用户注解从而动态初始并注入属性，得到完美解决。

## 2. relection具体能做哪些事情

* 类型判断，如某个实例是否属于某个类
* 获取类属性，通过类属性对象获取实例中属性值
* 获取类方法（包含构造方法）
    getMethods()  获取类的所有public方法,包括继承自父类的
    getDeclaredMethods()   获取本类中全部访问权限的方法，但不包括父类的方法
* 类方法调用

## 3. 关键使用过程及方法
* 获取Class对象
    * 通过Class.forName();
    * 通过实例的getClass()
    * 原始类型的包装类通过TYPE属性获取
* 获取方法对象Method
    * 通过method的invoke方法进行触发

## 4. 反射使用注意
* 反射的性能相对比较低，有其他非运行时方式解决时可考虑使用其他方法
* 反射调用方法时可以忽略权限检查来提升性能，同时可能会破坏封装性而导致安全问题，使用时要注意

## 5. 其他参考资料
[参考1](https://www.sczyh30.com/posts/Java/java-reflection-1/)
