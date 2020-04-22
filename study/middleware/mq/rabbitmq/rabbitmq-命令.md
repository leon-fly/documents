---
date: "2020-04-18"
draft: false
lastmod: "2020-04-18"
publishdate: "2020-04-18"
tags:
- middleware
- mq
- rabbitmq
title: rabbitmq-命令
---

## 1. 命令概览
rabbitmq为管理提供了众多命令行工具。主要包括服务、诊断、插件、队列、升级等方面的管理命令行。

## 2. rabbitmqctl
用于服务节点管理和一般操作员任务的命令行。包括节点及应用的启停、重置，集群管理、用户管理、虚拟主机、权限管理、队列管理.管理平台的各项视图及管理功能基本一致。各子项命令如下：

```
Commands:
    stop [<pid_file>]
    shutdown
    stop_app
    start_app
    wait <pid_file>
    reset
    force_reset
    rotate_logs <suffix>
    hipe_compile <directory>

    join_cluster <clusternode> [--ram]
    cluster_status
    change_cluster_node_type disc | ram
    forget_cluster_node [--offline]
    rename_cluster_node oldnode1 newnode1 [oldnode2] [newnode2 ...]
    update_cluster_nodes clusternode
    force_boot
    sync_queue [-p <vhost>] queue
    cancel_sync_queue [-p <vhost>] queue
    purge_queue [-p <vhost>] queue
    set_cluster_name name

    add_user <username> <password>
    delete_user <username>
    change_password <username> <newpassword>
    clear_password <username>
    authenticate_user <username> <password>
    set_user_tags <username> <tag> ...
    list_users

    add_vhost <vhost>
    delete_vhost <vhost>
    list_vhosts [<vhostinfoitem> ...]
    set_permissions [-p <vhost>] <user> <conf> <write> <read>
    clear_permissions [-p <vhost>] <username>
    list_permissions [-p <vhost>]
    list_user_permissions <username>

    set_parameter [-p <vhost>] <component_name> <name> <value>
    clear_parameter [-p <vhost>] <component_name> <key>
    list_parameters [-p <vhost>]
    set_global_parameter <name> <value>
    clear_global_parameter <name>
    list_global_parameters

    set_policy [-p <vhost>] [--priority <priority>] [--apply-to <apply-to>]
<name> <pattern>  <definition>
    clear_policy [-p <vhost>] <name>
    list_policies [-p <vhost>]

    list_queues [-p <vhost>] [--offline|--online|--local] [<queueinfoitem> ...]
    list_exchanges [-p <vhost>] [<exchangeinfoitem> ...]
    list_bindings [-p <vhost>] [<bindinginfoitem> ...]
    list_connections [<connectioninfoitem> ...]
    list_channels [<channelinfoitem> ...]
    list_consumers [-p <vhost>]
    status
    node_health_check
    environment
    report
    eval <expr>

    close_connection <connectionpid> <explanation>
    trace_on [-p <vhost>]
    trace_off [-p <vhost>]
    set_vm_memory_high_watermark <fraction>
    set_vm_memory_high_watermark absolute <memory_limit>
    set_disk_free_limit <disk_limit>
    set_disk_free_limit mem_relative <fraction>
    encode [--decode] [<value>] [<passphrase>] [--list-ciphers] [--list-hashes]
```

## 3. rabbitmq-diagnostics
rabbitmq的诊断、监控及健康检测工具。

## 4. rabbitmq-plugins

## 5. rabbitmq-queues

## 6. rabbitmq-upgrade

## 7. 参考
👉 [官方客户端命令工具说明](https://www.rabbitmq.com/cli.html)

TODO 未完...