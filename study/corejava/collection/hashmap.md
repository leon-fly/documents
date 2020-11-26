---
date: "2018-01-01"
draft: false
lastmod: "2018-01-01"
publishdate: "2018-01-01"
tags:
- corejava
- collection
title: Hashmap & ConcurrentHashMap
---

## 1. hashmap简介
hashmap实现了map接口，存储了key-value的数据形式。内部使用的数组、链表、红黑树的数据结构。

![hashmap](../../../picture/hashmap.png)

## 2. 重要概念
* Bin 桶（用来存储元素的数组）
* Capacity  桶的个数（数组的大小）
* Size hashmap元素个数，
* LoadFactor 加载因子,用来表示桶使用占比多少时进行扩容。加载因子越大，内存利用率越高，但是由于hash冲突问题，会降低查询效率，所以这个值是折衷默认是0.75
* TreeifyThreshold 桶中的数据进行树化的个数阀值,默认是8.
* UntreeifyThreshold 桶中的数据由树形结构调整为链表结构的个数阀值，默认是6.

## 3. 重要过程
一切尽在put函数，以下为put的大致逻辑过程。

![hashap-put](../../../picture/hashmap-put.png)
* resize（扩容）
hashmap的扩容发生在容器第一次put值和容量使用比大于加载因子设定的阀值时。resize过程涉及了rehash的动作。扩容大小为原来的两倍，另外resize只能扩容，不能缩容。

* 红黑树与链表转换
    链表转换红黑树是通过判断链表大小是否达到设定的阀值TREEIFY_THRESHOLD来确定是否转换的，这个值是8；另外转换红黑树还有最小容量限制，最小容量为64。
    > static final int TREEIFY_THRESHOLD = 8;

    > static final int MIN_TREEIFY_CAPACITY = 64;

    二叉树转换链表是通过判断红黑树节点数是否达到设定的阀值UNTREEIFY_THRESHOLD来确定是否需要转换的，这个值是6

    > static final int UNTREEIFY_THRESHOLD = 6;

## 4. 重要函数
### 4.1. 构造器
hashmap提供了四个构造器：
1. 空构造（默认的容量是16，加载因子0.75，容量一般设定为2的幂次）
2. 指定容量的构造
3. 指定容量和加载因子的构造
4. 使用已有的map构造。


## 5. HashMap中的相关问题
1. HashMap容量size为什么是2的幂次？

    hashmap存取对象时都是通过对象的key对size取模，正常取模运算的代价较大，如果对key与2的幂次进行与运算操作可以达到同样的效果，运算效率较高。索引hashmap的取余算法就是这么做的。不过它不强制你传入的size是2的幂次，它会在内部进行转换。
2. HashMap多线程下死循环？

    hashmap resize时使用新的数组对原数组的数据进行rehash并存入，hash冲突时同样使用链表法解决，当多个线程操作时可能形成循环链表。具体见推荐阅读。HashMap官方本身说明并非线程安全版本，需要在并发环境下操作的话使用ConcurrentHashMap,这是稳妥的办法。
3. Fast-fail

    在使用HashMap迭代器的过程中如果HashMap被修改，那么ConcurrentModificationException将被抛出，也即Fast-fail策略。在通过该Iterator的next方法访问下一个Entry时，会先检查自己的expectedModCount与HashMap的modCount是否相等，如果不相等，说明HashMap被修改，直接抛出ConcurrentModificationException。该Iterator的remove方法也会做类似的检查。该异常的抛出意在提醒用户及早意识到线程安全问题。

## 6. 关于ConcurrentHashMap
### 6.1. JDK1.7 实现基于分段锁方式
![concurrenthashmap_java7](../../../picture/concurrenthashmap_java7.png)

* 内部同步方式基于ReetrancLock(Segment继承了该锁)
* 插入、删除、获取时仅获取该分段的锁
* size获取

    ConcurrentHashMap会在不上锁的前提逐个Segment计算3次size，如果某相邻两次计算获取的所有Segment的更新次数（每个Segment都与HashMap一样通过modCount跟踪自己的修改次数，Segment每修改一次其modCount加一）相等，说明这两次计算过程中无更新操作，则这两次计算出的总size相等，可直接作为最终结果返回。如果这三次计算过程中Map有更新，则对所有Segment加锁重新计算Size。
* 

### 6.2. JDK1.8 实现基于CAS+大数组
![concurrenthashmap_java8](../../../picture/concurrenthashmap_java7.png)

* 内部同步方式基于CAS
* 操作

    对于put操作，如果Key对应的数组元素为null，则通过CAS操作将其设置为当前值。如果Key对应的数组元素（也即链表表头或者树的根元素）不为null，则对该元素使用synchronized关键字申请锁，然后进行操作。如果该put操作使得当前链表长度超过一定阈值，则将该链表转换为树，从而提高寻址效率。

    对于读操作，由于数组被volatile关键字修饰，因此不用担心数组的可见性问题。同时每个元素是一个Node实例（Java 7中每个元素是一个HashEntry），它的Key值和hash值都由final修饰，不可变更，无须关心它们被修改后的可见性问题。而其Value及对下一个元素的引用由volatile修饰，可见性也有保障。

详尽内容见推荐阅读。👇👇👇

## 7. 推荐阅读
[从ConcurrentHashMap的演进看Java多线程核心技术👍👍👍](http://www.jasongj.com/java/concurrenthashmap/)

