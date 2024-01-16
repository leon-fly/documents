# minikube集群使用

启动多个nodes

> minikube start --nodes 2 -p multinode-demo

获取nodes信息

> kubectl get nodes

获取nodes详细信息

> minikube status -p multinode-demo

多节点集群模式下启动dashboard. <font color=red>加参数 '-p 集群名称' 指定特定集群，这是minikube的参数  </font>

> minikube dashboard - p multinode-demo

停止集群

> minikube stop -p multinode-demo

