

# kubernetes基于ubuntu集群初始化 

## 1. 环境

使用环境为腾讯云，具体硬件信息如下：

```
lighthouse@VM-4-11-ubuntu:~$ uname -a
Linux VM-4-11-ubuntu 5.4.0-153-generic #170-Ubuntu SMP Fri Jun 16 13:43:31 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux

lighthouse@VM-4-11-ubuntu:~$ cat /proc/version
Linux version 5.4.0-153-generic (buildd@bos03-amd64-008) (gcc version 9.4.0 (Ubuntu 9.4.0-1ubuntu1~20.04.1)) #170-Ubuntu SMP Fri Jun 16 13:43:31 UTC 2023

lighthouse@VM-4-11-ubuntu:~$ cat /proc/cpuinfo | grep "cpu cores" | uniq
cpu cores       : 2

lighthouse@VM-4-11-ubuntu:~$ free -h
              total        used        free      shared  buff/cache   available
Mem:          3.3Gi       438Mi       174Mi       2.0Mi       2.7Gi       2.6Gi
Swap:            0B          0B          0B
```

## 2. 安装kubeadm

[kubeadm](https://github.com/kubernetes/kubeadm)是一个2017年发起的一个kubernetes集群部署管理工具， 可以便捷的对进行集群管理。

> sudo apt-get install kubeadm

```
lighthouse@VM-4-11-ubuntu:~$ kubeadm version
kubeadm version: &version.Info{Major:"1", Minor:"28", GitVersion:"v1.28.2", GitCommit:"89a4ea3e1e4ddd7f7572286090359983e0387b2f", GitTreeState:"clean", BuildDate:"2023-09-13T09:34:32Z", GoVersion:"go1.20.8", Compiler:"gc", Platform:"linux/amd64"}
```

## 3. 安装docker

> apt-get install -y docker.io

## 4. 安装cri-dockerd

获取对应系统的cri-dockered, 当前系统使用的是如下版本

> wget https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.9/cri-dockerd_0.3.9.3-0.ubuntu-focal_amd64.deb

安装

> sudo dpkg -i cri-dockerd_0.3.9.3-0.ubuntu-focal_amd64.deb

修改配置文件`/lib/systemd/system/cri-docker.service` 增加如下配置

```
ExecStart=/usr/bin/cri-dockerd --network-plugin=cni  --pod-infra-container-image=registry.aliyuncs.com/google_containers/pause:3.9
```

启动

> systemctl start cri-docker

查看启动情况

> systemctl status cri-docker.service

```
lighthouse@VM-4-11-ubuntu:/etc$ sudo systemctl status cri-docker.service
● cri-docker.service - CRI Interface for Docker Application Container Engine
     Loaded: loaded (/lib/systemd/system/cri-docker.service; enabled; vendor preset: enabled)
     Active: active (running) since Thu 2024-02-08 00:35:04 CST; 4s ago
TriggeredBy: ● cri-docker.socket
       Docs: https://docs.mirantis.com
   Main PID: 2025478 (cri-dockerd)
      Tasks: 8
     Memory: 31.4M
     CGroup: /system.slice/cri-docker.service
             └─2025478 /usr/bin/cri-dockerd --network-plugin=cni --pod-infra-container-image=registry.aliyuncs.com/google_c>

Feb 08 00:35:04 VM-4-11-ubuntu cri-dockerd[2025478]: time="2024-02-08T00:35:04+08:00" level=info msg="Connecting to docker >
Feb 08 00:35:04 VM-4-11-ubuntu cri-dockerd[2025478]: time="2024-02-08T00:35:04+08:00" level=info msg="Start docker client w>
Feb 08 00:35:04 VM-4-11-ubuntu cri-dockerd[2025478]: time="2024-02-08T00:35:04+08:00" level=info msg="Hairpin mode is set t>
Feb 08 00:35:04 VM-4-11-ubuntu cri-dockerd[2025478]: time="2024-02-08T00:35:04+08:00" level=info msg="Loaded network plugin>
Feb 08 00:35:04 VM-4-11-ubuntu cri-dockerd[2025478]: time="2024-02-08T00:35:04+08:00" level=info msg="Docker cri networking>
Feb 08 00:35:04 VM-4-11-ubuntu cri-dockerd[2025478]: time="2024-02-08T00:35:04+08:00" level=info msg="Setting cgroupDriver >
Feb 08 00:35:04 VM-4-11-ubuntu cri-dockerd[2025478]: time="2024-02-08T00:35:04+08:00" level=info msg="Docker cri received r>
Feb 08 00:35:04 VM-4-11-ubuntu cri-dockerd[2025478]: time="2024-02-08T00:35:04+08:00" level=info msg="Starting the GRPC bac>
Feb 08 00:35:04 VM-4-11-ubuntu cri-dockerd[2025478]: time="2024-02-08T00:35:04+08:00" level=info msg="Start cri-dockerd grp>
Feb 08 00:35:04 VM-4-11-ubuntu systemd[1]: Started CRI Interface for Docker Application Container Engine.
```

## 5. 初始化kubernetes集群

### Init cluster

#### 👉 执行init

**方式一（推荐）：**

将初始化参数集中化到配置文件，在启动时指定配置文件`kubeadm init --config kubeadm.yaml`便于维护管理，配置文件kubeadm.yaml 参考[官方kubeadm配置](https://kubernetes.io/zh-cn/docs/reference/config-api/kubeadm-config.v1beta3/)

**方式二（本文档实际执行）：**

> sudo kubeadm init --image-repository registry.cn-hangzhou.aliyuncs.com/google_containers --cri-socket unix:///var/run/cri-dockerd.sock --pod-network-cidr=10.244.0.0/16

```
lighthouse@VM-4-11-ubuntu:~/my-kubernate-config$ sudo kubeadm init --image-repository registry.cn-hangzhou.aliyuncs.com/google_containers --cri-socket unix:///var/run/cri-dockerd.sock --pod-network-cidr=10.244.0.0/16
I0208 01:36:47.117631 2043585 version.go:256] remote version is much newer: v1.29.1; falling back to: stable-1.28
[init] Using Kubernetes version: v1.28.6
[preflight] Running pre-flight checks
[preflight] Pulling images required for setting up a Kubernetes cluster
[preflight] This might take a minute or two, depending on the speed of your internet connection
[preflight] You can also perform this action in beforehand using 'kubeadm config images pull'
W0208 01:36:48.411217 2043585 checks.go:835] detected that the sandbox image "registry.aliyuncs.com/google_containers/pause:3.9" of the container runtime is inconsistent with that used by kubeadm. It is recommended that using "registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.9" as the CRI sandbox image.
[certs] Using certificateDir folder "/etc/kubernetes/pki"
[certs] Generating "ca" certificate and key
[certs] Generating "apiserver" certificate and key
[certs] apiserver serving cert is signed for DNS names [kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local vm-4-11-ubuntu] and IPs [10.96.0.1 10.0.4.11]
[certs] Generating "apiserver-kubelet-client" certificate and key
[certs] Generating "front-proxy-ca" certificate and key
[certs] Generating "front-proxy-client" certificate and key
[certs] Generating "etcd/ca" certificate and key
[certs] Generating "etcd/server" certificate and key
[certs] etcd/server serving cert is signed for DNS names [localhost vm-4-11-ubuntu] and IPs [10.0.4.11 127.0.0.1 ::1]
[certs] Generating "etcd/peer" certificate and key
[certs] etcd/peer serving cert is signed for DNS names [localhost vm-4-11-ubuntu] and IPs [10.0.4.11 127.0.0.1 ::1]
[certs] Generating "etcd/healthcheck-client" certificate and key
[certs] Generating "apiserver-etcd-client" certificate and key
[certs] Generating "sa" key and public key
[kubeconfig] Using kubeconfig folder "/etc/kubernetes"
[kubeconfig] Writing "admin.conf" kubeconfig file
[kubeconfig] Writing "kubelet.conf" kubeconfig file
[kubeconfig] Writing "controller-manager.conf" kubeconfig file
[kubeconfig] Writing "scheduler.conf" kubeconfig file
[etcd] Creating static Pod manifest for local etcd in "/etc/kubernetes/manifests"
[control-plane] Using manifest folder "/etc/kubernetes/manifests"
[control-plane] Creating static Pod manifest for "kube-apiserver"
[control-plane] Creating static Pod manifest for "kube-controller-manager"
[control-plane] Creating static Pod manifest for "kube-scheduler"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Starting the kubelet
[wait-control-plane] Waiting for the kubelet to boot up the control plane as static Pods from directory "/etc/kubernetes/manifests". This can take up to 4m0s
[apiclient] All control plane components are healthy after 6.502537 seconds
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config" in namespace kube-system with the configuration for the kubelets in the cluster
[upload-certs] Skipping phase. Please see --upload-certs
[mark-control-plane] Marking the node vm-4-11-ubuntu as control-plane by adding the labels: [node-role.kubernetes.io/control-plane node.kubernetes.io/exclude-from-external-load-balancers]
[mark-control-plane] Marking the node vm-4-11-ubuntu as control-plane by adding the taints [node-role.kubernetes.io/control-plane:NoSchedule]
[bootstrap-token] Using token: 9447k1.usqndnxye4mbaugw
[bootstrap-token] Configuring bootstrap tokens, cluster-info ConfigMap, RBAC Roles
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to get nodes
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstrap-token] Configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstrap-token] Configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[bootstrap-token] Creating the "cluster-info" ConfigMap in the "kube-public" namespace
[kubelet-finalize] Updating "/etc/kubernetes/kubelet.conf" to point to a rotatable kubelet client certificate and key
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 10.0.4.11:6443 --token 9447k1.usqndnxye4mbaugw \
        --discovery-token-ca-cert-hash sha256:b8f805dd4bc6c7064512a8331fc6b8cf64dd7a7479d3f0cd81b327c56431304f 
```

接下来需要按照日志提示后续几步操作

#### 👉 拷贝配置文件

>mkdir -p $HOME/.kube
>
>sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
>
>sudo chown $(id -u):$(id -g) $HOME/.kube/config

否则会出现如下问题：

```
lighthouse@VM-4-11-ubuntu:~$ kubectl get no -A
E0203 21:37:19.797023 1319741 memcache.go:265] couldn't get current server API group list: Get "http://localhost:8080/api?timeout=32s": dial tcp 127.0.0.1:8080: connect: connection refused
E0203 21:37:19.797382 1319741 memcache.go:265] couldn't get current server API group list: Get "http://localhost:8080/api?timeout=32s": dial tcp 127.0.0.1:8080: connect: connection refused
E0203 21:37:19.799397 1319741 memcache.go:265] couldn't get current server API group list: Get "http://localhost:8080/api?timeout=32s": dial tcp 127.0.0.1:8080: connect: connection refused
E0203 21:37:19.800736 1319741 memcache.go:265] couldn't get current server API group list: Get "http://localhost:8080/api?timeout=32s": dial tcp 127.0.0.1:8080: connect: connection refused
E0203 21:37:19.802018 1319741 memcache.go:265] couldn't get current server API group list: Get "http://localhost:8080/api?timeout=32s": dial tcp 127.0.0.1:8080: connect: connection refused
The connection to the server localhost:8080 was refused - did you specify the right host or port?
```

此时查看可能看到coredns状态时pending

```
lighthouse@VM-4-11-ubuntu:~$ kubectl get no -A
NAME             STATUS     ROLES           AGE     VERSION
vm-4-11-ubuntu   NotReady   control-plane   3h12m   v1.28.2

lighthouse@VM-4-11-ubuntu:~$ kubectl get pods --all-namespaces
NAMESPACE     NAME                                     READY   STATUS    RESTARTS   AGE
kube-system   coredns-6554b8b87f-52kvm                 0/1     Pending   0          3h6m
kube-system   coredns-6554b8b87f-k5fmr                 0/1     Pending   0          3h6m
kube-system   etcd-vm-4-11-ubuntu                      1/1     Running   0          3h6m
kube-system   kube-apiserver-vm-4-11-ubuntu            1/1     Running   0          3h6m
kube-system   kube-controller-manager-vm-4-11-ubuntu   1/1     Running   0          3h6m
kube-system   kube-proxy-s6q6m                         1/1     Running   0          3h6m
kube-system   kube-scheduler-vm-4-11-ubuntu            1/1     Running   0          3h6m
```

查一下日志发现网络配置没有初始化

```
sudo journalctl -f -u kubelet.service
-- Logs begin at Mon 2024-01-29 03:23:41 CST. --
Feb 03 22:07:02 VM-4-11-ubuntu kubelet[1275240]: E0203 22:07:02.115716 1275240 kubelet.go:2855] "Container runtime network not ready" networkReady="NetworkReady=false reason:NetworkPluginNotReady message:docker: network plugin is not ready: cni config uninitialized"
......
```

#### 👉 初始化网络插件

 [官方列出的网络插件清单](https://kubernetes.io/docs/concepts/cluster-administration/addons/)这里我们使用常用的其中一个[网络插件flannel](https://github.com/flannel-io/flannel#deploying-flannel-manually), 按照说明readme进行插件安装

```
lighthouse@VM-4-11-ubuntu:~$ kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml 
namespace/kube-flannel created
serviceaccount/flannel created
clusterrole.rbac.authorization.k8s.io/flannel created
clusterrolebinding.rbac.authorization.k8s.io/flannel created
configmap/kube-flannel-cfg created
daemonset.apps/kube-flannel-ds created
```

🔥当在初始化集群时如果没有指定参数`--pod-network-cidr=10.244.0.0/16` 时会出现如下问题：查看kube-flannel启动情况，发现flannel的发布状态是CrashLoopBackOff (重启几次之后变为是Error)

```
lighthouse@VM-4-11-ubuntu:~$ kubectl get pods --all-namespaces
NAMESPACE      NAME                                     READY   STATUS              RESTARTS      AGE
kube-flannel   kube-flannel-ds-q4knd                    0/1     CrashLoopBackOff    2 (15s ago)   39s
kube-system    coredns-6554b8b87f-52kvm                 0/1     ContainerCreating   0             4h8m
kube-system    coredns-6554b8b87f-k5fmr                 0/1     ContainerCreating   0             4h8m
kube-system    etcd-vm-4-11-ubuntu                      1/1     Running             0             4h8m
kube-system    kube-apiserver-vm-4-11-ubuntu            1/1     Running             0             4h8m
kube-system    kube-controller-manager-vm-4-11-ubuntu   1/1     Running             0             4h8m
kube-system    kube-proxy-s6q6m                         1/1     Running             0             4h8m
kube-system    kube-scheduler-vm-4-11-ubuntu            1/1     Running             0             4h8m
```

查看日志确定[flannel的发布状态是CrashLoopBackOff原因](https://www.cnblogs.com/360linux/p/12933594.html) : 节点下的pod cidr没有分配

```
lighthouse@VM-4-11-ubuntu:~$ kubectl logs -f --tail 200 -n kube-flannel kube-flannel-ds-q4knd
Defaulted container "kube-flannel" out of: kube-flannel, install-cni-plugin (init), install-cni (init)
I0204 03:23:24.086258       1 main.go:209] CLI flags config: {etcdEndpoints:http://127.0.0.1:4001,http://127.0.0.1:2379 etcdPrefix:/coreos.com/network etcdKeyfile: etcdCertfile: etcdCAFile: etcdUsername: etcdPassword: version:false kubeSubnetMgr:true kubeApiUrl: kubeAnnotationPrefix:flannel.alpha.coreos.com kubeConfigFile: iface:[] ifaceRegex:[] ipMasq:true ifaceCanReach: subnetFile:/run/flannel/subnet.env publicIP: publicIPv6: subnetLeaseRenewMargin:60 healthzIP:0.0.0.0 healthzPort:0 iptablesResyncSeconds:5 iptablesForwardRules:true netConfPath:/etc/kube-flannel/net-conf.json setNodeNetworkUnavailable:true}
W0204 03:23:24.086339       1 client_config.go:617] Neither --kubeconfig nor --master was specified.  Using the inClusterConfig.  This might not work.
I0204 03:23:24.099440       1 kube.go:139] Waiting 10m0s for node controller to sync
I0204 03:23:24.099491       1 kube.go:461] Starting kube subnet manager
I0204 03:23:25.099595       1 kube.go:146] Node controller sync successful
I0204 03:23:25.099622       1 main.go:229] Created subnet manager: Kubernetes Subnet Manager - vm-4-11-ubuntu
I0204 03:23:25.099627       1 main.go:232] Installing signal handlers
I0204 03:23:25.099750       1 main.go:540] Found network config - Backend type: vxlan
I0204 03:23:25.099777       1 match.go:210] Determining IP address of default interface
I0204 03:23:25.100059       1 match.go:263] Using interface with name eth0 and address 10.0.4.11
I0204 03:23:25.100084       1 match.go:285] Defaulting external address to interface address (10.0.4.11)
I0204 03:23:25.100138       1 vxlan.go:141] VXLAN config: VNI=1 Port=0 GBP=false Learning=false DirectRouting=false
I0204 03:23:25.102693       1 kube.go:621] List of node(vm-4-11-ubuntu) annotations: map[string]string{"kubeadm.alpha.kubernetes.io/cri-socket":"unix:///var/run/cri-dockerd.sock", "node.alpha.kubernetes.io/ttl":"0", "volumes.kubernetes.io/controller-managed-attach-detach":"true"}
E0204 03:23:25.102983       1 main.go:332] Error registering network: failed to acquire lease: node "vm-4-11-ubuntu" pod cidr not assigned
W0204 03:23:25.103079       1 reflector.go:347] pkg/subnet/kube/kube.go:462: watch of *v1.Node ended with: an error on the server ("unable to decode an event from the watch stream: context canceled") has prevented the request from succeeding
I0204 03:23:25.103099       1 main.go:520] Stopping shutdownHandler...
```

对应解决方案

* pod子网网段修改

  > kubectl edit cm kubeadm-config -n kube-system

​       在networking下添加配置 podSubnet: 10.244.0.0/16

* 修改静态pod kube-controller-manager配置

  > vim /etc/kubernetes/manifests/kube-controller-manager.yaml 

  添加启动参数

  ```
  - --allocate-node-cidrs=true 
  - --cluster-cidr=10.244.0.0/16
  ```

* 修改完成之后重建启动flannel pod

  ```
  kubectl delete -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
  kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
  ```

这些完成之后再看各个pods情况，flannel和coredns的pod都处于running状态。

### 集群节点加入

使用`kubeadm join`加入worker节点，指令参数可以从启动日志获取

> kubeadm join 10.0.4.11:6443 --token 9447k1.usqndnxye4mbaugw \
>         --discovery-token-ca-cert-hash sha256:b8f805dd4bc6c7064512a8331fc6b8cf64dd7a7479d3f0cd81b327c56431304f 

查看节点加入情况

> kubeadm get no -A

### [dashboard 部署](https://kubernetes.io/zh-cn/docs/tasks/access-application-cluster/web-ui-dashboard/)

#### 👉 部署

> kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml

单机环境下节点上设置了污点导致调度失败(Pending状态), 失败错误信息可以通过污点容忍配置解决。

```
lighthouse@VM-4-11-ubuntu:~$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
serviceaccount/kubernetes-dashboard created
service/kubernetes-dashboard created
secret/kubernetes-dashboard-certs created
secret/kubernetes-dashboard-csrf created
secret/kubernetes-dashboard-key-holder created
configmap/kubernetes-dashboard-settings created
role.rbac.authorization.k8s.io/kubernetes-dashboard created
clusterrole.rbac.authorization.k8s.io/kubernetes-dashboard created
rolebinding.rbac.authorization.k8s.io/kubernetes-dashboard created
clusterrolebinding.rbac.authorization.k8s.io/kubernetes-dashboard created
deployment.apps/kubernetes-dashboard created
service/dashboard-metrics-scraper created
deployment.apps/dashboard-metrics-scraper created

lighthouse@VM-4-11-ubuntu:~$ kubectl get pods --all-namespaces
NAMESPACE              NAME                                         READY   STATUS    RESTARTS   AGE
kube-flannel           kube-flannel-ds-hcj6v                        1/1     Running   0          66m
kube-system            coredns-6554b8b87f-52kvm                     1/1     Running   0          18h
kube-system            coredns-6554b8b87f-k5fmr                     1/1     Running   0          18h
kube-system            etcd-vm-4-11-ubuntu                          1/1     Running   0          18h
kube-system            kube-apiserver-vm-4-11-ubuntu                1/1     Running   0          18h
kube-system            kube-controller-manager-vm-4-11-ubuntu       1/1     Running   0          68m
kube-system            kube-proxy-s6q6m                             1/1     Running   0          18h
kube-system            kube-scheduler-vm-4-11-ubuntu                1/1     Running   0          18h
kubernetes-dashboard   dashboard-metrics-scraper-5657497c4c-bzp6g   0/1     Pending   0          39s
kubernetes-dashboard   kubernetes-dashboard-78f87ddfc-htfhs         0/1     Pending   0          39s
```

pod调度情况查看

```
lighthouse@VM-4-11-ubuntu:~$ kubectl describe pod dashboard-metrics-scraper-5657497c4c-bzp6g -n kubernetes-dashboardName:             dashboard-metrics-scraper-5657497c4c-bzp6g
Namespace:        kubernetes-dashboard
Priority:         0
Service Account:  kubernetes-dashboard
Node:             <none>
Labels:           k8s-app=dashboard-metrics-scraper
                  pod-template-hash=5657497c4c
Annotations:      <none>
Status:           Pending
SeccompProfile:   RuntimeDefault
IP:               
IPs:              <none>
Controlled By:    ReplicaSet/dashboard-metrics-scraper-5657497c4c
Containers:
  dashboard-metrics-scraper:
    Image:        kubernetesui/metrics-scraper:v1.0.8
    Port:         8000/TCP
    Host Port:    0/TCP
    Liveness:     http-get http://:8000/ delay=30s timeout=30s period=10s #success=1 #failure=3
    Environment:  <none>
    Mounts:
      /tmp from tmp-volume (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-l7bt9 (ro)
Conditions:
  Type           Status
  PodScheduled   False 
Volumes:
  tmp-volume:
    Type:       EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:     
    SizeLimit:  <unset>
  kube-api-access-l7bt9:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              kubernetes.io/os=linux
Tolerations:                 node-role.kubernetes.io/master:NoSchedule
                             node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type     Reason            Age    From               Message
  ----     ------            ----   ----               -------
  Warning  FailedScheduling  2m58s  default-scheduler  0/1 nodes are available: 1 node(s) had untolerated taint {node-role.kubernetes.io/control-plane: }. preemption: 0/1 nodes are available: 1 Preemption is not helpful for scheduling..
```

查看node上设置的污点信息（参考[污点与容忍](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/)）：

```
lighthouse@VM-4-11-ubuntu:~$ kubectl describe node vm-4-11-ubuntu|grep Taints
Taints:             node-role.kubernetes.io/control-plane:NoSchedule
```

**解决方案：**

**方案一：**移除节点上的污点`kubectl taint nodes <hostname> <traints>-` , 此处执行：

```
lighthouse@VM-4-11-ubuntu:~$ kubectl taint nodes vm-4-11-ubuntu node-role.kubernetes.io/control-plane:NoSchedule-
node/vm-4-11-ubuntu untainted
```



**方案二：**将dashboard的部署文件中两个pod配置污点容忍(spec.template.spec.tolerations节点下增加如下配置，共两个Pod两处)：

```
- key: node-role.kubernetes.io/control-plane
          effect: NoSchedule
```

apply使修改生效

```
# 下载文件修改保存到本地
lighthouse@VM-4-11-ubuntu:~$  kubectl apply -f ~/k8s-offline-configuration/my-dashboard-deployment.yamlnamespace/kubernetes-dashboard unchanged
serviceaccount/kubernetes-dashboard unchanged
service/kubernetes-dashboard unchanged
secret/kubernetes-dashboard-certs unchanged
secret/kubernetes-dashboard-csrf unchanged
secret/kubernetes-dashboard-key-holder unchanged
configmap/kubernetes-dashboard-settings unchanged
role.rbac.authorization.k8s.io/kubernetes-dashboard unchanged
clusterrole.rbac.authorization.k8s.io/kubernetes-dashboard unchanged
rolebinding.rbac.authorization.k8s.io/kubernetes-dashboard unchanged
clusterrolebinding.rbac.authorization.k8s.io/kubernetes-dashboard unchanged
deployment.apps/kubernetes-dashboard configured
service/dashboard-metrics-scraper unchanged
deployment.apps/dashboard-metrics-scraper configured
```

再查看pods情况, 已处于running状态

```
lighthouse@VM-4-11-ubuntu:~$ kubectl get pods --all-namespaces
NAMESPACE              NAME                                         READY   STATUS    RESTARTS   AGE
kube-flannel           kube-flannel-ds-hcj6v                        1/1     Running   0          81m
kube-system            coredns-6554b8b87f-52kvm                     1/1     Running   0          18h
kube-system            coredns-6554b8b87f-k5fmr                     1/1     Running   0          18h
kube-system            etcd-vm-4-11-ubuntu                          1/1     Running   0          18h
kube-system            kube-apiserver-vm-4-11-ubuntu                1/1     Running   0          18h
kube-system            kube-controller-manager-vm-4-11-ubuntu       1/1     Running   0          83m
kube-system            kube-proxy-s6q6m                             1/1     Running   0          18h
kube-system            kube-scheduler-vm-4-11-ubuntu                1/1     Running   0          18h
kubernetes-dashboard   dashboard-metrics-scraper-5bd9b4ff89-qtx48   1/1     Running   0          115s
kubernetes-dashboard   kubernetes-dashboard-658b94579f-qdd7v        1/1     Running   0          115s
```

#### 👉  代理端口使该pod的服务能被外部访问

> kubectl proxy --address='0.0.0.0'  --accept-hosts='^*$' --port=8001

```
lighthouse@VM-4-11-ubuntu:~$ kubectl proxy --address='0.0.0.0'  --accept-hosts='^*$' --port=8001
Starting to serve on [::]:8001
```

以上方式可以接受所有主机请求，官方给出的命令`kubuctl proxy` 不带任何参数只能在宿主机上使用。要能使外部能够使用还需要打开防火墙。本地修改iptables:

> sudo iptables -I INPUT -p tcp --dport 8001 -j ACCEPT
>
> sudo iptables-save

当然如果是从外网访问还需要配置对应云平台的网络策略开放相应端口。

#### 👉 本地ssh转发

dashboard仅仅允许localhost / 127.0.0.1通过http访问，如果是其他地址需要走https协议，所以我们需要在本地通过ssh转发到宿主机

> ssh -L localhost:8001:localhost:8001 -NT lighthouse@101.34.243.187
> lighthouse@101.34.243.187's password:

然后本地直接通过localhost访问 http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/ 

另可参考[官方提供的其他访问dashboard的方式](https://github.com/kubernetes/dashboard/blob/master/docs/user/accessing-dashboard/README.md#login-not-available)

#### 👉  [创建dashboard登录用户](https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md)

* 编辑`my-dashboard-user.yaml` 文件内容

  ```
  apiVersion: v1
  kind: ServiceAccount
  metadata:
    name: admin-user
    namespace: kubernetes-dashboard
  
  ---
  
  apiVersion: rbac.authorization.k8s.io/v1
  kind: ClusterRoleBinding
  metadata:
    name: admin-user
  roleRef:
    apiGroup: rbac.authorization.k8s.io
    kind: ClusterRole
    name: cluster-admin
  subjects:
  - kind: ServiceAccount
    name: admin-user
    namespace: kubernetes-dashboard
  
  --- 
  apiVersion: v1
  kind: Secret
  metadata:
    name: admin-user
    namespace: kubernetes-dashboard
    annotations:
      kubernetes.io/service-account.name: "admin-user"   
  type: kubernetes.io/service-account-token  
  ```

  该文件定义了几个事情：

  1. 创建一个admin-user账号
  2. 给该账号绑定一个角色admin-user
  3. 为用户admin-user创建一个<font color=red>long-lived token</font> （如果只需要一个短期token，这部分定义可以不用）

* 通过api进行资源创建

  ```
  lighthouse@VM-4-11-ubuntu:~$ kubectl apply -f ~/k8s-offline-configuration/my-dashboard-user.yaml 
  serviceaccount/admin-user created
  clusterrolebinding.rbac.authorization.k8s.io/admin-user created
  secret/admin-user created
  ```

* 获取long-live token

  > kubectl get secret admin-user -n kubernetes-dashboard -o jsonpath={".data.token"} | base64 -d

  🔥 避坑： 以上为官方提供的命令行，运行完之后展示内容会与下一个命令起始连到一块，拷贝token的时候注意拷贝完整，否则会得到401

* 短期token获取(短期token的获取不依赖于配置文件Secret的创建)

  > kubectl -n kubernetes-dashboard create token admin-user



## 6. 集群初始化过程中的其他常见问题

### <font color=red>常见问题1 ： 集群初始化过程中镜像拉取失败</font>

```
lighthouse@VM-4-11-ubuntu:~$ sudo kubeadm init
[init] Using Kubernetes version: v1.28.4
[preflight] Running pre-flight checks
[preflight] Pulling images required for setting up a Kubernetes cluster
[preflight] This might take a minute or two, depending on the speed of your internet connection
[preflight] You can also perform this action in beforehand using 'kubeadm config images pull'
W1206 16:25:29.487834 3261384 checks.go:835] detected that the sandbox image "registry.k8s.io/pause:3.8" of the container runtime is inconsistent with that used by kubeadm. It is recommended that using "registry.k8s.io/pause:3.9" as the CRI sandbox image.
error execution phase preflight: [preflight] Some fatal errors occurred:
        [ERROR ImagePull]: failed to pull image registry.k8s.io/kube-apiserver:v1.28.4: output: E1206 16:17:51.493681 3267795 remote_image.go:171] "PullImage from image service failed" err="rpc error: code = DeadlineExceeded desc = failed to pull and unpack image \"registry.k8s.io/kube-apiserver:v1.28.4\": failed to resolve reference \"registry.k8s.io/kube-apiserver:v1.28.4\": failed to do request: Head \"https://us-west2-docker.pkg.dev/v2/k8s-artifacts-prod/images/kube-apiserver/manifests/v1.28.4\": dial tcp 108.177.125.82:443: i/o timeout" image="registry.k8s.io/kube-apiserver:v1.28.4"
time="2023-12-06T16:17:51+08:00" level=fatal msg="pulling image: rpc error: code = DeadlineExceeded desc = failed to pull and unpack image \"registry.k8s.io/kube-apiserver:v1.28.4\": failed to resolve reference \"registry.k8s.io/kube-apiserver:v1.28.4\": failed to do request: Head \"https://us-west2-docker.pkg.dev/v2/k8s-artifacts-prod/images/kube-apiserver/manifests/v1.28.4\": dial tcp 108.177.125.82:443: i/o timeout"
, error: exit status 1
        [ERROR ImagePull]: failed to pull image registry.k8s.io/kube-controller-manager:v1.28.4: output: E1206 16:20:24.253612 3275462 remote_image.go:171] "PullImage from image service failed" err="rpc error: code = DeadlineExceeded desc = failed to pull and unpack image \"registry.k8s.io/kube-controller-manager:v1.28.4\": failed to resolve reference \"registry.k8s.io/kube-controller-manager:v1.28.4\": failed to do request: Head \"https://us-west2-docker.pkg.dev/v2/k8s-artifacts-prod/images/kube-controller-manager/manifests/v1.28.4\": dial tcp 142.251.170.82:443: i/o timeout" image="registry.k8s.io/kube-controller-manager:v1.28.4"
```

原因：kubeadm init 命令默认使用的[docker](https://cloud.tencent.com/product/tke?from_column=20065&from=20065)[镜像仓库](https://cloud.tencent.com/product/tcr?from_column=20065&from=20065)为k8s.gcr.io，国内无法直接访问，

👉 解决方案：更换为国内可以访问的镜像仓。

**再次尝试拉取镜像：**

> sudo kubeadm config images pull --image-repository registry.cn-hangzhou.aliyuncs.com/google_containers

```
lighthouse@VM-4-11-ubuntu:~$ sudo kubeadm config images pull --image-repository registry.cn-hangzhou.aliyuncs.com/google_containers
[config/images] Pulled registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver:v1.28.4
[config/images] Pulled registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager:v1.28.4
[config/images] Pulled registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler:v1.28.4
[config/images] Pulled registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:v1.28.4
[config/images] Pulled registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.9
[config/images] Pulled registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:3.5.9-0
[config/images] Pulled registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:v1.10.1
```

**初始化时增加镜像仓库配置指向阿里云**

> sudo kubeadm init --image-repository registry.cn-hangzhou.aliyuncs.com/google_containers --cri-socket unix:///var/run/cri-dockerd.sock --v=5 

### <font color=red>常见问题2 ： 启动control plane 超时</font> 

```
[kubelet-start] Starting the kubelet
[wait-control-plane] Waiting for the kubelet to boot up the control plane as static Pods from directory "/etc/kubernetes/manifests". This can take up to 4m0s
[kubelet-check] Initial timeout of 40s passed.

Unfortunately, an error has occurred:
        timed out waiting for the condition

This error is likely caused by:
        - The kubelet is not running
        - The kubelet is unhealthy due to a misconfiguration of the node in some way (required cgroups disabled)

If you are on a systemd-powered system, you can try to troubleshoot the error with the following commands:
        - 'systemctl status kubelet'
        - 'journalctl -xeu kubelet'

Additionally, a control plane component may have crashed or exited when started by the container runtime.
To troubleshoot, list all containers using your preferred container runtimes CLI.
Here is one example how you may list all running Kubernetes containers by using crictl:
        - 'crictl --runtime-endpoint unix:///var/run/containerd/containerd.sock ps -a | grep kube | grep -v pause'
        Once you have found the failing container, you can inspect its logs with:
        - 'crictl --runtime-endpoint unix:///var/run/containerd/containerd.sock logs CONTAINERID'
error execution phase wait-control-plane: couldn't initialize a Kubernetes cluster
To see the stack trace of this error execute with --v=5 or higher
```

根据日志提示进行分析，在个人进行初始化集群时通过安装docker的CRI进行解决。

## 7. 集群重置

在测试过成可能需要多次尝试，需要用到`kubeadm reset `指令进行集群重置。存在多个容器时要通过 --cri-socket指定容器，如`sudo kubeadm reset --cri-socket unix:///var/run/cri-dockerd.sock`

关联文件清理/初始化

> sudo rm -rf /etc/cni/net.d

> sudo rm $HOME/.kube/config

