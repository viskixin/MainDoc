/*表锁
  每次操作锁住整张表。开销小，加锁快；不会出现死锁；
	锁定粒度大，发生锁冲突的概率最高，并发度最低；一般用在整表数据迁移的场景
  lock table 表名 read(write),表名称2 read(write);
*/
start transaction;
lock table account write; -- read;
commit;
-- 查看表上加过的锁 → In_use：表示是否被加锁  Name_locked：表示表名是否被加锁
show open tables;
-- 删除表锁
unlock tables;

/*页锁
  只有BDB存储引擎支持页锁，在每个叶子节点上，对该叶子节点上的所有索引加锁
	页锁的开销介于表锁和行锁之间，会出现死锁。锁定粒度介于表锁和行锁之间，并发度一般
	锁定的数据资源比行锁要多，因为一个页中可以有多个行记录。当我们使用页锁的时候，会出现数据浪费的现象
*/

/*行锁
  每次操作锁住一行数据。开销大，加锁慢；会出现死锁；
	锁定粒度最小，发生锁冲突的概率最低，并发度最高
	
	注意：
	  InnoDB的行锁实际上是针对索引加的锁(在索引对应的索引项上做标记)，不是针对整个行记录加的锁
	  并且该索引不能失效，否则会从行锁升级为表锁(RR级别会升级为表锁，RC级别不会升级为表锁)
	原因：
	  1) RR级别下，MySQL设置了间隙锁，如果有索引，可利用索引确定范围，从而范围加锁；
		 如果没有索引，在确定范围之前，则需要先对查找的对索引在内存进行排序；
		 因此可能不如直接将整张表锁住，操作完再释放锁来的效率快。
	  2) RC级别下，MySQL没有设置间隙锁，则不会根据索引去扫描一个区间，所以自然不用进行排序；
		 因此在查询索引失效时，MySQL会尝试使用其他可用的索引来完成查询，而不会立即升级为表锁；
		 如果其他索引仍无法完成查询，则会升级为表锁。
*/
set transaction_isolation = 'read-committed';
-- set transaction_isolation = 'repeatable-read';
begin;
  /*
	  where条件里的id字段是索引：其他事务无法修改该条记录，但是可以修改其他记录
	  不加 for update，会生成一个临时事务，当往下执行加锁操作时，临时事务会消失，显示真实事务
	*/
select * from account where id = 1;
select * from account where id = 1 for update;
  /*
	  where条件里的name字段无索引，当其他事务对该表进行操作时
		  RR级别下：会加表锁
		  RC级别下：会尝使用可用的索引行锁(比如上面的主键行锁)
	*/
select * from account where name = 'lilei' for update;
commit;

/*总结
  MyISAM在执行查询语句SELECT前，会自动给涉及的所有表加读锁，在执行update、insert、delete操作会自动给涉及的表加写锁。
	InnoDB在执行查询语句SELECT时(非串行隔离级别)，不会加锁。但是update、insert、delete操作会加行锁。
	另外，读锁会阻塞写，但是不会阻塞读。而写锁则会把读和写都阻塞。
*/

/*锁分类
  1) 从性能上，分为乐观锁(用版本对比或CAS机制)和悲观锁
	   乐观锁适合读操作较多的场景，悲观锁适合写操作较多的场景，如果在写操作较多的场景使用乐观锁会导致比对次数过多
  2) 从对数据操作的粒度上，分为表锁、页锁、行锁
  3) 从对数据库操作的类型上，分为读锁和写锁(都属于悲观锁)，还有意向锁
  4) 间隙锁(Gap Lock)
	   锁的就是当前操作索引左右区间内的空隙，间隙锁是在RR隔离级别下才会生效。
	   Mysql默认级别是repeatable-read，有幻读问题，间隙锁是可以解决幻读问题的。
	
	意向锁介绍：
	  当有事务给表的数据行加了共享锁或排他锁，同时会给表设置一个标识，代表已经有行锁了，
	  他事务要想对表加表锁时，就不必逐行判断有没有行锁可能跟表锁冲突了，直接读这个标识就可以确定自己该不该加表锁。
	意向锁主要分为：
	  意向共享锁，IS锁，对整个表加共享锁之前，需要先获取到意向共享锁。
	  意向排他锁，IX锁，对整个表加排他锁之前，需要先获取到意向排他锁。
*/

-- 读锁（共享锁，S锁(Shared)）：针对同一份数据，多个读操作可以同时进行而不会互相影响，比如：
start transaction;
select * from account where id=1 lock in share mode;
commit;

-- 写锁（排它锁，X锁(eXclusive)）：当前写操作没有完成前，它会阻断其他写锁和读锁，数据修改操作都会加写锁，查询也可以通过for update加写锁，比如：
begin; -- start transaction; 的简写
select * from account where id=1 for update;
commit;
  /*间隙锁：假设有以下数据，操作行id=18，那么间隙为 (10,20)，而 (3,10) 和 (20,+∞) 这两个区间不会被锁住
	  |id |name    |balance|
		|---|--------|-------|
		|1  |lilei   |3,250  |
		|2  |hanmei  |16,000 |
		|3  |lucy    |2,400  |
		|10 |zhuge   |666    |
		|20 |zhangsan|777    |
	*/
-- set transaction_isolation = 'repeatable-read';
begin;
select * from account where id = 18 for update; -- 对 (10,20) 区间内加间隙锁
select * from account where id = 22 for update; -- 对 (20,+∞) 区间内加间隙锁
commit;