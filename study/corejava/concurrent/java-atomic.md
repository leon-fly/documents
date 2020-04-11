---
date: "2018-01-01"
draft: false
lastmod: "2018-01-01"
publishdate: "2018-01-01"
tags:
- corejava
- concurrent
title: java-atomic
---
# 1. atomic相关类简介
atomic相关类是java.util.concurrent下提供的一系列封装了原子性操做的类，主要包括基本数据类型包装类的原子操作类，如AtomicBoolean、AtomicInteger，以及数组及其他对象的原子操作类，如AtomicReference<V>、AtomicReferenceArray<E>。

**原子操作类清单**

| Class                            | Description                                                                                                            |
|----------------------------------|------------------------------------------------------------------------------------------------------------------------|
| AtomicBoolean                    | A boolean value that may be updated atomically.                                                                        |
| AtomicInteger                    | An int value that may be updated atomically.                                                                           |
| AtomicIntegerArray               | An int array in which elements may be updated atomically.                                                              |
| AtomicIntegerFieldUpdater<T>     | A reflection-based utility that enables atomic updates to designated volatile int fields of designated classes.        |
| AtomicLong                       | A long value that may be updated atomically.                                                                           |
| AtomicLongArray                  | A long array in which elements may be updated atomically.                                                              |
| AtomicLongFieldUpdater<T>        | A reflection-based utility that enables atomic updates to designated volatile long fields of designated classes.       |
| AtomicMarkableReference<V>       | An AtomicMarkableReference maintains an object reference along with a mark bit, that can be updated atomically.        |
| AtomicReference<V>               | An object reference that may be updated atomically.                                                                    |
| AtomicReferenceArray<E>          | An array of object references in which elements may be updated atomically.                                             |
| AtomicReferenceFieldUpdater<T,V> | A reflection-based utility that enables atomic updates to designated volatile reference fields of designated classes.  |
| AtomicStampedReference<V>        | An AtomicStampedReference maintains an object reference along with an integer "stamp", that can be updated atomically. |
| DoubleAccumulator                | One or more variables that together maintain a running double value updated using a supplied function.                 |
| DoubleAdder                      | One or more variables that together maintain an initially zero double sum.                                             |
| LongAccumulator                  | One or more variables that together maintain a running long value updated using a supplied function.                   |
| LongAdder                        | One or more variables that together maintain an initially zero long sum.                                               |

# 2. 关键类分析


# 3. 相关技术文档
