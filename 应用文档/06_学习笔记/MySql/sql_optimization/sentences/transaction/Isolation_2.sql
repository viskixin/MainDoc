# 隔离级别
show variables like '%transaction_isolation%';
# 查看是否自动提交
show variables like '%autocommit%';
# 关闭自动提交(不关也不影响，begin手动开启)
set autocommit=0;

-- [读取1] → 读未提交
set transaction_isolation = 'read-uncommitted';
begin;
select * from account where id = 1;
/* 此时返回[事务1]
     
		 若[事务1][提交]后，再回来[select、commit]
		   则[commit 前后 select]读取的数据[都一致]
		 
		 若[事务1][回滚]后，再回来[select、commit]
		   则[commit 前 select]读取到[事务1][未提交]的数据，称为[脏读]
*/
select * from account where id = 1;
commit;

-- [读取2] → 读已提交
set transaction_isolation = 'read-committed';
begin;
select * from account where id = 1;
/* 此时返回[事务2]
     
		 若[事务2][提交]后，再回来[select、commit]
		   则[commit 前 不同时间段select]读取的数据[会不一致]，称为[不可重复读]
		 
		 若[事务2][回滚]后，再回来[select、commit]
		   则[commit 前后 select]读取的数据[都一致]
*/
select * from account where id = 1;
commit;

-- [读取3] → 可重复读
set transaction_isolation = 'repeatable-read';
/* 设置该隔离级别
     刚开启时，会对所有数据建一个快照，从快照中读取数据
		 这种情况下，该事务[begin]和[commit]任意时间段内，读取的数据[都一致]
*/
begin;
select * from account;
/* 此时返回[事务3]
     
		 若[事务3][提交]后，再回来[select、commit]
		   则[commit 前后 select]读取的数据[会不一致]
			 但[commit 前 任意时间段内select]读取的数据[都一致]
		 
		 若[事务2][回滚]后，再回来[select、commit]
		   则[commit 前后 select]读取的数据[都一致]的
*/
select * from account;
commit;

-- [事务Y] → 可重复读
set transaction_isolation = 'repeatable-read';
# 0
begin;
select * from account;
# 1
insert into account values (20, 'zhangsan', 777);
update account set balance = 520 where id = 1;
select * from account;
# 2 [提交]完之后，返回[事务X]
commit;

-- [读取4] → 可串行化
set transaction_isolation = 'serializable';
# 0
begin;
  -- 只针对被[增、删、改]操作的数据，其他数据还是能查的
select * from account where id = 2;
  -- 若该行有其他session在操作，则需要等待
select * from account where id = 1;
# 1
  /* 此时返回[事务4] */
# 2
commit;