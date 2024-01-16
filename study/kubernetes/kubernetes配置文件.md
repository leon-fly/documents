# kubernetes配置文件overview

## 关于kubernetes配置文件

* 作为容器应用开发者，除了开发应用本身外，最核心的两件事
  * 制作容器镜像
  * 编写kubernetes配置文件。
* kubernetes不建议直接使用命令方式运行，而是将所有定义，参数，配置等集中化到YMAL（也支持JSON）配置文件中，然后用这样一句指令把它运行起来 `$ kubectl create -f 我的配置文件` , 这样做可以带来如下好处：
  * 知道容器运行了一些什么内容
  * 版本历史支持，可以比较容易的回滚。

## 示例说明

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 2
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.8
        ports:
        - containerPort: 80
        volumeMounts:
        - mountPath: "/usr/share/nginx/html"
          name: nginx-vol
      volumes:
      - name: nginx-vol
        emptyDir: {}
```

以上为通过kubernetes部署nginx的一个(deployment)配置文件，像这样的一个 YAML 文件，对应到 Kubernetes 中，就是一个 API Object（API 对象）。当你为这个对象的各个字段填好值并提交给 Kubernetes 之后，Kubernetes 就会负责创建出这些对象所定义的容器或者其他类型的 API 资源。配置文件结果大致包含：

```
apiVersion: group/version
kind: xxx
metadata:
	name: xxx
	label: xxx
	annotations: xxx
spepc:
```

* apiVersion
  * kubernetes通过control plane提供的api进行管理各个对象(deployment / pods 等等) ， 这个apiVersion即指定操作对象时使用的api及对应版本
  * 一般格式为api group/version，如示例中的apps/v1 （开始的版本中格式并没有group）
  * 详细版本列表参考 [官方api version清单](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.29/#api-groups)
* kind
  * kind为API Object类型， 如deployment / pod / ReplicaSet 等
  * 详细kind列表参考 [官方 Workloads API overview](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.29/#api-overview)
* metadata 
  * 元数据，这个节点包含了关于该Object(资源)必要的信息，便于在集群中识别及组织资源
  * 关键元数据
    * name -> object 名称
    * labels -> object标签，一般用于资源分类
    * annotations -> 提供Object额外的元数据信息，一般的会用于做文档备注/定制化参数等
* spec
  * spec描述了资源所需状态，概述了资源的配置详细信息和行为。该部分的结构和内容
  * 几类object中spec内容
    * Deployment
      * replicas个数
      * 容器信息如镜像(image)，端口，环境变量
    * Service
      * 网络规则如暴露端口，服务类型，目标端口等
    * Pod
      * 容器信息如镜像(image)，端口，环境变量
    * ConfigMap
      * 为环境变量或挂载卷提供给容器需要的键值对或配置文件
