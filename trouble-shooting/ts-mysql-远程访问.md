# mysql远程访问问题

## 💣 mysql安装之后无法远程访问

现象：
运行 netstat -ltnp|grep mysqld 结果如下：

```
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 127.0.0.1:3306          0.0.0.0:*               LISTEN      6589/mysqld
```
以上结果显示mysql仅对本地地址有监听

## 👉 解决方案
* 修改mysql配置，关注两个参数。
    * bind-address
        mysql该默认配置为bind-address = 127.0.0.1，需要将其注释或者设置为bind-address = 0.0.0.0
    * skip-networking
        该参数为关闭mysql的TCP/IP连接方式，需要注释掉
* 修改配之后重启服务并检查监听情况

    * service mysql restart

    * netstat -ltnp
        ```
        Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
        tcp        0      0 0.0.0.0:3306            0.0.0.0:*               LISTEN      30376/mysqld
        ```

* 注意：mysql掉配置文件可能有多个，若要最终生效，要注意其覆盖顺序。


## 💣 远程还是无法访问？
现象
```
Trying 123.56.119.238...
telnet: connect to address 123.56.119.238: Connection refused
telnet: Unable to connect to remote host
```
👉 以上问题解决之后有可能远程还是不能登录，那么需要看下防火墙策略该端口是否打开，如果是阿里云服务器还需要在云管理平台调整其安全策略。

## 💣  远程还是无法访问？
现象
```
Host '192.168.0.1' is not allowed to connect to this MySQL serverConnection closed by foreign host.
```

👉 解决方案
* 登陆
    > mysql -u root -p
* 授权
    > grant all privileges on *.* to 'root'@'192.168.0.1' identified by '123456';

    若要授权任意ip:grant all privileges on *.* to 'root'@'%' identified by '123456';
* 刷新
    > flush privileges;
[用户访问权限参考](https://blog.csdn.net/dongdong9223/article/details/77854690)