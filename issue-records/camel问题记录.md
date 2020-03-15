---
title: "camel问题记录"
date: 2018-01-01T00:00:00+08:00
draft: true
---
# 一、AsyncProcessor接口中process方法的callback参数

* 问题描述：在项目停止后有camel消息队列中有大量未处理消息（实际这些消息已处理）

堆栈信息如下：

```txt
2018-09-13 18:16:18.068  INFO 6327 --- [      Thread-36] ationConfigEmbeddedWebApplicationContext : Closing org.springframework.boot.context.embedded.AnnotationConfigEmbeddedWebApplicationContext@d62fe5b: startup date [Thu Sep 13 18:15:29 CST 2018]; root of context hierarchy
2018-09-13 18:16:18.083  INFO 6327 --- [      Thread-36] o.s.c.support.DefaultLifecycleProcessor  : Stopping beans in phase 2147483647
2018-09-13 18:16:18.083  INFO 6327 --- [      Thread-36] o.a.camel.spring.SpringCamelContext      : Apache Camel 2.21.1 (CamelContext: camel-1) is shutting down
2018-09-13 18:16:18.084  INFO 6327 --- [      Thread-36] o.a.camel.impl.DefaultShutdownStrategy   : Starting to graceful shutdown 6 routes (timeout 300 seconds)
2018-09-13 18:16:18.088  INFO 6327 --- [ - ShutdownTask] o.a.camel.impl.DefaultShutdownStrategy   : Waiting as there are still 1 inflight and pending exchanges to complete, timeout in 300 seconds. Inflights per route: [Route-Gitlab = 1]
2018-09-13 18:16:18.092  INFO 6327 --- [ - ShutdownTask] o.a.camel.impl.DefaultShutdownStrategy   : There are 1 inflight exchanges:
InflightExchange: [exchangeId=ID-LeonWangdeMacBook-Pro-local-1536833736095-0-1, fromRouteId=Route-Gitlab, routeId=Route-Gitlab, nodeId=process2, elapsed=0, duration=9090]
2018-09-13 18:16:19.096  INFO 6327 --- [ - ShutdownTask] o.a.camel.impl.DefaultShutdownStrategy   : Waiting as there are still 1 inflight and pending exchanges to complete, timeout in 299 seconds. Inflights per route: [Route-Gitlab = 1]
...

```

代码如下：

```java
@Component
public class GitlabProcessor implements AsyncProcessor {
    @Autowired
    private Gitlab gitlab;

    @Override
    public boolean process(Exchange exchange, AsyncCallback callback) {
        Message message = exchange.getIn().getBody(Message.class);
        gitlab.sendMessage(message);
        //问题点，缺少该行代码导致camel的消息发出去之后未得到正确反馈一直在队列中。
        callback.done(false);  
        return false;
    }

    @Override
    public void process(Exchange exchange) throws Exception {
        throw new IllegalStateException("Should never be called");
    }
}
