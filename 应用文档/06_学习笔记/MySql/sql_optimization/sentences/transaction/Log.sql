-- redo log重做日志关键参数
  /*
	  redo log buffer大小参数，默认16M ，最大值是4096M，最小值为1M
	*/
show variables like '%innodb_log_buffer_size%';
  /*
	  redo log文件的个数，命名方式如: ib_logfile0, iblogfile1... iblogfileN。默认2个，最大100个
	*/
show variables like '%innodb_log_files_in_group%';
  /*
	  单个redo log文件大小，默认值为48M，最大值为512G。
		注意最大值指的是整个 redo log系列文件之和
		即(innodb_log_files_in_group * innodb_log_file_size)不能大于最大值512G
	*/
show variables like '%innodb_log_file_size%';
  /*
	  redo log文件存储位置参数，默认值为"./"，即innodb数据文件存储位置
		其中的 ib_logfile0 和 ib_logfile1 即为redo log文件。
	*/
show variables like '%innodb_log_group_home_dir%';
/*
  innodb_flush_log_at_trx_commit：这个参数控制 redo log 的写入策略
	它有三种可能取值：
	  1) 设置为0：表示每次事务提交时都只是把 redo log 留在 redo log buffer 中，数据库宕机可能会丢失数据。
	  2) 设置为1(默认值)：表示每次事务提交时都将 redo log 直接持久化到磁盘，数据最安全，不会因为数据库宕机丢失数据，
		   但是效率稍微差一点，线上系统推荐这个设置。
	  3) 设置为2：表示每次事务提交时都只是把 redo log 写到操作系统的缓存page cache里，这种情况如果数据库宕机是不会丢失数据的，
		   但是操作系统如果宕机了，page cache里的数据还没来得及写入磁盘文件的话就会丢失数据。
*/
show variables like 'innodb_flush_log_at_trx_commit';
# 设置innodb_flush_log_at_trx_commit参数值(也可以在my.ini或my.cnf文件里配置)：
set global innodb_flush_log_at_trx_commit=1;

-- 查看binlog相关参数
show variables like '%log_bin%';
set @@session.sql_log_bin = 0;
# binlog写入配置
show variables like '%sync_binlog%';
# 在配置文件中的[mysqld]部分增加如下配置:
# log-bin设置binlog的存放位置，可以是绝对路径，也可以是相对路径，这里写的相对路径，则binlog文件默认会放在data数据目录下
log-bin=binlog
# Server Id是数据库服务器id，随便写一个数都可以，这个id用来在mysql集群环境中标记唯一mysql服务器，集群环境中每台mysql服务器的id不能一样，不加启动会报错
server-id=1
# 其他配置
binlog_format = row # 日志文件格式，下面会详细解释
expire_logs_days = 15 # 执行自动删除距离当前15天以前的binlog日志文件的天数， 默认为0， 表示不自动删除
binlog_expire_logs_seconds = 1296000 # 8.0推荐使用秒
max_binlog_size = 200M # 单个binlog日志文件的大小限制，默认为 1GB
-- 查看有多少binlog文件
show binary logs;
  # 刷新binlog日志
flush logs;
  # 删除binlog文件
reset master;
  # 删除000006之前的binlog文件
purge master logs to 'binlog.000006';
  # 删除指定日期的binlog文件
purge master logs before '2023-11-08 14:00:00';
-- 查看二进制binlog文件
mysqlbinlog --no-defaults -v --base64-output=decode-rows /var/lib/mysql/binlog.000001;
  # 加上时间条件
mysqlbinlog --no-defaults -v --base64-output=decode-rows /var/lib/mysql/binlog.000001 start-datetime="2023-10-21 00:00:00" stop-datetime="2023-11-08 00:00:00" start-position="5000" stop-position="20000";
-- binlog恢复数据
mysqlbinlog  --no-defaults --start-position=219 --stop-position=701 --database=sql_optimization /var/lib/mysql/binlog.000002 | mysql -uroot -p123456 -v sql_optimization;
  # 补充一个根据时间来恢复数据的命令，我们找到第一条sql BEGIN前面的时间戳标记 SET TIMESTAMP=1674833544，再找到第二条sql COMMIT后面的时间戳标记 SET TIMESTAMP=1674833663，转成datetime格式
mysqlbinlog  --no-defaults --start-datetime="2023-1-27 23:32:24" --stop-datetime="2023-1-27 23:34:23" --database=sql_optimization /var/lib/mysql/binlog.000002 | mysql -uroot -p123456 -v sql_optimization;

-- 数据库备份
mysqldump -u root 数据库名>备份文件名;   #备份整个数据库
mysqldump -u root 数据库名 表名字>备份文件名;  #备份整个表
-- 备份数据恢复
mysql -u root test < 备份文件名 #恢复整个数据库，test为数据库名称，需要自己先建一个数据库test

-- undo log回滚日志
  /*
	  innodb_undo_directory
		  设置undo log文件所在的路径。该参数的默认值为"./"，即innodb数据文件存储位置，目录下ibdata1文件就是undo log存储的位置。
		innodb_undo_logs
		  设置undo log文件内部回滚段的个数，默认值为128。
		innodb_undo_tablespaces
		  设置undo log文件的数量，这样回滚段可以较为平均地分布在多个文件中。设置该参数后，会在路径innodb_undo_directory看到undo为前缀的文件。
	*/
show variables like 'innodb_undo%'
  # 查看错误日志存放位置
show variables like '%log_error%';
  # 通用查询日志
show variables like '%general_log%';
  # 打开(一般不开)
SET GLOBAL general_log=on;