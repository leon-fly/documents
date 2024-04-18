---
date: "2018-01-01"
draft: false
lastmod: "2018-01-01"
publishdate: "2018-01-01"
categorys:
- Core Java
tags:
- corejava
- concurrent
title: java-thread-pool-executor
---

# ThreadPoolExecutor

## 1. 构造函数分析

以下为最多参数的构造函数，另外还有其他几个参数个数不通的构造函数，参数字段基本在以下几个之中。

```
public ThreadPoolExecutor(int corePoolSize,
                              int maximumPoolSize,
                              long keepAliveTime,
                              TimeUnit unit,
                              BlockingQueue<Runnable> workQueue,
                              ThreadFactory threadFactory,
                              RejectedExecutionHandler handler)
```

* corePoolSize 线程池保留的最小核心线程数。线程池中线程的添加是通过execute方法执行任务达到的，当核心线程数未达到指定值时一直往上加。
* maximumPoolSize 允许的最大线程数。
* keepAliveTime 线程空闲超时时间
* unit 时间单元
* workQueue 用于存放任务的队列
* threadFactory 线程工厂
* handler 用于处理因当线程不够用且任务队列满了时处理被拒绝的线程

## 2. ThreadPoolExecutor相关机制

1. 线程池线程数增加机制是怎么样的？

   当执行execute方法时，如果少于核心线程数的线程在运行将会创建新线程并以传入的Runnable作为它第一个任务。如果大于核心线程数则将任务入队，入队失败则继续增加线程直到最大线程数。

2. 什么情况下会触发RejectedExecutionHandler拒绝任务？

   * 当Executor处于非运行状态时
   * 当为新任务添加工作线程失败时

3. 线程池中的线程是如何重用的？

   线程创建时会需要绑定一个Runnable，而后调用线程的start方法。乍一看，线程的创建后一次性使用啊，怎么做到复用呢？在ThreadPoolExecutor内部封装了一个Worker类作为工作线程，该类实现了Runnable，内部则使用while循环来从ThreadPoolExecutor的队列中获取Runnable任务再调用其run方法。

   **Worker构造方法如下：**

   ```
    Worker(Runnable firstTask) {
        setState(-1); // inhibit interrupts until runWorker
        this.firstTask = firstTask;
        this.thread = getThreadFactory().newThread(this);
    }
   ```

   从以上代码可以看到创建新Worker时会绑定一个Runnable任务作为第一个任务并创建一个Thread作为该Worker的工作线程。

   **线程重用关键点run方法**

   ```
       public void run() {
           runWorker(this);
       }
   
   		final void runWorker(Worker w) {
           Thread wt = Thread.currentThread();
           Runnable task = w.firstTask;
           w.firstTask = null;
           w.unlock(); // allow interrupts
           boolean completedAbruptly = true;
           try {
           		//当前task不为空执行task，当前task为空则调用getTask获取新任务
               while (task != null || (task = getTask()) != null) { 
                   w.lock();
                   // If pool is stopping, ensure thread is interrupted;
                   // if not, ensure thread is not interrupted.  This
                   // requires a recheck in second case to deal with
                   // shutdownNow race while clearing interrupt
                   if ((runStateAtLeast(ctl.get(), STOP) ||
                        (Thread.interrupted() &&
                         runStateAtLeast(ctl.get(), STOP))) &&
                       !wt.isInterrupted())
                       wt.interrupt();
                   try {
                       beforeExecute(wt, task);
                       Throwable thrown = null;
                       try {
                           task.run();
                       } catch (RuntimeException x) {
                           thrown = x; throw x;
                       } catch (Error x) {
                           thrown = x; throw x;
                       } catch (Throwable x) {
                           thrown = x; throw new Error(x);
                       } finally {
                           afterExecute(task, thrown);
                       }
                   } finally {
                       task = null;
                       w.completedTasks++;
                       w.unlock();
                   }
               }
               completedAbruptly = false;
           } finally {
               processWorkerExit(w, completedAbruptly);
           }
   		}
   		
   		//从队列中获取任务
       private Runnable getTask() {
           boolean timedOut = false; // Did the last poll() time out?
   
           for (;;) {
               int c = ctl.get();
               int rs = runStateOf(c);
   
               // Check if queue empty only if necessary.
               if (rs >= SHUTDOWN && (rs >= STOP || workQueue.isEmpty())) {
                   decrementWorkerCount();
                   return null;
               }
   
               int wc = workerCountOf(c);
   
               // Are workers subject to culling?
               boolean timed = allowCoreThreadTimeOut || wc > corePoolSize;
   
   						//线程池线程剔除关键，当返回空任务时worker将退出
               if ((wc > maximumPoolSize || (timed && timedOut))
                   && (wc > 1 || workQueue.isEmpty())) {
                   if (compareAndDecrementWorkerCount(c))
                       return null;
                   continue;
               }
   
               try {
                   Runnable r = timed ?
                   		//限时阻塞获取
                       workQueue.poll(keepAliveTime, TimeUnit.NANOSECONDS) :
                       //阻塞获取
                       workQueue.take();
                   if (r != null)
                       return r;
                   timedOut = true;
               } catch (InterruptedException retry) {
                   timedOut = false;
               }
           }
       }
   ```

4. 线程池线程剔除机制时怎么样的？

   线程池的踢除的核心逻辑是Work在run时循环调用getTask方法获取可执行任务，当获取不到时该工作线程退出。那么退出的关键即getWork是否返回空任务。getWork的逻辑在关注几个点：队列是否为空，是否允许核心线程空闲时仍存留，当前线程数是否已大于核心线程数。剔除发生的必要条件（具体逻辑参考以上getWork源码）：

   * 当前线程数大于1，或者当前任务队列为空

   * 当前线程数大于最大线程数，或者在设置了线程空闲时间keepAliveTime当情况下，当上次获取工作任务超时未获取到并且当前线程数大于核心线程数

5. 核心线程数可以剔除吗？如何保证核心线程数？

   当构建ThreadPoolExecutor指定keepAliveTime大于0时代表线程空闲超过该时间时将剔除，当等于0时代表不剔除。即当该值设置为0时可保证核心线程数。