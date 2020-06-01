---
date: "2020-06-01"
draft: false
lastmod: "2020-06-01"
publishdate: "2020-06-01"
tags:
- architecture
title: GraphQL
---

# GraphQL

## 1. GraphQL简介

[graphql](https://graphql.org/)是一种针对API的查询语言，可以灵活填充用户真正需要且服务端存在的API的数据项。其核心价值是只拿用户需要的数据，而不需要你对原API进行重构。

## 2. GraphQL实现

### 2.1 GraphQL服务端API实现

服务端支持大多数的计算机多种语言，包括java、go、python等等。其API实现方式原理上大致类似，当前主要以java为主进行说明。

创建一个基于java的graphql server端主要操作主要包括一下两点：

1. 定义一个GraphQL schema。
2. 绑定一个查询如何获取到真正的数据

几个重点对象：

1. GraphQLSchema

   定义了graphQL查询用到的所有数据模型，用户端查询时以及结果返回的绑定都是通过该模型来处理的。

2. GraphQL

   一个GraphQLSchema对应一个GraphQL实例，是GraphQL的顶层封装，通过execute方法完成用户的查询。

3. DataFetchers

   一个数据获取接口，用于封装GraphQL数据查询逻辑。

4. PropertyDataFetcher

   DataFetchers的实现类，属性的默认DataFetcher，用于匹配属性值，默认按照属性名与查询中类型进行匹配。

5. ExecutionResult

   查询结果的顶层封装。

**官方核心流程示例代码：**

```
package com.leon.demo.graphql;

import graphql.ExecutionResult;
import graphql.GraphQL;
import graphql.schema.GraphQLSchema;
import graphql.schema.StaticDataFetcher;
import graphql.schema.idl.RuntimeWiring;
import graphql.schema.idl.SchemaGenerator;
import graphql.schema.idl.SchemaParser;
import graphql.schema.idl.TypeDefinitionRegistry;

public class HelloWorld {
    public static void main(String[] args) {
        //定义schema，项目中一般会定义在一个文件中，项目启动时进行加载
        String schema = "type Query{hello: String}";

        //解析并注册
        SchemaParser schemaParser = new SchemaParser();
        TypeDefinitionRegistry typeDefinitionRegistry = schemaParser.parse(schema);

        //将查询类型与数据获取绑定
        RuntimeWiring runtimeWiring = RuntimeWiring.newRuntimeWiring()
                .type("Query", builder -> builder.dataFetcher("hello", new StaticDataFetcher("world")))
                .build();

        //生成GraphQLSchema
        SchemaGenerator schemaGenerator = new SchemaGenerator();
        GraphQLSchema graphQLSchema = schemaGenerator.makeExecutableSchema(typeDefinitionRegistry, runtimeWiring);

        //执行查询
        GraphQL graphQL = GraphQL.newGraphQL(graphQLSchema).build();
        ExecutionResult executionResult = graphQL.execute("{hello}");

        System.out.println(executionResult.getData().toString());
        // Prints: {hello=world}
    }
}
```

### 2.2 GraphQL客户端请求

不同的客户端有不同的类库提供支持，具体参照官网。

