常用

```tex
cd /usr/local/apps/rocketmq/bin
```

```tex
cd /usr/local/apps/rocketmq/conf/2m-2s-sync
```

前台运行

```tex
sh mqnamesrv
```

```tex
sh mqbroker -c ../conf/2m-2s-sync/broker-a.properties
```

```tex
sh mqbroker -c ../conf/2m-2s-sync/broker-b-s.properties
```

后台运行

```tex
nohup sh mqnamesrv &
```

```tex
nohup sh mqbroker -c ../conf/2m-2s-sync/broker-a.properties &
```

```tex
nohup sh mqbroker -c ../conf/2m-2s-sync/broker-b-s.properties &
```

