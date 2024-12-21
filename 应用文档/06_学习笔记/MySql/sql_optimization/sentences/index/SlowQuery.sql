-- 默认情况下slow_query_log的值为OFF，表示慢查询日志是禁用的，可以通过设置slow_query_log的值来开启
show variables like '%slow_query_log%';
-- 设置完日志路径后，需要手动创建文件
set global slow_query_log_file = '/var/lib/mysql/vm_mysql-slow.log';
-- 1表示开启，0表示关闭。
set global slow_query_log=1;
-- 这个参数用于指定慢查询日志的存放路径，缺省情况是host_name-slow.log文件
show variables like 'slow_query_log_file';
-- 默认情况下long_query_time的值为10秒
show variables like 'long_query_time%';
-- 设置为4秒(注意：上述命令 查看的是当前会话的变量值，需要重新连接或新开一个会话才能看到修改值)
set global long_query_time=4;
-- 也可以不用重新连接会话，而是用
show global variables like 'long_query_time';
/*
  log_output='FILE'表示将日志存入文件，默认值也是'FILE'
	log_output='TABLE'表示将日志存入数据库，这样日志信息就会被写入到mysql.slow_log表中
	同时也支持两种日志存储方式，配置的时候以逗号隔开即可，如：log_output='FILE,TABLE'
	日志记录到系统的专用日志表中，要比记录到文件耗费更多的系统资源
	因此对于需要启用慢查询日志，又需要能够获得更高的系统性能，那么建议优先记录到文件
*/
show variables like '%log_output%';
-- 设置日志存储方式
set global log_output = 'FILE';
# set global log_output = 'TABLE';
# set global log_output = 'FILE,TABLE';
-- 睡眠5秒
select *,sleep(6) from employees where name like 'Lucy';
-- 查询mysql表的慢日志表信息
select * from mysql.slow_log;
-- 清除慢日志表的数据
truncate table mysql.slow_log;
delete from mysql.slow_log where start_time >= '2023-11-03 00:00:00' and start_time < '2023-11-03 59:59:59';
-- 该系统变量指定未使用索引的查询也被记录到慢查询日志中（可选项）
show variables like 'log_queries_not_using_indexes';
-- 如果调优的话，建议开启这个选项
set global log_queries_not_using_indexes=1;
-- 这个系统变量表示，是否将慢管理语句例如ANALYZE TABLE和ALTER TABLE等记入慢查询日志
show variables like 'log_slow_admin_statements';
-- 如果你想查询有多少条慢查询记录，可以使用Slow_queries系统变量
show global status like '%Slow_queries%';
# flush status;
-- 查看所有库名
show databases;

-- 查找持有表锁的会话
show full  processlist;
-- 使用INFORMATION_SCHEMA进程列表
select * from information_schema.processlist where state = 'locked';
-- 终止会话 kill {session_id}
kill 23;

-- 锁定表
LOCK TABLES my_table WRITE;
# 执行一些操作...
-- 解锁表
UNLOCK TABLES;