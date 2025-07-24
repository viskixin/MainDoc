/*分页优化
  LIMIT 语法
	1) LIMIT OFFSET,SIZE
	2) LIMIT SIZE (相当于) LIMIT 0,SIZE (即) 从0开始，读取SIZE条数据
*/
/*以下LIMIT语句
  在InnoDB中，会从主键索引中获取 0 到 90000+5 条完整行数据，返回给server层
	然后根据 OFFSET 的值挨个抛弃，留下最后面的 SIZE 条数据，放到server层的结果集中
	即 从 90001行 到 90005行 的数据
*/
EXPLAIN SELECT * FROM employees LIMIT 90000,5;
EXPLAIN SELECT * FROM employees ORDER BY `name` LIMIT 90000,5;
  /*优化1
	  先查询出来较小的结果集，再读取前5行
	  注意：90003是表中第90000行数据，所以这种优化只对自增且连续的索引有效
	*/
EXPLAIN SELECT * FROM employees WHERE id > 90003 LIMIT 5;
  /*优化2
	  从二级索引中先筛选出符合条件的id，再关联查询
	*/
EXPLAIN SELECT * FROM employees e INNER JOIN (SELECT id FROM employees LIMIT 90000,5) ed on e.id = ed.id;
EXPLAIN SELECT * FROM employees e INNER JOIN (SELECT id FROM employees ORDER BY name LIMIT 90000,5) ed on e.id = ed.id;

/*Join关联查询优化
*/
-- 嵌套循环连接 Nested-Loop Join(NLJ) 算法
EXPLAIN SELECT * FROM t1 INNER JOIN t2 WHERE t1.a = t2.a;
-- 基于块的嵌套循环连接 Block Nested-Loop Join(BNL)算法
EXPLAIN SELECT * FROM t1 INNER JOIN t2 WHERE t1.b = t2.b;

/*驱动表：先执行的表
	小表 → 驱动表；大表(尽量走索引) → 被驱动的表
	straight_join 功能和 inner join 类似，但能让左边的表来驱动右边的表(小表驱动大表)
	但是 straight_join 不适用于 left join、right join(左右连接已经指定了表的执行顺序)
	
	注意：
	  1) 这里的小表指的是参与关联的数据集较小，不是绝对的表数据较小
		2) 一般情况下，mysql会自动优化，让小表先执行；
		   如果发现大表先执行，可自己 STRAIGHT_JOIN 语句指定
*/
-- 指定mysql选择t2表作为驱动表
EXPLAIN SELECT * FROM t2 STRAIGHT_JOIN t1 ON t2.a = t1.a;

/*in和exsits优化
  select * from A where id in (select id from B)
	等价于
		for(select id from B) {
		  select * from A where A.id = B.id;
		}
  select * from A where exists (select 1 from B where B.id = A.id)
	等价于
		for(select * from A) {
		  select * from B where A.id = B.id;
		}
  exists只返回true或false，子查询中的 select * 可以用 select 1 替换
  exists子查询过程可能经历了优化，逐条对比作为参考
  exists子查询过程可能经历了优化，逐条对比作为参考
  exists子查询往往也可以用join来代替
	
	总结：
    后面表的数据集小于前面表数据集时，in 优于 exists
    后面表的数据集大于前面表数据集时，exists 优于 in
*/
select * from t1 where a in (select a from t2);
select * from t2 where exists (select 1 from t1 where t1.a = t2.a);

/*count()查询优化
  字段有索引
	count(*)≈count(1)>count(字段)>count(主键 id)
		count(字段)统计走二级索引，二级索引存储数据比主键索引少，所以count(字段)>count(主键 id)
  字段无索引
	  count(*)≈count(1)>count(主键 id)>count(字段)
		count(字段)统计走不了索引，count(主键 id)还可以走主键索引，所以count(主键 id)>count(字段)
  
	注意：
	  count(1)跟count(有索引的字段)执行过程类似，不过count(1)不需要取出字段统计，就用常量1做统计，
		count(字段)还需要取出字段，所以理论上count(1)比count(字段)会快一点。
		
		count(*) 是例外，mysql并不会把全部字段取出来，而是专门做了优化，不取值，按行累加，效率很高，
		所以不需要用count(列名)或count(常量)来替代 count(*)。
*/
explain select count(1) from employees;
explain select count(id) from employees;
explain select count(name) from employees;
explain select count(*) from employees;
-- 可看维护的Rows列，但不是特别准确
show table status like 'employees';