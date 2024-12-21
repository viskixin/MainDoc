1. 引入热部署【devtools】的【maven】引用

```xml
<!-- 热部署 -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-devtools</artifactId>
    <optional>true</optional>
    <scope>true</scope>
</dependency>
```

2. 在下面的【build → plugins → plugin → configuration】中，加入【fork 标签，并设置为 true】

```xml
<build>
    <plugins>
        <!-- java编译插件 -->
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-compiler-plugin</artifactId>
            <version>3.2</version>
            <configuration>
                <!-- 如果没有该项(fork)配置，devtools不会起作用，即应用不会restart -->
                <fork>true</fork>
            </configuration>
        </plugin>
    </plugins>
</build>
```

3. 配置文件 → 开启热部署

```yaml
# Spring配置
spring:
  # 服务模块
  devtools:
    restart:
      enabled: true # 打开热部署
      additional-paths: META-INF/resources/**,resources/**,static/**,public/**,templates/** #设置重启的目录
      exclude: data/** #该目录下的内容修改不重启
```

4. Ctrl + Alt + S | Build,Execution,Deployment | Compiler → 勾选 Build project automatically

![image-20220510180227478](..\..\..\imgs\01\Tools\IDEA\image-20220510180227478-16521776657491.png)

5. Ctrl + Alt + Shift + /    →    选择 Resgistry    →    勾选 compiler.automake.allow.when.app.running

![image-20220510180636023](..\..\..\imgs\01\Tools\IDEA\image-20220510180636023-16521776657502.png)

6. Run | Debug Configurations → 在 On Update action 中，选择 Update classes and resources

![image-20220510181157891](..\..\..\imgs\01\Tools\IDEA\image-20220510181157891.png)
