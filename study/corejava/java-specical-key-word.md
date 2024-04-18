---
date: "2018-01-01"
draft: false
lastmod: "2018-01-01"
publishdate: "2018-01-01"
categorys:
- Core Java
tags:
- java特性
title: java-specical-key-word
---

## 1. transient

修饰的成员变量不会被序列化(serialization)。

## 2. serialVersionUID

这个不算java的关键字，实现了Serializable接口的类一般会有一个类变量serialVersionUID用来标识java类的版本号，以便决策持久后的对象在类发生变化时是否能正确反序列化时。

## 3. volatile
用来修饰类属性，经过该关键字修饰的属性值可以保持在多个线程间的可见性，但是不保证起原子性。

## 4. synchronize
用来进行代码同步，可以包裹一段代码，也可以用来修饰一个方法标识为同步的方法。
