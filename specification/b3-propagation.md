---
date: "2021-01-03"
draft: false
lastmod: "2021-01-03"
publishdate: "2021-01-03"
tags:
- specification
title: b3-propagation
---

# B3-Propagation

[b3-propagation](https://github.com/openzipkin/b3-propagation)是请求头"b3"或以"x-b3-"打头的规范，这些头是用来夸服务跟踪上下文传播信息的，常用于微服务的服务请求调用跟踪，其作用类似于  [w3c trace-context](https://www.w3.org/TR/trace-context/).

```
 Client Tracer                                                  Server Tracer     
┌───────────────────────┐                                       ┌───────────────────────┐
│                       │                                       │                       │
│   TraceContext        │          Http Request Headers         │   TraceContext        │
│ ┌───────────────────┐ │         ┌───────────────────┐         │ ┌───────────────────┐ │
│ │ TraceId           │ │         │ X-B3-TraceId      │         │ │ TraceId           │ │
│ │                   │ │         │                   │         │ │                   │ │
│ │ ParentSpanId      │ │ Inject  │ X-B3-ParentSpanId │ Extract │ │ ParentSpanId      │ │
│ │                   ├─┼────────>│                   ├─────────┼>│                   │ │
│ │ SpanId            │ │         │ X-B3-SpanId       │         │ │ SpanId            │ │
│ │                   │ │         │                   │         │ │                   │ │
│ │ Sampling decision │ │         │ X-B3-Sampled      │         │ │ Sampling decision │ │
│ └───────────────────┘ │         └───────────────────┘         │ └───────────────────┘ │
│                       │                                       │                       │
└───────────────────────┘                                       └───────────────────────┘
```

## 1. Identifiers

用于跟踪的标识符主要有 traceId, spanId, parentSpanId, 他们都是64位或者128位。spanId和parentSpanId都是64位，traceId可以是64位或者128位。

### TraceId

traceId是一个64位或128位的全局跟踪id，整个跟踪链路共享此ID。http header key使用**X-B3-TraceId**,并且被编码为16进制的小写字符。如：

> X-B3-TraceId: 463ac35c9f6413ad48485a3953bb6124

除非仅传播采样状态，否则在b3-propagation中是必须传输的。

### SpanId

SpanId是一个64位长的标识符，标识当前操作在整个跟踪链路的位置。该数据的值与TraceId不一定有关系。http header key使用**X-B3-SpanId**，并且被编码为16进制的小写字符。如：

>X-B3-SpanId: a2fb4a1d1a96d312

除非仅传播采样状态，否则在b3-propagation中是必须传输的。

### ParentSpanId

ParentSpanId是一个64位长的标识符，标识父操作在整个跟踪链路的位置。若当前操作为跟踪链路中第一个操作，那么当前操作没有该值。http header key使用 **X-B3-ParentSpanId**，并且被编码为16进制的小写字符。如：

> X-B3-ParentSpanId: 0020000000000001

### Sampling State

采样是一种为了减少跟踪系统中最终数据量的机制。在B3规范中，每次跟踪采样均一致，一旦确认是否采样，这个采样状态会一直被向下传递。该标识是作用于一个共享的TraceId而不是SpanId。有效的一些状态如下：

* Defer  当traceId被代理器设置，且代理期不会发送数据到Zipkin时使用该状态。当该状态不被设置时就标识是Defer状态
* Deny 不进行采样
* Accept  进行采样
* Debug 用户生产问题调试。是Accept

http header key使用**X-B3-Sampled**，值为1代表accept，0代表deny，确实代表defer。

## 2. Encoding

以上规范中标识符的传输均会通过encoding后传输。该方式在Zipkin的框架中被预制，可以自行定制化，但是一般预制的方式已经可以满足大部分场景。B3有两种Http 的 encoding方式，一种是单一header的方式，一种是多header的方式。

多header方式：

```
X-B3-TraceId: 80f198ee56343ba864fe8b2a57d3eff7
X-B3-ParentSpanId: 05e3ac9a4f6e3b90
X-B3-SpanId: e457b5a2e4d86bd1
X-B3-Sampled: 1
```

单一header方式是将所有的标识符通过“-”连接起来，header变为b3,格式为 **b3={TraceId}-{SpanId}-{SamplingState}-{ParentSpanId}**，示例如下：

> ```
> b3: 80f198ee56343ba864fe8b2a57d3eff7-e457b5a2e4d86bd1-1-05e3ac9a4f6e3b90
> ```

