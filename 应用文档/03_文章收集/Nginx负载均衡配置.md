# [超级详细的nginx负载均衡配置](https://www.jb51.net/article/246881.htm)

 更新时间：2022年05月05日 15:36:58  作者：小码农叔叔  

所谓负载均衡就是就是把大量的请求按照我们指定的方式均衡的分配给集群中的每台服务器,从而不会产生集群中大量请求只请求某一台服务器,从而使该服务器宕机的情况,这篇文章主要给大家介绍了关于nginx负载均衡配置的相关资料,需要的朋友可以参考下

# 目录

- [前言](https://www.jb51.net/article/246881.htm#_label0)
- [实验准备](https://www.jb51.net/article/246881.htm#_label1)
- [实验步骤](https://www.jb51.net/article/246881.htm#_label2)
- [其他负载均衡配置策略](https://www.jb51.net/article/246881.htm#_label3)
- [总结](https://www.jb51.net/article/246881.htm#_label4)



## 前言

nginx作为一款企业级的代理服务器，不管是大中小各类生产项目中，均有广泛的使用，尤其是在前后端分离的项目中，nginx作为路由转发的功能是非常常用的；

在一些流量比较大的项目中，为了应对高并发的场景，后端服务往往采用集群部署，这时候，就需要使用到nginx的负载均衡功能；



## 实验准备

- nginx服务器；
- 两个后端服务；



## 实验步骤

**1、启动两个后端服务**

这里准备了两个springboot工程，编写了2个测试使用的接口，以端口号区分

```
@RestController``@RequestMapping``(``"/api"``)``public` `class` `NginxController1 {``  ``@GetMapping``  ``public` `String test1(){``    ``return` `"success test1 8082"``;``  ``}``}
@RestController``@RequestMapping``(``"/api"``)``public` `class` `NginxController1 {``  ``@GetMapping``  ``public` `String test1(){``    ``return` `"success test1 8081"``;``  ``}``}
```

启动之后，浏览器分别访问一下，确保服务是正常的

![img](https://img.jbzj.com/file_images/article/202205/2022050515341623.png)

![img](https://img.jbzj.com/file_images/article/202205/2022050515341624.png)

**2、nginx.conf进行配置**

1）在server中添加一个location，并且配置 proxy_pass

```
location / {``      ``#转发到负载服务上``      ``proxy_pass http:``//webservers/api/``;``}
```

2）配置upstream，指向后端服务

```
upstream webservers{``   ``server 192.168.9.134:8081;``   ``server 192.168.9.134:8082;``}
```

完整的配置参考如下：

```
#user nobody;``worker_processes 1;``events {``  ``worker_connections 1024;``}` `http {``  ``include    mime.types;``  ``default_type application``/octet-stream``;``  ``sendfile    on;``  ``keepalive_timeout 65;``  ``upstream webservers{``   ``server 192.168.9.134:8081 weight=8;``   ``server 192.168.9.134:8082 weight=2;``  ``}`` ` `  ``server {``    ``listen    80;``    ``server_name localhost;``    ``#location / {``     ``#  root  html;``     ``# index index.html index.htm;``    ``#}` `    ``location / {``       ``#转发到负载服务上``      ``proxy_pass http:``//webservers/api/``;``     ``}` `    ``error_page  500 502 503 504 ``/50x``.html;``    ``location = ``/50x``.html {``      ``root  html;``    ``}``  ``}``}
```

修改完毕后，启动nginx，或者重新加载配置

```
nginx.exe -s reload
```

浏览器访问：localhost:80，多刷几次，下面两个展示的界面轮询的出现

![img](https://img.jbzj.com/file_images/article/202205/2022050515341625.png)

![img](https://img.jbzj.com/file_images/article/202205/2022050515341626.png)

**3、负载均衡配置说明**

默认情况下，直接按照上面的配置后，如果后端有多个服务，采用的是轮询策略；

常用的可选配置包括：

> weight 多台机器，可以配置权重值，权重高的服务将会优先被访问
> down 某个服务配置down之后，这台服务将不会被访问
> backup 配置了这个参数后，除非其他的服务都挂掉了，否则这台服务将不会被访问到

以weight 为例做简单的说明，在上面的配置中，补充weight参数

```
upstream webservers{``   ``server 192.168.9.134:8081 weight=8;``   ``server 192.168.9.134:8082 weight=2;``  ``}
```

重新加载配置，按照上面的测试步骤再次刷新页面，这时候可以发现，8081对于的这个服务将会被更多的访问到；



## 其他负载均衡配置策略

默认情况下，nginx采用的是轮询策略，nginx还提供了其他几种常用的负载均衡配置

**1、ip_hash**

> 每个请求按访问IP的hash结果进行分配，这样每个访客就可以固定访问一个后端服务，一定程度上可以解决session问题；

```
upstream webservers {<!--{cke_protected}{C}%3C!%2D%2D%20%2D%2D%3E--> ip_hash; server 192.168.9.134:8081; server 192.168.9.134:8082;}
```

**2、weight**

> weight代表权重，默认为1，权重越高，被分配的客户端请求就会越多

```
upstream webservers{``   ``server 192.168.9.134:8081 weight=8;``   ``server 192.168.9.134:8082 weight=2;`` ``}
```

**3、fair（第三方）**

> 按后端服务器的响应时间来分配请求，响应时间短的将会被优先分配

```
upstream webservers{``    ``server 192.168.9.134:8081;``    ``server 192.168.9.134:8082;``    ``fair;``}
```

**4、url_hash**

> 按访问URL的hash结果分配。这样相同的url会被分配到同一个节点，主要为了提高缓存命中率。比如，为了提高访问性能，服务端有大量数据或者资源文件需要被缓存。使用这种策略，可以节省缓存空间，提高缓存命中率

```
upstream webservers{``  ``hash` `&request_uri;``  ``server 192.168.9.134:8081;``  ``server 192.168.9.134:8082;``}
```

**5、least_conn**

> 按节点连接数分配，把请求优先分配给连接数少的节点。该策略主要为了解决，各个节点请求处理时间长短不一造成某些节点超负荷的情况。

```
upstream webservers{``  ``least_conn;``  ``server 192.168.9.134:8081;``  ``server 192.168.9.134:8082;``}
```

以上不同的负载均衡策略均有各自不同的使用场景，请结合自身的实际情况进行合理的选择，同时，各自配置策略在实际使用的时候也不是孤立的，比如最小连接数可以搭配权重数一起使用



## 总结

到此这篇关于nginx负载均衡配置的文章就介绍到这了,更多相关nginx负载均衡配置内容请搜索脚本之家以前的文章或继续浏览下面的相关文章希望大家以后多多支持脚本之家！