---
date: "2020-08-23"
draft: false
lastmod: "2020-08-23"
publishdate: "2020-08-23"
tags:
- os
- mac
title: mac系统初始化相关
---

# mac系统初始化 - 开发级



* [华丽丽的终端配置参考](https://zhuanlan.zhihu.com/p/37195261)

  避坑：安装时可能一直链接不到服务器问题，有的需要vpn，有的需要配置host（dns污染问题，可以使用switchhosts工具）

* [autossh让你快速登录远程服务](https://xiezuan.github.io/2017/03/22/mac%20%E4%B8%8Bssh%20%E8%87%AA%E5%8A%A8%E7%99%BB%E5%BD%95%E4%B8%8E%E8%BF%9E%E6%8E%A5%E4%BF%9D%E6%8C%81%E5%B7%A5%E5%85%B7%20autossh/)

* [autojump快速根据关键字进入目录](https://github.com/wting/autojump)

* 代理快捷启停用

  启停代理脚本+shuttle.脚本如下：
  
  ```
  #!/bin/bash
  flag='ON'
  if [ $# -gt 0 ]
      then
         flag=$1
  fi
  
  echo '------- flag:'$flag
  
  if [ $flag == 'ON' ]
      then
          echo '开启代理 >>>>>'
          sudo networksetup -setwebproxy "Wi-Fi" 127.0.0.1 33210
          sudo networksetup -setsecurewebproxy "Wi-Fi" 127.0.0.1 33210
          echo '开启成功！'
      else
          echo '关闭代理 <<<<<'
          sudo networksetup -setwebproxystate "Wi-Fi" off
          sudo networksetup -setsecurewebproxystate "Wi-Fi" off
          echo '关闭成功!'
  fi
  ```
  
  **如果不喜欢每次输入sudo密码可以通过修改sudoer配置取消（操作如下，这种方式不太安全，需谨慎使用）或者其他方式**
  
  ```
  # 1
  sudo visudo 或者 sudo vi /etc/sudoers
  
  # 2
  将%admin ALL=(ALL) ALL
  替换为 %admin ALL=(ALL) NOPASSWD: ALL
  
  ```
  
  
  
  [参考:如何优雅地一键实现macOS网络代理切换](https://zhuanlan.zhihu.com/p/23910924)
  
  [shuttle 工具下载及配置说明](https://github.com/fitztrev/shuttle)
  
  

