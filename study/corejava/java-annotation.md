---
date: "2018-01-01"
draft: false
lastmod: "2018-01-01"
publishdate: "2018-01-01"
tags:
- corejava
title: java-annotation
---

## 1. annotation简介
annotation为java的注解，可以理解为java中的某种标识机制。

## 2. annotation定义
annotation的定义同普通java类文件类似。示例如下：
```
@Retention(RetentionPolicy.RUNTIME)
@Target(value = {ElementType.FIELD})
public @interface Phone {
    PhoneType type() default PhoneType.CELL_PHONE;
}
```
非关键代码
```
public enum PhoneType {
    CELL_PHONE,
    FIXED_PHONE;
}
```

以上示例定义了一个Phone注解类，用于表示字端是否为phone类型字端，从示例中可以看到其定义结构情况：
1. @interface标识这是一个注解
2. 类上标识注解关键信息
    * @Retention 标识注解的策略，可选项包括：
        * SOURCE：Annotation仅存在于编译器处理期间，编译器处理完之后，该Annotation就没用了。
          例如，“ @Override ”标志就是一个Annotation。当它修饰一个方法的时候，就意味着该方法覆盖父类的方法；并且在编译期间会进行语法检查！编译器处理完后，“@Override”就没有任何作用了。
        * CLASS，则意味着：编译器将Annotation存储于类对应的.class文件中，它是Annotation的默认行为。
        * RUNTIME：编译器将Annotation存储于class文件中，并且可由JVM读入。
    * @Target 标识注解可以作用的目标对象，可选项为ElementType的各枚举值，主要包括任意类（类、接口、方法）、方法、属性、参数、本地变量、构造器等

## 3. annotation 使用场景
annotation一般会结合反射一起使用，常在一些技术框架中可以看到他们的身影，比如spring、hibernate等框架中就大量使用了注解，比如@RestController，另外开发插件lombok的注解，通过@Setter @Getter等注解在编译器动态的将属性等getter和setter方法加入到class类中，简化类开发和代码量。
annotation的使用一般分为几个过程：
1. 注解定义
2. 注解扫描
3. 扫描结果处理

annotation的定义用于后续的使用，根据注解策略分别在各个期间对其进行使用。比如以上示例中phone注解可以在运行期通过反射对对类中属性上标识了该注解的属性数据进行脱敏。

## 4.其他参考资料
[CSDN博客](https://www.cnblogs.com/skywang12345/p/3344137.html)