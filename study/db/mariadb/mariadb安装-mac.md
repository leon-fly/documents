---
date: "2022-07-10"
draft: false
lastmod: "2022-07-10"
publishdate: "2022-07-10"
tags:
- db
title: mariadb安装-Mac
---



### 安装

OS 版本 ：macOS Monterey 10.8.3_1

> brew install mariadb  标准包

或者

> brew install mariadb --build-from-source    该方式可以使用不同的服务版本并启用在标准包不包含的特性

安装过程

```
==> Downloading https://ghcr.io/v2/homebrew/core/bison/manifests/3.8.2
Already downloaded: /Users/leonwang/Library/Caches/Homebrew/downloads/0a84b14c20dfba4609542ea4b14a4eb93d369f7f83f373b568017fc7d76b6505--bison-3.8.2.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/bison/blobs/sha256:78ce4e93936c37005e944b21e4b4d305725bc66f6c675acf2eb13cf72bac01cc
Already downloaded: /Users/leonwang/Library/Caches/Homebrew/downloads/464e497b0d90e497f2a2626b51e5196f550e1ab9c32c132d67f8de1838c3ebb2--bison--3.8.2.arm64_monterey.bottle.tar.gz
==> Downloading https://ghcr.io/v2/homebrew/core/cmake/manifests/3.23.2
Already downloaded: /Users/leonwang/Library/Caches/Homebrew/downloads/8c660dfdefa1d54b99282a6939d32df169650ee980c4ab12067ffe8c6951bfcd--cmake-3.23.2.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/cmake/blobs/sha256:46711ae9d567064916561c472b94cba0e939ae72479f6f51ebe98dc6995c4422
Already downloaded: /Users/leonwang/Library/Caches/Homebrew/downloads/b789f2db50059e52a77d19268c614d187338b1359dd1c9bcb958c3c633b79a8f--cmake--3.23.2.arm64_monterey.bottle.tar.gz
==> Downloading https://ghcr.io/v2/homebrew/core/fmt/manifests/8.1.1_1
Already downloaded: /Users/leonwang/Library/Caches/Homebrew/downloads/97ba35de6420d2de6b2b9d9cdee279cc9944b43ea0b392556892b7eec87305ef--fmt-8.1.1_1.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/fmt/blobs/sha256:47866137bfcc88428ad11fb6b1a6815a3e23343a01b87532921f9606c8079df0
Already downloaded: /Users/leonwang/Library/Caches/Homebrew/downloads/b2c43588e598ac834e412fe03a19307041e320afdc9f3788ea2e8f83cab1fdc3--fmt--8.1.1_1.arm64_monterey.bottle.tar.gz
==> Downloading https://downloads.mariadb.com/MariaDB/mariadb-10.8.3/source/mariadb-10.8.3.tar.gz
Already downloaded: /Users/leonwang/Library/Caches/Homebrew/downloads/3443453ff99fc7969bc65024b68eab6f10f751827630e336b4a6af7a2dfbf0ec--mariadb-10.8.3.tar.gz
==> Installing dependencies for mariadb: bison, cmake and fmt
==> Installing mariadb dependency: bison
==> Pouring bison--3.8.2.arm64_monterey.bottle.tar.gz
🍺  /opt/homebrew/Cellar/bison/3.8.2: 99 files, 3.7MB
==> Installing mariadb dependency: cmake
==> Pouring cmake--3.23.2.arm64_monterey.bottle.tar.gz
🍺  /opt/homebrew/Cellar/cmake/3.23.2: 3,043 files, 42.2MB
==> Installing mariadb dependency: fmt
==> Pouring fmt--8.1.1_1.arm64_monterey.bottle.tar.gz
🍺  /opt/homebrew/Cellar/fmt/8.1.1_1: 27 files, 1MB
==> Installing mariadb
==> cmake . -DMYSQL_DATADIR=/opt/homebrew/var/mysql -DINSTALL_INCLUDEDIR=include/mysql -DINSTALL_MANDIR=share/man -DINSTALL_DOCDIR=share/doc/mariadb -DINSTALL_INFODIR=share/info
==> make
==> make install
==> /opt/homebrew/Cellar/mariadb/10.8.3_1/bin/mysql_install_db --verbose --user=leonwang --basedir=/opt/homebrew/Cellar/mariadb/10.8.3_1 --datadir=/opt/homebrew/var/mysql --tmpdi
==> Caveats
A "/etc/my.cnf" from another install may interfere with a Homebrew-built
server starting up correctly.

MySQL is configured to only allow connections from localhost by default

To restart mariadb after an upgrade:
  brew services restart mariadb
Or, if you don't want/need a background service you can just run:
  /opt/homebrew/opt/mariadb/bin/mysqld_safe --datadir=/opt/homebrew/var/mysql
==> Summary
🍺  /opt/homebrew/Cellar/mariadb/10.8.3_1: 915 files, 176.5MB, built in 3 minutes 46 seconds
==> Running `brew cleanup mariadb`...
Disable this behaviour by setting HOMEBREW_NO_INSTALL_CLEANUP.
Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`).
==> Caveats
==> mariadb
A "/etc/my.cnf" from another install may interfere with a Homebrew-built
server starting up correctly.

MySQL is configured to only allow connections from localhost by default

To restart mariadb after an upgrade:
  brew services restart mariadb
Or, if you don't want/need a background service you can just run:
  /opt/homebrew/opt/mariadb/bin/mysqld_safe --datadir=/opt/homebrew/var/mysql
```

**注意点**

* mariadb启动方式：

  > brew services start mariadb

  ```
  leonwang@LeondeMBP  ~  brew services start mariadb
  ==> Successfully started `mariadb` (label: homebrew.mxcl.mariadb)
  ```

  避免用mysql start 或者mysql.server start 进行启动（同样不要用该命令停止），会出现如下错过：

  ```
  /opt/homebrew/bin/mysql.server: line 261: log_success_msg: command not found
  ```

* 连接 ，安装完成之后默认仅允许在本地连接，且只能在sudo命令root用户免密方式登陆

  > sudo mysql -u root

  ```
  leonwang@LeondeMBP  ~  sudo mysql -u root
  Welcome to the MariaDB monitor.  Commands end with ; or \g.
  Your MariaDB connection id is 24
  Server version: 10.8.3-MariaDB Homebrew
  
  Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.
  
  Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
  
  MariaDB [(none)]>
  ```

* 创建用户

  ```sql
  CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'password';
  
  GRANT ALL PRIVILEGES ON database_name.* TO 'newuser'@'localhost';
  
  ```

​		接下来你就可以用刚创建的用户进行连接操作。

## 参考

[mariadb官网](https://mariadb.com/kb/en/installing-mariadb-on-macos-using-homebrew/)

