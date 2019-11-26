#!/bin/bash
 
# this shell is used for pack product package
PRODUCT_VERSION=$1

if [ -z $PRODUCT_VERSION ]
then echo "[READY-SCRIPT] WARN : parameter version can not be empty"
exit
fi

TARGET=~/online-jars/
JAR_NAME=zkj-api-${PRODUCT_VERSION}.jar
WORKSPACE=~/codes/zkj-platform
JAR_FILE_COPY_TO=~/online-jars

JAR_FILE=~/codes/zkj-platform/zkj-api/target/${JAR_NAME}
JAR_FILE_COPY=${JAR_FILE_COPY_TO}/${JAR_NAME}


echo "be ready for packing product package [${JAR_NAME}]"
echo "[READY-SCRIPT]---------------------------------------------   get in project directory..."
cd $WORKSPACE

echo "[READY-SCRIPT]---------------------------------------------   checkout master..."
git checkout master

echo "[READY-SCRIPT]---------------------------------------------   pull latest codes..."
git pull

echo "[READY-SCRIPT]---------------------------------------------   pack [${JAR_NAME}]..."
mvn clean install
if [ ! -e $JAR_FILE ];
then echo "[READY-SCRIPT] ERROR : pack [${JAR_NAME}] failure !!!!!!!!!!!!!!!!!!!!!!!";exit;
fi

echo "[READY-SCRIPT]-------------------------------------------   copy jar to directory ${JAR_FILE_COPY_TO}..."
cp $JAR_FILE $JAR_FILE_COPY
if [ ! -e $JAR_FILE_COPY ];
then echo "[READY-SCRIPT] ERROR : copy [${JAR_NAME}] failure !!!!!!!!!!!!!!!!!!!!!!!";exit;
fi


echo "[READY-SCRIPT] SUCCESS, NOW YOU CAN CHECK THE GENERATED JAR IN DIRECTORY ~/online-jars/"