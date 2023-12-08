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

* [autossh让你快速登录远程服务](https://github.com/FeeiCN/autossh)

* [autojump快速根据关键字进入目录](https://github.com/wting/autojump)

* [shuttle - 定义你的mac快捷菜单/操作](https://github.com/fitztrev/shuttle)

* [多设备键鼠共享软件barrier](https://oreo.life/share-mouse-and-keyboard-with-barrier/)

  * 该软件是基于设备使用统一网络进行通讯，所以如果网络不太好就不用考虑了。
  * 安装之后可能因为各种原因无法使用
    * 设备名称各设备之间不一致，在菜单栏barrier->change settings->screen name设置一致即可
    * SSL加载失败，只需要在setting中将Enable SSL取消勾选即可。

  [barrier 软件库](https://github.com/debauchee/barrier/releases)

* [alfred - 一个关键字打开你的应用/文件/书签 ...](https://www.alfredapp.com/)

* [utools - 与alfred同类工具，支持插件](https://u.tools/)

* Iterm终端网络请求使用代理设置，在～/.zshrc文件中增加如下配置(具体ip端口视个人使用的VPN代理短裤而定)

  ```
  alias setproxy='export http_proxy=http://127.0.0.1:33210 https_proxy=http://127.0.0.1:33210'
  alias disproxy='unset http_proxy https_proxy'
  ```

  之后需要在iterm中使用代理时执行命令setproxy设置启用代理（VPN需要在打开启用状态），不需要使用时执行disproxy关闭代理。
