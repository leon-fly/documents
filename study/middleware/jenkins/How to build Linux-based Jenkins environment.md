# How to build Linux-based Jenkins environment

## Install jenkins

### 1.1 the official way to install and run

  [Click here to get the guide.](https://www.jenkins.io/doc/book/installing/linux/)

## 1.2 install and run by the war file

### 1.2.1 Install and run tomcat

1. Download And Extract The Latest Binary Distribution [[download v8.5.71](https://downloads.apache.org/tomcat/tomcat-8/v8.5.71/bin/apache-tomcat-8.5.71.tar.gz) , other version you can find [here](https://tomcat.apache.org/download-80.cgi?Preferred=https%3A%2F%2Fdownloads.apache.org%2F)]

   ```
   wget https://downloads.apache.org/tomcat/tomcat-8/v8.5.71/bin/apache-tomcat-8.5.71.tar.gz
   tar xvzf apache-tomcat-8.5.71.tar.gz
   sudo mv apache-tomcat-8.5.71 /usr/local/tomcat
   ```

2. Run the tomcat

   > $TOMCAT_HOME/bin/startup.sh

3. visit http://localhost:8080

### 1.2.2 Download jenkins war file

```
wget https://updates.jenkins-ci.org/download/war/2.249/jenkins.war
mv jenkins.war $TOMCAT_HOME/webapps
```

### 1.2.3 Customizing Jenkins with plugins.







