---
title: "java-cyclic-barrier"
date: 2018-01-01T00:00:00+08:00
draft: true
---
# 1. CyclicBarrier循环屏障简介
CyclicBarrier基于ReentrancLock实现，这个同步器是允许一系列线程在同一个屏障点等待，直到所有的线程都到达屏障点后唤醒，每一次突破屏障点可以执行一个Runable任务，这个屏障可以重复使用。

# 2. 使用示例

```
public class CyclicBarrierDemo {

    public static void main(String[] args) {
        int threadNum = 5;
        CyclicBarrier cyclicBarrier = new CyclicBarrier(threadNum, new Runnable() {
            @Override
            public void run() {
                System.out.println("barrier冲破--------------");
            }
        });

        for (int i = 0; i < threadNum; i++) {
            MyThread thread = new MyThread(cyclicBarrier);
            thread.start();
        }
    }

}

class MyThread extends Thread {
    private CyclicBarrier cyclicBarrier;

    MyThread(CyclicBarrier cyclicBarrier) {
        this.cyclicBarrier = cyclicBarrier;
    }

    @Override
    public void run() {
        try {
            Random random = new Random();
            System.out.println(Thread.currentThread().getId() + ":step A start...");
            Thread.currentThread().sleep(random.nextInt(5000));
            System.out.println(Thread.currentThread().getId() + ":step A finished");

            cyclicBarrier.await();

            System.out.println(Thread.currentThread().getId() + ":step B start...");
            Thread.currentThread().sleep(random.nextInt(5000));
            System.out.println(Thread.currentThread().getId() + ":step B finished");
            cyclicBarrier.await();
        } catch (InterruptedException | BrokenBarrierException e) {
            e.printStackTrace();
        }
    }
}

```

运行结果

```
10:step A start...
11:step A start...
12:step A start...
13:step A start...
14:step A start...
10:step A finished
13:step A finished
11:step A finished
14:step A finished
12:step A finished
barrier冲破--------------
12:step B start...
10:step B start...
13:step B start...
11:step B start...
14:step B start...
12:step B finished
11:step B finished
10:step B finished
13:step B finished
14:step B finished
barrier冲破--------------
```

# 3. 核心方法实现说明

## 3.1. await
* 不带参的方法
 该方法的主要逻辑为获取lock，将计数减1并判断当前计数是0，如果计数为0表示所有线程都到达指定的屏障点，便唤醒所有线程，并执行指定的冲破屏障后的方法。

* 带超时时间参数
  带该参数时表示在该时长内没有冲破屏障线程将出现BrokenBarrierException，屏障前的代码可以将执行完，屏障后的代码将无法执行。

## 3.2. 构造方法
* CyclicBarrier(int parties)
仅仅指定需要达到屏障点的线程个数
* CyclicBarrier(int parties, Runnable barrierAction)
指定的到达屏障点的线程数达到，barrierAction将被执行。
