---
date: "2020-06-01"
draft: false
lastmod: "2020-06-01"
publishdate: "2020-06-01"
tags:
- design - bad practice
title: GraphQL
---

# design - bad practice

**项目中碰到的极差的设计范例**

1. 典型问题一 ： 逻辑控制交由前端

   * 需求：用户点击取消按钮进行车辆订单的取消，取消成功同步第三方系统最新状态。

   * 实现：后端提供两个服务，一个进行订单取消逻辑，一个进行第三方系统状态同步逻辑，前端先调用第一个接口，调用成功后继续调用第二个接口

   * 该实现的问题：

     * 前端与后端两次调用，外网网络传输性能不佳
     * 当第一次调用成功后由于潜在的网络问题可能导致第二个服务没有调用，导致多端系统的数据不一致性

   * 合理的方式：

     前端调用一次接口，后端进行整体控制。

   * 扩展

     * 前端只提供展示内容（UI/UX）及与其紧密关联的逻辑控制（如界面跳转），其他重业务逻辑计算及流程控制均应该放在后端

   



