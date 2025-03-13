```tex
https://mp.weixin.qq.com/s/BJdI6kUJIhmWcwlK-c5tlg
```

# 是时候丢掉 Postman、Swagger 了；这个工具全部搞定，真香！

原创 一航 [一行Java](javascript:void(0);) *昨天*

收录于话题#高效工具85个内容

![图片](imgs\ApiPost工具/picture1.webp)
[图片链接](http://mp.weixin.qq.com/s?__biz=MzU5MDgyMzc2OA==&mid=2247502252&idx=1&sn=8a51beba0395e9c07abc56cd27008a28&chksm=fe3ae19bc94d688d181fc90a2ec71d2ddc0b133d35029488194a4ab6b3703238c9df552c225a&scene=21#wechat_redirect)
[**Java进阶学习资料（免费领取视频及源码）**](https://mp.weixin.qq.com/s?__biz=MzAwMTE3MDY4MQ==&mid=2652445422&idx=3&sn=8f2630b98acb8d47fb9d524863c6414d&scene=21&token=708736224&lang=zh_CN#wechat_redirect)

大家好，我是一航！

如果你是一名Java后端开发工程师，像`Swagger`、`Postman`、`RAP`这些工具，应该再熟悉不过了吧！为我们的接口开发工作带来了很多的便捷，不过因为这些都是独立的框架，之间并不存在互通性，因此在多个框架间协调的时候，不可避免的会带来一些重复性的工作；

今天来介绍一款强大的国产工具：**ApiPost**，将Swagger  、 Postman  、 RAP 、 JMeter 的功能完美的做了整合，一款工具，全部搞定。

# 什么是ApiPost

**ApiPost** = `接口调试`+`接口文档快速生成`+`接口文档规范化管理`+`Mock API`+`接口流程测试`。

常见的接口管理方案

- API文档

  Swagger

- 调试 API

  Postman

- Mock API 数据

  RAP

- API 自动化测试

  JMeter

ApiPost产生的初衷是为了提高研发团队各个角色的效率！产品的使用受众为由前端开发、后端开发和测试人员以及技术经理组成的整个研发技术团队。

APIPOST通过协作功能将研发团队的每个角色整合打通。

# 安装

ApiPost目前提供Window64位，Window32位、Mac、Linux版本的安装包下载。

可通过以下官方地址进行下载

> https://www.apipost.cn/download.html

特别推荐：👉[3万字总结Java自学、进阶线路图、学习资料](https://mp.weixin.qq.com/s?__biz=MzU5MDgyMzc2OA==&mid=2247502252&idx=1&sn=8a51beba0395e9c07abc56cd27008a28&chksm=fe3ae19bc94d688d181fc90a2ec71d2ddc0b133d35029488194a4ab6b3703238c9df552c225a&scene=21#wechat_redirect)

# 使用

## 发送HTTP请求

API界面功能布局

![图片](imgs\ApiPost工具/picture2.webp)

### API请求参数

#### Header 参数

你可以设置或者导入 Header 参数，cookie也在Header进行设置

![图片](imgs\ApiPost工具/picture3.webp)

#### Query 参数

Query 支持构造URL参数，同时支持 RESTful 的 PATH 参数（如:id）

![图片](imgs\ApiPost工具/picture4.webp)

#### Body 参数

Body 提供三种类型 form-data / x-www-form-urlencoded / raw ，每种类型提供三种不同的UI界面

- 当你需要提交表单时，切换到 x-www-form-urlencoded

  ![图片](imgs\ApiPost工具/picture5.webp)

- 当你需要提交有文件的表单时，切换到 form-data

  ![图片](imgs\ApiPost工具/picture6.webp)

- 当您需要发送JSON对象或者其他对象时，切换到对应的raw类型即可

  ![图片](imgs\ApiPost工具/picture7.webp)

### API 请求响应

点击发送按钮后，如果有数据返回，则会显示返回数据，响应时间，响应码，Cookie等。

![图片](imgs\ApiPost工具/picture8.webp)

注意：返回数据默认是Pretty模式，便于查看 JSON XML 格式。您可以通过切换 原生 或 预览 模式 查看其它类型的类型。

#### 返回Headers

![图片](imgs\ApiPost工具/picture9.webp)

### 全局参数和目录参数

实际的企业级应用开发常见下，通常会约定一些通用的数据，比如token、时间、终端这些，如果每个接口都去独立去维护，势必会对开发、调试带来一些不必要的工作量；此时，我们就需要有一个能设置全局参数的地方来统一管理这些公共参数

#### 全局参数

我们打开全局参数管理器，在全局header处填上token参数：

每次在接口请求的时候，就会自动带上这些公共配置的参数。

#### 目录参数

目录参数和全局参数的作用一样，属于一个更细化的功能，可以通过目录，来区分全局参数的作用域；可以为不同的目录设置不用的公共参数：

#### 参数的优先级

当全局参数、目录参数、接口中都使用了同一个参数时，最终会按照以下优先级读取参数值：

**单个接口 > 目录参数 > 全局参数**

### 响应和断言

#### 响应

当Http请求发送之后，得到的服务端返回的结果表示一个响应；其中会得到状态码、数据、Headers、Cookie等。

![图片](imgs\ApiPost工具/picture10.webp)

- Headers

  ![图片](imgs\ApiPost工具/picture11.webp)

#### 断言

服务器返回了响应数据，并不代表着接口就一定正常了，很可能以为bug或者数据异常导致得到的结果并没有达到实际的预期；因此，我们就可以使用断言功能，来判断最终响应的结果是不是我们想要的；

![图片](imgs\ApiPost工具/picture12.webp)

##### 常用断言表达式

1. 检查response body中是否包含某个string

   ```
   apt.assert('response.raw.responseText=="test"');  // 检查响应文本是否等于test字符串 
   apt.assert('response.raw.responseText.indexOf("test") > -1');  // 检查响应文本是否含有test字符串
   ```

2. 检测返回JSON中的某个值是否等于预期的值

   ```
   apt.assert('response.json.hasOwnProperty("errcode")'); // 检测返回json对象的是否含有errcode字段
   apt.assert('response.json.errcode=="success"');  // 检测返回json对象的errcode字段是否等于success字符串
   apt.assert('response.json.errcode.indexOf("success") > -1');  // 检测返回json对象的errcode字段是否含有success字符串
   apt.assert('response.json.errcode!="success"');  // 检测返回json对象的errcode字段是否不等于success字符串
   apt.assert('response.json.errcode>=1');  // 检测返回json对象的errcode字段是否大于1
   apt.assert('response.json.errcode==null'); // 检测返回json对象的errcode字段是否是null
   ```

3. 测试response Headers中的某个元素是否存在(如:Content-Type)

   ```
   apt.assert('response.headers.hasOwnProperty("content-type")');
   ```

4. 验证Status code（响应码）的值是不是等于200

   ```
   apt.assert('response.raw.status==200');
   ```

5. 验证Response time（请求耗时）是否大于某个值

   ```
   apt.assert('response.raw.responseTime>=100');
   ```

6. 验证返回类型是不是json

   ```
   apt.assert('response.raw.type=="json"');
   ```

## 一键文档生成

当通过上述的功能验证完接口之后，即可通过`分享文档`或者`分享项目`的方式，一键生成接口文档；

![图片](imgs\ApiPost工具/picture13.webp)

点击分享之后，即可拿到一个接口文档访问地址，详情如下：

![图片](imgs\ApiPost工具/picture14.webp)

为了让文档的请求和响应参数更加的清晰、明确；我们可以对header、query以及form-data和urlencode的body参数进行详细的描述

- 请求参数描述

  ![图片](imgs\ApiPost工具/picture15.webp)

- 响应参数描述

  ![图片](imgs\ApiPost工具/picture16.webp)

## Mock

大部分企业的产品都采用的敏捷开发，为了能保证多端同步开展，当方案一旦确定，就需要通过Mock生成API的数据规则；这样多端就可以根据文档规则进行开发，不会因为团队间彼此的进度而互相干扰、互相影响。

### 编写Mock 规则

![图片](imgs\ApiPost工具/picture17.webp)

在APIPOST中，Mock 规则模板支持类型丰富（5.4版本起）。

#### 基本数据(固定json结构)

```
{
  "code": "0",
  "data": {
    "name": "张三丰",
    "age": 100
  },
  "desc": "成功"
}
```

#### 基本数据(Mock随机json结构)

```
{
  "code": "0",
  "data": {
    "list|20": [{
      "name": "@name",
      "age": "@integer(2)"
    }],
    "url": "https://echo.apipost.cn"
  },
  "desc": "成功"
}
```

#### RESTFUL逻辑数据

某些场景中，我们可能需要根据接口的入参规则，加入适当的逻辑处理后再返回数据。一个简单的场景就是登录场景，需要根据用户名密码，判断是否登录成功。再或者，我们需要根据产品ID动态返回产品信息，等等。

现在，ApiPost 的Mock 服务提供了这种场景的解决方案。以下示例中，我们用到了 _req.body对象，其含义是：

> 当 post 请求以 x-www-form-urlencoded 或者application/json 方式提交时，我们可以拿到请求的参数对象。

```
{
  "code": "0000",
  "data": {
    "verifySuccess": function() {
      let body = _req.body;
      return body.username === 'admin' && body.password === '123456';
    },
    "userInfo": function() {
      let body = _req.body;
      if (body.username === 'admin' && body.password === '123456') {
        return Mock.mock({
          username: "admin",
          email: "@email",
          address: "@address"
        });
      } else {
        return null;
      }
    },
  },
  "desc": "成功"
}
```

### 获取Mock地址

- 切换到Mock环境进行测试

  ![图片](imgs\ApiPost工具/picture18.webp)

- 复制Mock地址

  ![图片](imgs\ApiPost工具/picture19.webp)

## 自动化测试

流程测试是针对一个接口集合的测试，选择相应的环境，可以作为一系列请求一起运行。当您想要自动化API测试时，流程测试非常有用。

### 创建一个测试流程

步骤：

1. 新建接口，并添加断言
2. 打开流程测试，新建一个流程
3. 向流程添加测试接口
4. 选择环境，点击开始测试
5. 查看返回的测试接口

![图片](imgs\ApiPost工具/picture20.webp)

# 总结

至此，ApiPost常用的核心功能已经介绍完了，但ApiPost的强大并不限于此，在`团队管理`、`协同管理`、`项目管理`的多个方面都表现的很优秀，如果你还没有用过，建议尝试一下，相信用过之后，一定会爱上！

更多详细的功能，可查看官方文档：

> https://wiki.apipost.cn/

<center>END</center>

**精品资料，超赞福利，****免费领**

------

**微信****扫码**/**长按识别** 添加【**技术交流群****】**

已整理**2T+**视频资料，**12G+**电子书

**每天与您分享精品学习资料**

![图片](imgs\ApiPost工具/picture21.webp)

------

![图片](imgs\ApiPost工具/picture22.webp)

最近开发整理了一个用于速刷面试题的小程序**[《面试手册》【点击使用】](https://mp.weixin.qq.com/s?__biz=MzU5MDgyMzc2OA==&mid=2247503142&idx=1&sn=2b3353820051f48de2fd11373957cc10&chksm=fe3ae511c94d6c0773af5749b0612603e7ae87e46964dc66ecd60ac983001706d39262b829df&mpshare=1&scene=1&srcid=1101TS4eVSX591gRSPWujzqa&sharer_sharetime=1635738540561&sharer_shareid=df2a806b4b91be1baa244338948b7984&key=efaafabd99b724e4283615fcb6abc33cbe8e729388e0fe643a58c1b86431cb1ebca8031592c749ec0bd6d714965d91cfb20189ac5f1035808d17eda2bde7651e603ecd3cddf8aeb5cb7de43301653f9946b4aa98d7209a1c9a5b6e0bd13b9884d143310f1ab737a28f68fb65b2b5e773286a1a90554a0035fd0bb384cef75fff&ascene=0&uin=MTkyMjI3MzAxNA%3D%3D&devicetype=Windows+10+x64&version=63040026&lang=zh_CN&exportkey=A6Jj%2FMmmjPlJyPpMXyaQwAU%3D&pass_ticket=l6s%2BXtTdeK8hm9K6UOEs%2Bh6T%2BsUFvYJDLE1Wqh9tptojseTDuFaqhaHLPitiAwLY&wx_header=0&fontgear=2)**；其中收录了**上千道**常见面试题及答案(包含**基础、并发、JVM、MySQL、Redis、Spring、SpringMVC、SpringBoot、SpringCloud、消息队列**等多个类型)，欢迎您的使用。QQ交流群：**912509560**

------

![图片](imgs\ApiPost工具/picture23.webp)

【原创】怒肝3W字Java学习路线！从入门到封神全包了

[面试官：为什么 SpringBoot 的 jar 可以直接运行？](http://mp.weixin.qq.com/s?__biz=MzU5MDgyMzc2OA==&mid=2247502950&idx=1&sn=6f79800e33b8704e9662639223983f69&chksm=fe3ae451c94d6d475740e57cfb1734cd9c7ac48ecae9a8e9274732fb7e1168f1a1261c63cf03&scene=21#wechat_redirect)

[Group By 深度优化，真是绝了！](http://mp.weixin.qq.com/s?__biz=MzU5MDgyMzc2OA==&mid=2247502767&idx=1&sn=0aa95002366e405c2fd86fc6d48f3b3d&chksm=fe3ae398c94d6a8efb80c6441ca23ca0af73c2b91cd13c1b5850edf606a9d877a0dd93e039a2&scene=21#wechat_redirect)

[最牛逼的 Java 日志框架，性能无敌，横扫所有对手...](http://mp.weixin.qq.com/s?__biz=MzU5MDgyMzc2OA==&mid=2247502681&idx=1&sn=0bf8ccd8e58b2f0d4111f9141678e980&chksm=fe3ae36ec94d6a784795924c5081005e373b7d6982a652684432d4fadcaef70d8b19ec196a64&scene=21#wechat_redirect)

[Java字符串拼接的五种方法，哪种性能最好？](http://mp.weixin.qq.com/s?__biz=MzU5MDgyMzc2OA==&mid=2247502681&idx=2&sn=520e656ed957248f7e09dc7b2f3a935b&chksm=fe3ae36ec94d6a78495125c5829a44aa7bcbc732cfc25a93ddca6451408e32f00e0bd3015500&scene=21#wechat_redirect)

[满屏的get & set 太Low了？试试 MapStruct 高级玩法【附源码】](http://mp.weixin.qq.com/s?__biz=MzU5MDgyMzc2OA==&mid=2247502468&idx=1&sn=f3058bba4f8aacb4eb931493de4ac7f5&chksm=fe3ae2b3c94d6ba5861652ea0dc04275ba560d8e2ab998e45e74b75227844bfff9aded11f320&scene=21#wechat_redirect)

------

👇👇

👇点击"**阅读原文**"，获取更多资料（持续更新中）

[阅读原文](https://mp.weixin.qq.com/s?__biz=MzU5MDgyMzc2OA==&mid=2247503142&idx=1&sn=2b3353820051f48de2fd11373957cc10&chksm=fe3ae511c94d6c0773af5749b0612603e7ae87e46964dc66ecd60ac983001706d39262b829df&mpshare=1&scene=1&srcid=1101TS4eVSX591gRSPWujzqa&sharer_sharetime=1635738540561&sharer_shareid=df2a806b4b91be1baa244338948b7984&key=efaafabd99b724e4283615fcb6abc33cbe8e729388e0fe643a58c1b86431cb1ebca8031592c749ec0bd6d714965d91cfb20189ac5f1035808d17eda2bde7651e603ecd3cddf8aeb5cb7de43301653f9946b4aa98d7209a1c9a5b6e0bd13b9884d143310f1ab737a28f68fb65b2b5e773286a1a90554a0035fd0bb384cef75fff&ascene=0&uin=MTkyMjI3MzAxNA%3D%3D&devicetype=Windows+10+x64&version=63040026&lang=zh_CN&exportkey=A6Jj%2FMmmjPlJyPpMXyaQwAU%3D&pass_ticket=l6s%2BXtTdeK8hm9K6UOEs%2Bh6T%2BsUFvYJDLE1Wqh9tptojseTDuFaqhaHLPitiAwLY&wx_header=0&fontgear=2##)

阅读 3384

分享收藏

赞13在看3

：，。视频小程序赞，轻点两下取消赞在看，轻点两下取消在看

