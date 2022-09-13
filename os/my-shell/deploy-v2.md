---
date: "2018-01-01"
draft: false
lastmod: "2022-01-19"
publishdate: "2022-01-19"
tags:
- shell
- linux
title: deployment version 2
---
## 1. core.sh

```
#!/bin/bash

: ${JAVA_EXEC="java"}
: ${JAVA_OPTS="-Xms800m -Xmx800m -XX:MaxMetaspaceSize=256m"}
: ${SERVICE_NAME=${JAR_PATH#/opt/app/}}

stop() {
  pid=$(ps -ef | grep $SERVICE_NAME | grep -v grep | awk '{print $2}')
  if [ -n "$pid" ]; then
    kill $pid
    echo "Gracefully stopping '$SERVICE_NAME' with PROCESS_ID:'$pid'..."
  fi

  pid=$(ps -ef | grep $SERVICE_NAME | grep -v grep | awk '{print $2}')
  if [ -z "$pid" ]; then
    echo "Instances of '$SERVICE_NAME' has been successfully stopped" 1>&2
  else
    for PROCESS_ID in $pid; do
      counter=1
      until [ $counter -gt 150 ]; do
        if ps -p $PROCESS_ID >/dev/null; then
          echo "Waiting for the process($PROCESS_ID) to finish on it's own for $
((300 - $(($counter * 2)))) seconds..."
          sleep 2s
          ((counter++))
        else
          echo "The service '$SERVICE_NAME' with PROCESS_ID:'$PROCESS_ID' is sto
pped now.."
          return
        fi
      done
      echo "Forcefully Killing '$SERVICE_NAME' with PROCESS_ID:'$PROCESS_ID'."
      kill -9 $PROCESS_ID
    done
  fi
}

start() {
  pid=$(ps -ef | grep $SERVICE_NAME | grep -v grep | awk '{print $2}')
  if [ -n "$pid" ]; then
    echo "The service '$SERVICE_NAME' is already running"
    stop
  fi
  $JAVA_EXEC $JAVA_OPTS -jar $JAR_PATH >/dev/null 2>"/opt/logs/$SERVICE_NAME-sta
rt-log" &
  echo "The service '$SERVICE_NAME' started"
}

case $1 in
start)
  start
  ;;
stop)
  stop
  ;;
restart)
  stop
  start
  ;;
*)
  echo "The command '$1' is not supported"
  exit 0
  ;;
esac
```

## 2. microservice.sh

```
JAR_PATH="/opt/app/geely-bfp-user-server-0.0.1-SNAPSHOT.jar"

source $( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/core.sh $1
```

## 3. start/stop/restart

> ./microservice.sh start
