# JaLo16K

## ISO

### [CentOS 9](D:\DevDoc\VMware\iso\)

```markdown
# 镜像
CentOS-Stream-9-latest-x86_64-dvd1.iso
```

### [CentOS 7](E:\DevDoc\VMware\iso\)

```markdown
# 镜像
CentOS-7-x86_64-DVD-2009.iso
```

## D:\DevDoc\VMware

### [workspace1](D:\DevDoc\VMware\workspace1)

#### [Info](#CentOS 9)

```markdown
# 虚拟机内部
root/123456
```

#### hosts

```markdown
# 编辑
vi /etc/hosts
# 配置
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.90.91   work1
192.168.90.92   work2
192.168.90.93   work3
```

#### docker

```markdown
暂无
```

#### zookeeper

```markdown
# 目录
cd /usr/local/soft/apache-zookeeper-3.8.4-bin
# 启动
-- 方式1
bin/zkServer.sh start
-- 方式2
bin/zkServer.sh start conf/zoo.cfg
-- 方式3
bin/zkServer.sh --config conf start
# 后台模式启动
bin//zkServer.sh start -daemon
# 重启
bin/zkServer.sh restart
......
# 停止
bin/zkServer.sh stop
......
# 状态
bin/zkServer.sh status
```

#### kafka

```markdown
# 目录
cd /usr/local/soft/kafka-3.4.1
# 后台模式启动
bin/kafka-server-start.sh -daemon config/server.properties
```

### [workspace2](D:\DevDoc\VMware\workspace2)

#### Info

```markdown
同上
```

#### hosts

```markdown
同上
```

#### docker

```markdown
暂无
```

#### zookeeper

```markdown
同上
```

#### kafka

```markdown
同上
```

### [workspace3](D:\DevDoc\VMware\workspace3)

#### Info

```markdown
同上
```

#### hosts

```markdown
同上
```

#### docker

```markdown
暂无
```

#### zookeeper

```markdown
同上
```

#### kafka

```markdown
同上
```

### [cluster1](D:\DevDoc\VMware\cluster1)

#### [Info](#CentOS 7)

```markdown
# 虚拟机内部
root/123456
```

#### redis

```markdown
# 目录
cd /usr/local/src/redis-5.0.3
# 启动
src/redis-server redis-cluster/8001/redis.conf
src/redis-server redis-cluster/8004/redis.conf
# 连接
src/redis-cli -a zhuge -c -h 192.168.90.61 -p 8001
......
# 退出连接
exit
# 关闭
src/redis-cli -a zhuge -c -h 192.168.90.61 -p 8001 shutdown
......
# 集群状态
cluster nodes
```

### [cluster2](D:\DevDoc\VMware\cluster2)

#### Info

```markdown
同上
```

#### redis

```markdown
# 目录
同上
# 启动
src/redis-server redis-cluster/8002/redis.conf
src/redis-server redis-cluster/8005/redis.conf
# 连接
src/redis-cli -a zhuge -c -h 192.168.90.62 -p 8002
......
```

### [cluster3](D:\DevDoc\VMware\cluster3)

#### Info

```markdown
同上
```

#### redis

```markdown
# 目录
同上
# 启动
src/redis-server redis-cluster/8003/redis.conf
src/redis-server redis-cluster/8006/redis.conf
# 连接
src/redis-cli -a zhuge -c -h 192.168.90.63 -p 8003
......
```

## E:\DevDoc\VMware

### [workspace](E:\DevDoc\VMware\workspace)

#### [Info](#CentOS 7)

```markdown
# 虚拟机锁屏
Williams Xavi/what.0414

# 虚拟机内部
root/123456

# Portainer
admin/xw2244255266
```

#### mongodb

```markdown
# 目录
cd /mongodb/mongodb-7.0.14
# 启动
-- 方式1
bin/mongod -f /mongodb/conf/mongo.conf --auth
-- 方式2
bin/mongod \
  --logpath /mongodb/log/mongod.log \
  --logappend \
  --dbpath /mongodb/data \
  --storageEngine wiredTiger \
  --bind_ip 0.0.0.0 \
  --port 27017 \
  --fork \
  --auth
# 连接
-- 方式1
mongosh --host=192.168.145.121 --port=27017
-- 方式2
mongosh 192.168.145.121:27017
-- 启动鉴权之后
use admin
db.auth("xxw", "123456")
-- 或者连接时鉴权
mongosh 192.168.145.121:27017 -u xxw -p 123456 --authenticationDatabase=admin
# 关闭
bin/mongod --port=27017 --dbpath=/mongodb/data --shutdown

# 集群数据
cd /mongodb/cluster_data
# 启动
-- 非鉴权
mongod -f /mongodb/cluster_data/db1/mongod.conf
mongod -f /mongodb/cluster_data/db2/mongod.conf
mongod -f /mongodb/cluster_data/db3/mongod.conf
-- 鉴权
mongod -f /mongodb/cluster_data/db1/mongod.conf --keyFile /mongodb/cluster_data/mongo.key
......
# 单节点连接
-- 方式1
mongosh --host 127.0.0.1 --port 28017 -u xxw -p 123456 --authenticationDatabase=admin
-- 方式2
mongosh --host rs0/localhost:28017 -u xxw -p 123456 --authenticationDatabase=admin
# 多节点连接
-- 方式1
mongosh --host "127.0.0.1:28017,127.0.0.1:28018,127.0.0.1:28019" -u xxw -p 123456 --authenticationDatabase=admin
-- 方式2
mongosh --host rs0/localhost:28017,localhost:28018,localhost:28019 -u xxw -p 123456 --authenticationDatabase=admin
# 关闭
mongod -f /mongodb/cluster_data/db1/mongod.conf --shutdown
......

# mlaunch 集群数据
cd /mongodb/cluster_sharded/node
# 启动
mlaunch start
# 关闭
mlaunch stop
# 状态
mlaunch list

# mlaunch 分库分表集群
cd /mongodb/cluster_sharded/cluster
# 启动
mlaunch start
# 关闭
mlaunch stop
# 状态
mlaunch list
```

