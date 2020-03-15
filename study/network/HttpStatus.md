# 1. 业务规则错误建议的HTTP返回码

[参考分析1](https://softwareengineering.stackexchange.com/questions/341732/should-http-status-codes-be-used-to-represent-business-logic-errors-on-a-server)

[参考分析2](https://stackoverflow.com/questions/42262269/what-http-status-code-should-the-web-api-return-for-a-business-rule-failure/42263124)

[参考分析3](https://www.quora.com/In-Restful-API-which-error-code-represents-application-failure-to-process-a-request-due-to-business-rule)

[RFC2616 http 1.1协议  Http Status 定义](https://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html)

> 400 Bad Request
> 403 Forbidden
> 409 Conflict

# 2. 最常用的返回码

## 2.1. XX 成功
200 请求成功
## 2.2. XX 重定向
302 临时重定向
303 临时重定向，客户端应该采用get方法获取资源

## 2.3. XX 客户端错误码
400 错误请求
401 未授权
403 Forbidden请求被服务器拒绝
404 NotFound 未找到
405 MethodNotAllowed 不支持的请求方法

## 2.4. XX 服务器端错误
500 Internal Server Error(内部服务器错误)
502 Bad Gateway（网关故障）
503 Service Unavailable（服务不可用）
504 Gateway Timeout（网关超时）	