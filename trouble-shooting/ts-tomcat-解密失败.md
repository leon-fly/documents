# 💣 合作方RSA通过公钥加密的数据用私钥无法解密

**Time : 2020/03/05**
**Issue Description:**
合作方发送的get请求参数为sign=URLEncode(RSA(data,publicKey)),我方收到请求后应先URLDecode再RSA私钥解密,逻辑没毛病。

**👉 解决方案：**
各个环节做了排查，甚至为了排除与合作方的算法有差异，使用了合作方的sdk，结果还是失败，经过最终对比发现通过request获取到的sign是已经Tomcat容器URLDecode过的，再次URLDecode自然无法再解密(详见tomcat源码org.apache.coyote.Request及org.apache.tomcat.util.http.Parameters的processParameters方法)