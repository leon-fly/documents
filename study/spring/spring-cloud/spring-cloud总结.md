---
date: "2018-01-01"
draft: false
lastmod: "2018-01-01"
publishdate: "2018-01-01"
tags:
- spring
- spring-cloud
title: spring-cloud总结
---
## 1. spring boot - Spring Cloud的基础（Edgware.SR）

### 1.1. spring boot项目初始化
* [Spring Initializr.](https://start.spring.io/)快速生成项目框架
* spring-boot-starter-actuator 常用监控采集模块，可以自定义自己的健康检测器。
    * 其自身提供的原生端点有：
        * 应用配置类：获取应用程序中加载的应用配置、环境变量、自动化配置报告等与Spring Boot应用密切相关的配置类信息。
        * 度最指标类：获取应用程序运行过程中用于监控的度量指标， 比如内存信息、线程池信息、HTTP请求统计等。
        * 操作控制类：提供了对应用的关闭等操作类功能。
    * 本地开发访问原生端点出现权限问题，可以通过 **management.security.enabled=false** 进行关闭

## 2. Spring Cloud Eureka - 服务治理
### 2.1. 核心功能
* 服务注册
    * 服务方向注册中心注册服务，告知服务名、地址、端口、协议。
* 服务发现
    * 客户端调用服务时不在直接配置服务端地址，而是通过注册中心获取服务清单，通过某种机制像提供需要服务的其中一台进行请求。
* 服务清单维护
    * 服务注册中心以心跳的方式去检测清单中的服务的可用性（服务提供者维护一个心跳来持续告诉Eureka服务自己正常），即服务续约，定时任务定时扫描超过失效时间的服务从服务清单中剔除。
        > eureka.instance.lease-renewal-interval-in-seconds 设置心跳间隔
        
        > eureka.instance.lease-expiration-duration-in-seconds 定义服务失效时间
    * 本地开发 **eureka.server.enable-self-preservation**设置为false，关闭自我保护机制，提高开发效率
### 2.2. 基本使用
#### 2.2.1. Eureka服务中心创建
* 创建springboot项目并增加导入Eureka依赖
    ```
   <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-netflix-eureka-server</artifactId>
    </dependency>
   ```
* 在启动类增加Eureka服务注解 **@EnableEurekaServer**
* 配置服务,核心配置参考如下：
    ```
    server:
        port: 9999
    eureka:
    instance:
        hostname: localhost
    client:
        registerWithEureka: false
        fetchRegistry: false
        serviceUrl:
            defaultZone: http://${eureka.instance.hostname}:${server.port}/eureka/
    ```
* 查看管理平台：http://localhost:/9999
* 高可用服务注册中心
    * 实现策略即将注册中心作为服务注册到其他服务注册中心，互相注册(互相持有对方的服务清单)，多个注册中心用逗号[,]隔开。
        > eureka.client.serviceUrl.defaultZone=http://peerl:1111/eureka/,http://peer2:1111/eureka/

#### 2.2.2. 服务注册
* 导入Eureka依赖
```
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-eureka</artifactId>
</dependency>
```
* 配置服务,核心配置参考如下：

```
spring:
application:
    name: api
eureka:
    client:
        serviceUrl:
            defaultZone: http://localhost:9999/eureka/        
```
当服务注册中心为集群时，defaultZone为所有集群节点服务地址，地址之间用逗号[,]隔开。此时进行服务注册时
* springboot启动入口增加注解 **@EnableDiscoveryClient**

#### 2.2.3. 服务消费
* 导入Eureka依赖,同服务注册
* 配置服务，配置内容类似服务注册
* springboot启动入口增加注解 **@EnableDiscoveryClient**
* 通过spring提供的RestTemplate来请求，在传统的请求方式上将hostname更换为应用名（**spring.application.name**定义的）即可,服务名大小写不敏感
* 在服务中心为集群，在本地进行负载均衡处理时需要引入ribbon或其他负载组件，在请求组件RestTemplate创建的方法上使用注解 **@LoadBalanced**

#### 2.2.4. 思考与总结
* 服务消费端和服务提供端相对eureka服务来讲都是客户端，并无区别
* 服务注册中心解决什么问题？

    服务注册中是当前微服务架构下必须的组件。试想在没有注册中心时，应用服务器的扩展是怎么做的？没错一般都是通过负载均衡，由运维人员进行手动维护。在微服务架构下，微服务数量可能成百上千，这种方式将成为运维人员的噩梦。服务注册中心的出现通过从程序端进行配置注册中心，实现服务的自动注册与发现，很好的解决类这个问题。
* Eureka的集群模式是怎样的？

    Eureka集群模式下，每个节点需要配置非自身的所有注册中心，采用Peer to Peer对等通信，是一种去中心化的架构，无master/slave之分。当某一个节点接收到服务注册请求会把该新信息同步给集群其他节点。当新加入一个集群节点时，该节点会从临近节点获取服务注册清单。服务的注册、续约与下线均由注册时的节点来通信和进行相关维护工作。
* 集群下的服务注册/续约/下线是怎么做的？

    服务提供者配置所有的服务注册中心，并从中选1个节点对该服务提供者节点进行维护及同步，该节点处理完成之后对配置的其他节点进行广播达到集群注册进行同步。当有新的注册中心节点加入时，会首先尝试从临近节点进行同步数据。

* 注册中心对失效服务剔除
  
    注册中心每隔一段时间（默认60s）将当前清单中超时（默认90s）没有进行续约的服务进行剔除。考虑可能因为网络问题等非服务下线或故障原因而导致续约失败，注册中心有一个自我保护机制，如果在运行期间，统计心跳失败的比例在15分钟之内低于85%，将不会对相关服务进行剔除。

* 注册中心节点与其他节点中断内部如何处理？

* 消费者通过注册中心调用服务的过程时怎么样的？

    Eureka客户端每30s（默认）从服务端更新一次服务注册信息。

* Eureka概览
![Eureka模式](../../../picture/Eureka.png)


#### 2.2.5. 参考
[Eureka缓存机制](https://www.infoq.cn/article/y_1BCrbLONU61s1gbGsU)



## 3. Spring Cloud Ribbon - 客户端负载均衡
### 3.1. 基本使用方法
* 增加导入ribbon依赖
```
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-ribbon</artifactId>
</dependency>
```
* 用于请求服务的RestTemplate请求组建上注解 **@LoadBalanced**
示例：
```
@Bean
@LoadBalanced
public RestTemplate restTemplate(){
    return new RestTemplate();
}
```

## 4. Spring Cloud Hystrix - 服务器容错保护
### 4.1. 基本使用方法
* 导入hystrix依赖
```
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-hystrix</artifactId>
</dependency>
```
* 启动类增加注解 **@EnableCircuitBreaker** 或 **@SpringCloudApplication**（该注解包含EnableCircuitBreaker注解）

* 在有服务调用的方法上添加注解 **@HystrixCommand(fallbackMethod = "xxx")**,fallbackMethod方法需要在同一个类中

### 4.2. [hystrix原理](https://github.com/Netflix/Hystrix/wiki)
* 命令模式

## 5. Spring Cloud Reign - 声明式服务调用
声明式服务调用与webservice生成本地客户端代码进行调用类似
### 5.1. 基本使用方法
* 导入reign依赖
```
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-feign</artifactId>
</dependency>
```
* 启动类中增加注解 **@EnableFeignClients**
* 编写调用第三方服务的接口类，分别在类上增加 **@FeignClient** 注解，方法上增加注解 **@RequestMapping**。

    示例：
    ```
    @FeignClient("EUREKA-PROVIDER")  // 调用的服务名
    public interface HelloService {
        @RequestMapping("/spring-cloud-demo/eureka-provider/hello-world") //服务地址
        String hello();
    }
    ```

* 在其他类中注入定义的接口进行服务调用

### 5.2. 带参数的使用
相关注解参照包**org.springframework.web.bind.annotation**
```
@FeignClient ("EUREKA-PROVIDER")
public interface HelloService {
    @RequestMapping("/hello")
    String hello();

    @RequestMapping(value = "/hellol", method= RequestMethod.GET)
    String hello(@RequestParam("name") String name) ;

    @RequestMapping(value = "/hello2", method= RequestMethod.GET)
    User hello(@RequestHeader("name") String name, @RequestHeader("age") Integer
    age);

    @RequestMapping(value = "/hello3", method= RequestMethod.POST)
    String hello(@RequestBody User user);
```

### 5.3. 高级使用
使用regin进行声明式调用可以通过抽出服务端和客户端公用代码进行共享，避免类的重复编码。公用部分主要包括dto类，以及接口定义。通过将该部分单独打包上传私库方式实现。

#### 5.3.1. 对于该公共部分的使用：
* 将公共部分打包上传maven仓库
* 在服务端和客户端分别引入
* 客户端使用时，接口定义继承jar包中的接口，接口注解**@FeignClient**即可
* 服务端使用时，controller实现接口即可。

#### 5.3.2. 注意事项
* 这种方式使用不当会造成客户端不可用，开发时应注意开闭原则。

### 5.4. 说明
* regin的客户端负载使用的是ribbon
* regin引入了服务保护与容错的工具Hystrix，默认情况下，Spring Cloud Feign会为将所有Feign客户端的方法都封装到Hystrix命令中进行服务保护，可以通过参数进行禁用。

### 5.5. 重要配置
#### 5.5.1. ribbon配置
* 全局配置同Spring Cloud ribbon
    > 格式：**ribbon.<key>=value**
* 指定服务配置
    > 格式：**\<client>.ribbion.<key>=value**
    

    示例：EUREKA-PROVIDER.ribbon.ConnectTimeout=3000
    
    client即@FeignClient指定的服务名
* 常用参数
    > ConnectTimeout 连接超时时间

    > ReadTimeout 读取超时时间

    > OkToRetryOnAllOperations

    > MaxAutoRetriesNextServer 请求失败更换服务实例的次数

    > MaxAutoRetries 首选服务实例重试的次数

#### 5.5.2. hystrix配置

* 全局配置同Spring Cloud ribbon的全局配置一样，直接使用它的默认配置前缀**hystrix.command.defaut**就可以进行设置

* 禁用配置
    * 全局禁用
        > feign.hystrix.enabled=false
    * 部分client禁用需要通过使用@Scope ("prototype")注解为指定的客户端配置Feign.Builder实例
* 指定命令配置、服务降级配置、日志配置及其他配置（如服务请求及返回压缩）

## 6. Spring Cloud Zuul - Api网关
### 6.1. zuul的作用
zuul在微服务架构中作为网关的角色，主要包括两部分：
* 请求路由
* 统一安全管控
在没有网关的微服务架构中，微服务提供的服务安全处理各自为战，存在大量的冗余，请求路径也可可能根据服务编码组的不同杂乱无章。网关的出现通过统一安全处理，统一请求路径，从外部看整齐划一，这是设计模式中的典型的门面模式。

### 6.2. 在spring cloud 体系中 zuul的使用
zuul本身是一个独立的项目，使用java语言开发，提供的核心功能即上面提到的两部分。spring cloud zuul通过将zuul与euraka、hystrix、ribbon组合形成一个足够灵活、健壮、高可用的网关架构体系。

#### 6.2.1. 基本使用
* 依赖导入
    ```
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-zuul</artifactId>
    </dependency>
    ```
* 配置服务名、端口、路由规则
* 启用zuul，需要在入口类增加核心注解如下：
    > @EnableZuulProxy
  
  但是不能忘了这个是急于spring cloud环境，所以还需要 **@SpringCloudApplication**
#### 6.2.2. 安全处理
以上完成类最基本的使用工作，达到了路由的目的。那么**安全怎么处理？**
在zuul中是通过Filter来达到这个目的的，在zuul中有一个**抽象类Filter**，子类继承该类后形成一个过滤器链，在过滤器中可以通过RequestContent（请求的一个上下文）来处理请求内容，如鉴权，对请求头等进行修改达到某种作用。示例代码：
```
public class AccessFilter extends ZuulFilter {
    @Override
    public String filterType() {
        return "pre";
    }

    @Override
    public int filterOrder() {
        return 0;
    }

    @Override
    public boolean shouldFilter() {
        return true;
    }

    @Override
    public Object run() {
        RequestContext requestContext = RequestContext.getCurrentContext();
        HttpServletRequest request = requestContext.getRequest();
        log.info("send {} request to{}", request.getMethod(),
                request.getRequestURL().toString());

        Object accessToken = request.getParameter("accessToken");
        if (accessToken == null) {
            log.warn("access token is empty");
            requestContext.setSendZuulResponse(false);
            requestContext.setResponseStatusCode(401);
            return null;
        }

        log.info("access token ok");
        return null;
    }
}
```
**从以上可以看出，子类需要重写四个方法：**
* filterType 过滤类型，用于确定过滤器在什么时机执行，官方列出的几个可选值及说明如下：
    * Standard types in Zuul are "pre" for pre-routing filtering,
    * "route" for routing to an origin, "post" for post-routing filters
    * "error" for error handling.
* filterOrder 过滤器排序
* shouldFilter 是否要过滤当前请求
* run() 过滤具体执行的逻辑。

#### 6.2.3. 路由配置

## 7. Spring Cloud Config - 分布式配置中心

## 8. Spring Cloud Bus - 消息总线