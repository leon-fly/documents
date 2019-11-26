# mysql root密码重置
👉 [参考资料](https://www.techrepublic.com/article/how-to-set-change-and-recover-a-mysql-root-password/)

---
* mysql版本5.7  操作系统ubantu
---
* Recover your MySQL password
What if you've forgotten your MySQL root user password? This could be quite the predicament ... had the developers not thought of that eventuality. In order to recover the password, you simply have to follow these steps:

1. Stop the MySQL server process with the command sudo service mysql stop
2. Start the MySQL server with the command sudo mysqld_safe --skip-grant-tables --skip-networking &
3. Connect to the MySQL server as the root user with the command mysql -u root
At this point, you need to issue the following MySQL commands to reset the root password:

    ```
    mysql> use mysql;
    ​mysql> update user set authentication_string=password('NEWPASSWORD') where user='root';
    ​mysql> flush privileges;
    ​mysql> quit
    ```
Where NEWPASSWORD is the new password to be used.

Restart the MySQL daemon with the command sudo service mysql restart. You should now be able to log into MySQL with the new password.

And that's it. You can now set, reset, and recover your MySQL password.


这个过程中可能碰到的问题：
1. 由于文件权限导致安全模式启动服务失败，此情况下需要关注写文件用户是哪个，并对要操作的路径进行用户属主调整