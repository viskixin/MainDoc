/*锁等待分析
  对各个状态量的说明如下：
   Innodb_row_lock_current_waits: 当前正在等待锁定的数量
	 Innodb_row_lock_time: 从系统启动到现在锁定总时间长度
	 Innodb_row_lock_time_avg: 每次等待所花平均时间
	 Innodb_row_lock_time_max：从系统启动到现在等待最长的一次所花时间
	 Innodb_row_lock_waits: 系统启动后到现在总共等待的次数
 
  对于这5个状态变量，比较重要的主要是：
	  Innodb_row_lock_time_avg （等待平均时长）
		Innodb_row_lock_waits （等待总次数）
		Innodb_row_lock_time（等待总时长）
*/
show status like 'innodb_row_lock%';

-- 查看事务
select * from information_schema.innodb_trx;
-- 查看锁，8.0之后需要换成这张表performance_schema.data_locks
# select * from INFORMATION_SCHEMA.INNODB_LOCKS;
select * from `performance_schema`.data_locks;
-- 查看锁等待，8.0之后需要换成这张表performance_schema.data_lock_waits
# select * from INFORMATION_SCHEMA.INNODB_LOCK_WAITS;
select * from `performance_schema`.data_lock_waits;

-- 释放锁，trx_mysql_thread_id可以从INNODB_TRX表里查看到
kill trx_mysql_thread_id;

-- 查看锁等待详细信息
show engine innodb status;

# [事务A1]
begin;
select * from account where id = 10 for update;
commit;

# [事务B1]
begin;
select * from account where id=1 for update;
-- 先去执行[事务B2]，再select
select * from account where id=2 for update;
commit;