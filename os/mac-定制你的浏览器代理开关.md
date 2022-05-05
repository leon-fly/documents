---
date: "2022-05-02"
draft: false
lastmod: "2022-05-02"
publishdate: "2022-05-02"
tags:
- os
- mac
title: 定制你的浏览器代理开关
---

## 定制你的Mac 浏览器代理开关

通过【启停代理脚本+shuttle】定制你的we b代理快捷启停用

* 安装shuttle [[shuttle 工具下载及配置说明](https://github.com/fitztrev/shuttle)]

* 准备脚本如下：

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

* shuttle配置（cmd参数需要调整shell脚本路径）

```
{
  "_comments": [
    "Valid terminals include: 'Terminal.app' or 'iTerm'",
    "In the editor value change 'default' to 'nano', 'vi', or another terminal based editor.",
    "Hosts will also be read from your ~/.ssh/config or /etc/ssh_config file, if available",
    "For more information on how to configure, please see http://fitztrev.github.io/shuttle/"
  ],
  "editor": "default",
  "launch_at_login": true,
  "terminal": "iTerm.app",
  "iTerm_version": "nightly",
  "default_theme": "Homebrew",
  "open_in": "new",
  "show_ssh_config_hosts": false,
  "ssh_config_ignore_hosts": [  ],
  "ssh_config_ignore_keywords": [  ],
  "hosts": [
    {
      "Proxy switch" : [
        {
          "cmd": "sh /Users/leonwang/proxy-switch.sh OFF; sleep 1; exit",
          "name": "OFF"
        },
        {
          "cmd": "sh /Users/leonwang/proxy-switch.sh ON; sleep 1; exit",
          "name": "ON"
        }
      ]
    }
  ]
}
```

[参考:如何优雅地一键实现macOS网络代理切换](https://zhuanlan.zhihu.com/p/23910924)