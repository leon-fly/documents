---
date: "2018-01-01"
draft: false
lastmod: "2018-01-01"
publishdate: "2018-01-01"
tags:
- corejava
- concurrent
title: java-thread-local
---

## 1. ThreadLocal简介
官方说：ThreadLocal提供线程级别的变量，这些变量与普通变量不同，每个线程都有独立的初始化的变量副本。简单理解，ThreadLocal提供了一个线程执行中的上下文环境，各自线程拥有与其他线程互不干扰的变量环境。

## 2. 使用说明
* 初始化 ThreadLocal<T>() threadLocal = new ThreadLocal<>().
* 设置值 threadLocal.set(value)
* 获取值 threadLocal.get(value)

**示例代码**
示例展示了各个线程设置和获取自己的线程变量，互不干涉,从执行结果可以看出.
```
public class ThreadLocalDemo {
    ThreadLocal<Integer> threadLocal = new ThreadLocal<>();


    public void setThreadLocalValue(int value) {
        threadLocal.set(value);
        System.out.println(Thread.currentThread().getName() + ":设置线程变量值为：" + value);
    }

    public Integer getThreadLocalValue() {
        Integer value = threadLocal.get();
        System.out.println(Thread.currentThread().getName() + ":获取线程变量值为：" + value);
        return value;
    }

    public static void main(String[] args) {
        ThreadLocalDemo td = new ThreadLocalDemo();
        int threadNum = 30;
        for (int i=0;i<threadNum;i++){
            new Thread(new Runnable() {
                Random random = new Random();
                @Override
                public void run() {
                    td.setThreadLocalValue(random.nextInt(100000));
                    try {
                        //避免线程一口气执行完，让它停一会儿让其他线程执行
                        Thread.currentThread().sleep(random.nextInt(5000));
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                    td.getThreadLocalValue();
                }
            }, "Thread-" + i).start();
        }
    }

}
```

## 3. 类图
![ThreadLocal类图](../../../picture/ThreadLocal.png)

## 4. 源码分析

![](../../../picture/ThreadLocalView.png)

1. 每个Thread内部持有一个ThreadLocalMap,ThreadLocalMap是ThreadLocal内部定义了一个静态内部类（并没有实现map接口，内部使用了一个Entry数组来存储Thread各自线程变量）。每个Thread有一个自己的ThreadLocalMap，当设置/获取值时，都先会获取当前线程，通过当前线程获取到ThreadLocalMap, key为ThreadLocal, 通过该key获取到对应的值。

   设置值：

   ```
   public void set(T value) {
           Thread t = Thread.currentThread();
           ThreadLocalMap map = getMap(t);
           if (map != null)
               map.set(this, value);
           else
               createMap(t, value);
       }
   ```

   获取值

   ```
   public T get() {
       Thread t = Thread.currentThread();
       ThreadLocalMap map = getMap(t);
       if (map != null) {
           ThreadLocalMap.Entry e = map.getEntry(this);
           if (e != null) {
               @SuppressWarnings("unchecked")
               T result = (T)e.value;
               return result;
           }
       }
       return setInitialValue();
   }
   ```

2. ThreadMapLocal实现

   ThreadMap并无实现map接口，其内部通过一个Entry数组来实现，Entry继承了弱引用。

   ```
   static class Entry extends WeakReference<ThreadLocal<?>> {
       /** The value associated with this ThreadLocal. */
       Object value;
   
       Entry(ThreadLocal<?> k, Object v) {
           super(k);
           value = v;
       }
   }
   ```

## 5. 相关技术文档

[Oracle ThreadLocal说明](https://docs.oracle.com/javase/8/docs/api/java/lang/ThreadLocal.html)