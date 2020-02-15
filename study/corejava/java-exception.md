# Exception研究

参考资料<https://www.javaworld.com/article/2076868/learn-java/how-the-java-virtual-machine-handles-exceptions.html>

## 一、异常通常处理原则（结合 极客时间 杨晓峰）

1. 仅仅捕获特定异常,如下例中仅捕获Thread.sleep() 抛出的 InterruptedException

    ```java
    try {
    // 业务代码
    // …
    Thread.sleep(1000L);
    } catch (Exception e) {
    // Ignore it
    }
    ```

2. 不生吞异常，即生产中异常信息需要通过输出组件输出到合理的地方。
    ```java
    try {
    // 业务代码
    // …
    } catch (IOException e) {
        e.printStackTrace();
    }
    ```
3. Throw early, catch late

越早发现问题，越早跑出异常，使定位更容易。

## 二、 Exception处理对性能的影响

1. 当没有异常运行时抛出时，性能无异
2. 当运行时抛出异常时，异常堆栈深度越深越耗时，创建耗时，读取耗时。

相关测试代码 <https://github.com/leon-fly/demo/blob/master/corejava/src/main/java/com/leon/demo/throwable_/ExceptionByteCodeStudy.java>

## 三、异常类比较

> ClassNotFoundException & NoClassDefFoundError
ClassNotFountException一般为使用类名加载类时会出现的一种异常。
NoClassDefFoundError则为编译成功，但是在运行期间找不到的一种错误。
