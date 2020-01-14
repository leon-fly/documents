# 1. spring boot - Spring Cloud的基础（Edgware.SR3）

## 1.1. spring boot项目初始化
* [Spring Initializr.](https://start.spring.io/)快速生成项目框架
* spring-boot-starter-actuator 常用监控采集模块，可以自定义自己的健康检测器。
    * 其自身提供的原生端点有：
        * 应用配置类：获取应用程序中加载的应用配置、环境变量、自动化配置报告等与Spring Boot应用密切相关的配置类信息。
        * 度最指标类：获取应用程序运行过程中用于监控的度量指标， 比如内存信息、线程池信息、HTTP请求统计等。
        * 操作控制类：提供了对应用的关闭等操作类功能。
    * 本地开发访问原生端点出现权限问题，可以通过 **management.security.enabled=false** 进行关闭

# 2. Spring Cloud Eureka - 服务治理
## 2.1. 核心功能 
* 服务注册
    * 服务方向注册中心注册服务，告知服务名、地址、端口、协议。
* 服务发现
    * 客户端调用服务时不在直接配置服务端地址，而是通过注册中心获取服务清单，通过某种机制像提供需要服务的其中一台进行请求。
* 服务清单维护
    * 服务注册中心以心跳的方式去检测清单中的服务的可用性（服务提供者维护一个心跳来持续告诉Eureka服务自己正常），即服务续约，定时任务定时扫描超过失效时间的服务从服务清单中剔除。
    > eureka.instance.lease-renewal-interval-in-seconds 设置心跳间隔
    > eureka.instance.lease-expiration-duration-in-seconds 定义服务失效时间
    * 本地开发 **eureka.server.enable-self-preservation**设置为false，关闭自我保护机制，提高开发效率
## 2.2. 基本使用
### 2.2.1. Eureka服务中心创建
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

### 2.2.2. 服务注册
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

### 2.2.3. 服务消费
* 导入Eureka依赖,同服务注册
* 配置服务，配置内容类似服务注册
* springboot启动入口增加注解 **@EnableDiscoveryClient**
* 通过spring提供的RestTemplate来请求，在传统的请求方式上将hostname更换为应用名（**spring.application.name**定义的）即可,服务名大小写不敏感
* 在服务中心为集群，在本地进行负载均衡处理时需要引入ribbon或其他负载组件，在请求组件RestTemplate创建的方法上使用注解 **@LoadBalanced**

### 2.2.4. 总结
* 服务消费端和服务提供端相对eureka服务来讲都是客户端，并无区别，

# 3. Spring Cloud Ribbon - 客户端负载均衡
## 3.1. 基本使用方法
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

# 4. Spring Cloud Hystrix - 服务器容错保护
## 4.1. 基本使用方法
* 导入hystrix依赖
```
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-hystrix</artifactId>
</dependency>
```
* 启动类增加注解 **@EnableCircuitBreaker** 或 **@SpringCloudApplication**（该注解包含EnableCircuitBreaker注解）

* 在有服务调用的方法上添加注解 **@HystrixCommand(fallbackMethod = "xxx")**,fallbackMethod方法需要在同一个类中

## 4.2. [hystrix原理](https://github.com/Netflix/Hystrix/wiki)
* 命令模式

# 5. Spring Cloud Reign - 声明式服务调用
声明式服务调用与webservice生成本地客户端代码进行调用类似
## 5.1. 基本使用方法
* 导入reign依赖
```
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-feign</artifactId>
</dependency>
```
* 启动类中增加注解 **@EnableFeignClients**
* 编写调用第三方服务的接口类，分别在类上增加 **@FeignClient** 注解，方法上增加注解**@RequestMapping**。

    示例：
    ```
    @FeignClient("EUREKA-PROVIDER")  // 调用的服务名
    public interface HelloService {
        @RequestMapping("/spring-cloud-demo/eureka-provider/hello-world") //服务地址
        String hello();
    }
    ```

* 在其他类中注入定义的接口进行服务调用

## 5.2. 带参数的使用
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

## 5.3. 高级使用
使用regin进行声明式调用可以通过抽出服务端和客户端公用代码进行共享，避免类的重复编码。公用部分主要包括dto类，以及接口定义。通过将该部分单独打包上传私库方式实现。

### 5.3.1. 对于该公共部分的使用：
* 将公共部分打包上传maven仓库
* 在服务端和客户端分别引入
* 客户端使用时，接口定义继承jar包中的接口，接口注解**@FeignClient**即可
* 服务端使用时，controller实现接口即可。

### 5.3.2. 注意事项
* 这种方式使用不当会造成客户端不可用，开发时应注意开闭原则。

## 5.4. 说明
* regin的客户端负载使用的是ribbon
* regin引入了服务保护与容错的工具Hystrix，默认情况下，Spring Cloud Feign会为将所有Feign客户端的方法都封装到Hystrix命令中进行服务保护，可以通过参数进行禁用。

## 5.5. 重要配置
### 5.5.1. ribbon配置
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

### 5.5.2. hystrix配置

* 全局配置同Spring Cloud伈bbon的全局配置一样，直接使用它的默认配置前缀**hystrix.command.defaut**就可以进行设置

* 禁用配置
    * 全局禁用
        > feign.hystrix.enabled=false
    * 部分client禁用需要通过使用@Scope ("prototype")注解为指定的客户端配置Feign.Builder实例
* 指定命令配置、服务降级配置、日志配置及其他配置（如服务请求及返回压缩）

# 6. Spring Cloud Zuul - Api网

# 7. Spring Cloud Config - 分布式配置中心

# 8. Spring Cloud Bus - 消息总线