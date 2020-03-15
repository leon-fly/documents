---
title: "IssueReport组件使用"
date: 2018-01-01T00:00:00+08:00
draft: true
---
# 线上问题报告组件IssueReport使用说明

## 一、组件基本使用（基于spring）

1. 在项目的pom中引入zkj-micro-foundation （组件在该微服务中）
2. 在要进行问题报告的java类中将该类引入作为类属性，并使用spring进行实例注入

    ```java
    @Component
    public class xxx{
        @Autowired
        private IssueReporter issueReporter;

        public void methodXXX{
                Message message = Message.build()
                .header("title")
                .body("detail message"

                issueReporter.report(message);
        }
    }
    ```

## 二、建议问题报告处理方式

在业务处理结果层面调用汇总业务问题，如在controller层面进行而非底层如service/dao层反应细节问题。详细使用可参照 **zkj-micro-payment** 中 **PaymentResponseExceptionHandler**中的使用。
