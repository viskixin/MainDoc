查看端口占用情况

```markdown
输入：
	netstat -aon|findstr "端口(port)"
响应：
	TCP    xxx.xxx.xxx.xxx:端口    xxx.xxx.xxx.xxx:其他端口    LISTENING/ESTABLISHED    "进程(pid)"
```

查看端口被哪个应用占用

```markdown
输入：
	tasklist|findstr "进程"
响应：
	xxx.exe    xxxx Console    3    xxx,xxx K
```

按进程号关闭

```markdown
关闭：
	taskkill /pid "进程"
多个时格式为：
	taskkill /pid "进程1" /pid "进程2"
强制关闭：
	taskkill /f /pid "进程"
```

按进程名关闭

```markdown
关闭：
	taskkill /im xxx.exe
关闭所有：
	taskkill /im *.exe
强制关闭：
taskkill /f /im xxx.exe
```

