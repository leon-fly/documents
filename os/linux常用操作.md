# linux常用操作

## 一、系统信息查看

### 1. cpu信息查看

1.1 查看CPU个数

> cat /proc/cpuinfo | grep "physical id" | uniq | wc -l

1.2 查看CPU核数

> cat /proc/cpuinfo | grep "cpu cores" | uniq

1.3 查看CPU型号
> cat /proc/cpuinfo | grep 'model name' |uniq

### 2. 磁盘空间查看

> df -sh

### 3. 系统使用情况查看

> free
查看瞬间运行存储空间

> top
查看实时运行存储