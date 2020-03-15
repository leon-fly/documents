---
title: "java-forkjoin"
date: 2018-01-01T00:00:00+08:00
draft: true
---
<!-- TOC -->

- [1. fork/join简介](#1-forkjoin简介)
- [2. fork/join关键类及接口](#2-forkjoin关键类及接口)
- [3. 使用示例](#3-使用示例)
- [4. 参考资料](#4-参考资料)

<!-- /TOC -->
# 1. fork/join简介
fork/join框架是jdk1.7之后提供的并发处理工具，是ExecutorService接口的一个实现。其主要思想是将一个大的任务通过fork拆分成多个子任务，当子任务都执行结束后再通过join将各个子任务结果合并，这种方式是对多处理器的充分利用，使用了一种分治的思想。

# 2. fork/join关键类及接口

* **ForkJoinPool** 这是fork/join框架最核心的的类，AbstractExecutorService的子类。它实现类核心的工作窃取算法，可以执行**ForkJoinTask**.

* **ForkJoinTask** 这是fork/join框架具体工作类，经常用到的两个子类是 **RecursiveAction**（无返回值）和**RecursiveTask**（有返回值）。只要实现方法中的execute()方法即可。方法实现逻辑为：

    ```
    if (my portion of the work is small enough)
        do the work directly
    else
        split my work into two pieces
        invoke the two pieces and wait for the results
    ```


# 3. 使用示例
* 工作任务：计算连续整数n-m的和。
* 逻辑：为了快速计算将该任务拆分成多个子任务，每个子任务最多只能计算五个数，如果任务不够小，继续拆分。
* 示例
```
public class ForkJoinDemo {
	public static void main(String[] args) {
		ForkJoinPool forkJoinPool = new ForkJoinPool(3);
		// 生成一个计算任务，负责计算1+2+3+4...
		TestForkJoin task = new TestForkJoin(1, 20000);
		// 执行一个任务
		Future<Integer> result = forkJoinPool.submit(task);
		try {
			System.out.println(result.get());
		} catch (InterruptedException e) {
		} catch (ExecutionException e) {
		}
	}
}

class TestForkJoin extends RecursiveTask<Integer> {
	private static final long serialVersionUID = 1L;
	private static final int THRESHOLD = 5;// 阈值
	private int start;
	private int end;
	public TestForkJoin(int start, int end) {
		this.start = start;
		this.end = end;
	}

	@Override
	protected Integer compute() {
		int sum = 0;
		// 如果任务足够小就计算任务
		boolean canCompute = (end - start) <= THRESHOLD;
		if (canCompute) {
			for (int i = start; i <= end; i++) {
				sum += i;
			}
			System.out.println("线程："+Thread.currentThread().getName());
		} else {
			// 如果任务大于阀值，就分裂成两个子任务计算
			int middle = (start + end) / 2;
			TestForkJoin leftTask = new TestForkJoin(start, middle);
			TestForkJoin rightTask = new TestForkJoin(middle + 1, end);

			// 执行子任务
			leftTask.fork();
			rightTask.fork();

			// 等待子任务执行完，并得到其结果
			int leftResult = leftTask.join();
			int rightResult = rightTask.join();

			// 合并子任务
			sum = leftResult + rightResult;
		}
		return sum;
	}
}



```


# 4. 参考资料

[Oracle官方](https://docs.oracle.com/javase/tutorial/essential/concurrency/forkjoin.html)

