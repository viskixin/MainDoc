/*隔离级别
  在5.x的版本中可以使用"tx_isolation"查看隔离级别
	8.x中的版本使用的是"transaction_isolation"
	  默认："REPEATABLE-READ"
  
  注意：测试下一个事务之前，先把当前事务提交
	   (或者每一个事务单独开个session，防止忘记提交而导致测试结果不符合预期)
*/
show variables like '%transaction_isolation%';
# 查看是否自动提交
show variables like '%autocommit%';
# 关闭自动提交(不关也不影响，begin手动开启)
set autocommit=0;

-- [事务1] → 读未提交(该隔离级别其实不需要事务)
set transaction_isolation = 'read-uncommitted';
begin;
update account set balance = balance + 500 where id = 1;
  /* 开启[读取1]事务 */
commit; -- rollback;

# [事务2] → 读已提交
set transaction_isolation = 'read-committed';
begin;
update account set balance = balance + 500 where id = 1;
  /* 开启[读取2]事务 */
commit; -- rollback;

# [事务3] → 可重复读
set transaction_isolation = 'repeatable-read';
begin;
update account set balance = balance + 500 where id = 1;
  /* 开启[读取3]事务 */
commit; -- rollback;

# [事务X] → 可重复读
set transaction_isolation = 'repeatable-read';
-- 0
begin;
select * from account;
  /*开启[事务Y]事务
	  
		注意：为了避免脏写问题，InnoDB内部有以下方案(也适用于RC隔离级别)
		  [事务X]执行过程中，如果[事务Y]对一些数据做了[insert、delete、update]并提交，此时快照读取的就不是正确数据
			但在[事务X]内，如果进行[增、删、改]操作，还是会根据[事务Y]已提交的最新数据进行操作
			且操作完之后，处理的行数据会替换掉对应快照的数据，未处理的行数据，还是刚开启事务时的快照数据
			此时再次查询，得到的数据，不符合第一次快照处理的预期值，而是符合当前最新数据处理的预期值，称为[幻读]
	  
		总结：
		  select 是快照读(历史版本)
		  insert、delete、update 是当前读(当前最新提交版本)
			read-committed 语句级快照
			repeatable-read 事务级快照
	*/
-- 1
select * from account;
-- 2
update account set balance = balance+1 where id = 1;
update account set balance = balance+1 where id = 20;
select * from account;
-- 3
commit; -- rollback;

# [事务4] → 可串行化(该隔离级别读和写不能同时进行)
set transaction_isolation = 'serializable';
begin;
	/* 若 select 之后开启[读取4]事务
	   则[读取4]可以进行读操作，但是[事务4 update]需要等待[读取4 commit]之后才能写
	*/
select * from account where id = 2;
	/* 若 update 之后开启[读取4]事务
	   则[读取4]不能进行读操作，[读取4 select]需要[事务4 commit]之后才能读
	   
	   该级别在处理读的时候，相当于在读的最后面加了读锁 select ... lock in share mode (也可以手动在以上三个事务中加上)
	   写操作默认都会加写锁，当然也可以为读加写锁，select ... for update;
	   所以该级别能解决上面所有问题，包括脏写(前三个事务都会有)
	*/
update account set balance = balance + 50 where id = 1;
commit; -- rollback;

#查询执行时间超过1秒的事务，详细的定位问题方法后面讲完锁课程后会一起讲解
SELECT * FROM information_schema.innodb_trx WHERE TIME_TO_SEC( timediff( now( ), trx_started ) ) > 1;
 
# 强制结束事务
  -- kill 事务对应的线程id(就是上面语句查出结果里的trx_mysql_thread_id字段的值)
kill 12;