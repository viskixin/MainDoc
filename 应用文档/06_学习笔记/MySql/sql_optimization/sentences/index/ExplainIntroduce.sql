/*索引前言
	添加索引：
						alter table 表名 add primary key (列名);
						alter table 表名 add index 索引名(列名);
						alter table 表名 add unique 索引名(列名);
	删除索引：
						alter table 表名 drop primary key;
						alter table 表名 drop index 索引名;  或者  drop index 索引名 on 表名;
	
	索引概念
		主键索引 | 一级索引 | 聚簇索引    → 叶子节点存储索引和数据
		  联合主键索引(聚簇)				      → add primary key(column_x,column_y,column_z)
		辅助索引 | 二级索引 | 非聚簇索引  → 叶子节点存储的数据是主键
		  普通索引(允许重复元素)			    → add index xxx_index(column_x)
		  唯一索引(不允许重复元素)		    → add unique yyy_unique(column_y)
			前缀索引
			  前缀普通索引							    → add index xxx_index(column_x(6))
				前缀唯一索引							    → add unique yyy_unique(column_y(7))
			联合普通索引(非聚簇)			      → add index xxx_index(column_x,column_y,column_z)
			联合唯一索引(非聚簇)			      → add unique xxx_index(column_x,column_y,column_z)
	
	回表查询：[二级索引]返回[一级索引]查询数据
	二级索引覆盖(注意事项)
	  1) 索引有效
		   若[二级索引]包含[需要查询的字段]，则优先使用二级索引，[不用][回表查询] (一级索引数据比较大，读取没二级索引快)
			 若[二级索引][不完全]包含[需要查询的字段]，先根据二级索引[筛选出符合条件]的[叶子节点]，[获取主键值]后[回表查询]
		2) 索引失效
			 [只能][回表查询]
	说明：
	  [二级索引]的[结构]包含[索引字段值]和[主键地址]
		[一级索引]决定了[表中记录]的[物理存储顺序]，包含[表的全部数据]
	注意：
	  主键索引一定是唯一索引，唯一索引不一定是主键索引
		在 InnoDB 存储引擎中，联合主键默认情况下也会被作为聚簇索引
	
	索引失效参考：https://blog.csdn.net/qq_45912025/article/details/130404195
*/

/*explain前言
	5.7版本之前
	  explain extended xxx;			-- 会在 explain 的基础上额外提供一些查询优化的信息，额外还有 filtered 列
	  show warnings;						-- 紧随其后通过 show warnings 命令可以得到优化后的查询语句，从而看出优化器优化了什么
	  
		explain partitions xxx;		-- 相比 explain 多了个 partitions 字段，如果查询是基于分区表的话，会显示查询将访问的分区
	
	5.7版本之后
	  explain xxx;							-- 直接 explain
	
	官方参考文档：https://dev.mysql.com/doc/refman/5.7/en/explain-output.html
*/

/*explain各列详解
	select_type 列
		1) simple		简单查询。查询不包含子查询和union
		2) primary	复杂查询中最外层的 select
		3) subquery	包含在 select 中的子查询（不在 from 子句中）
		4) derived	包含在 from 子句中的子查询。MySQL会将结果存放在一个临时表中，也称为派生表（derived的英文含义）
	type 列
	  从最优到最差分依次为：system > const > eq_ref > ref > range > index > ALL
	possible keys 列
	  推测可能使用的索引
	key 列
	  实际使用的索引
	key_len 列 → 计算规则如下
	  字符串
		  char(n) : n字节长度
			varchar(n) : 如果是 utf-8，则长度 3n+2 字节，加的2个字节用来存储字符长度
			             如果是 utf8mb4，则长度 4n+2 字节
	  数值
		  tinyint : 1字节
			smallint : 2字节
			int : 4字节
			bigint : 8字节
		时间
		  date : 3字节
			timestamp : 4字节
			datetime : 8字节
		如果(字段允许为 NULL)，(需要1字节)记录是否为 NULL
		索引最大长度是768字节，当字符串过长时，mysql会做一个类似左前缀索引的处理，将前半部分的字符提取出来做索引。
	rows 列 → 预估连接行数
		  (rows * filtered/100) 可以估算出将要和 explain 中前一个表进行连接的行数
	Extra 列 → 展示索引额外信息
*/
# 1 * 100.00/100 = 1 条连接行数
explain select * from film where id = 1;
# explain 和 show warnings 一起执行，结果2 会有sql优化
explain select * from film where id = 1;
show warnings;	-- select '1' AS `id`,'film1' AS `name` from `sql_optimization`.`film` where true

/*关闭合并优化，开始测试
	id		select type		table
	1			PRIMARY				<derived3> 对应id为3的衍生表
	3			DERIVED				film
	2			SUBQUERY			actor
	注意：id越大优先级越高，先被执行
*/
show variables like 'optimizer_switch';
# 关闭mysql5.7新特性对衍生表的合并优化
set session optimizer_switch='derived_merge=off';
# 还原默认配置
set session optimizer_switch='derived_merge=on';
-- test
explain select (select 1 from actor where id = 1) from (select * from film where id = 1) der;
-- table为NULL表示 mysql能够在优化阶段分解查询语句，在执行阶段用不着再访问表或索引
explain select min(id) from film;

/*
-- type等级
	system	查询表的[结果集]只有[一行记录] (const的特例)
	const		[查询条件]是[主键]，且只有[一行结果] (像查询常量一样)
	eq_ref	[连接查询]，[关联表]的[条件]使用了[主键索引]进行[关联匹配]
	ref			[连接查询]，[关联表]的[条件]使用了[辅助索引]进行[关联匹配]
	range		[索引]进行[范围扫描]
	index		[二级索引]进行[全表扫描]
	ALL			[二级索引 失效]，并且需要[查询 全部结果集]，从[一级索引全表扫描]
	
	建议：一般来说，得保证查询达到range级别，最好达到ref
*/
# system、const
-- explain select * from film where id = 1;
explain select * from (select * from film where id = 1) tmp;
show warnings;	-- select '1' AS `id`,'film1' AS `name` from dual
# eq_ref
  /* 注意：有[join]语句，先不看[原来 SQL]的[字段]，先看[拆分的 SQL]
	   fa 作为驱动表
		 explain select fa.id,film_id from film_actor AS fa; -- where fa.film_id = fm.id
		 explain select fa.id,film_id,remark from film_actor AS fa; -- where fa.film_id = fm.id
	      查询条件 [不是一个精确值] → 需要[fa 全表查询]
				查询字段 [fa.id,film_id 未超出 fa 二级联合索引] → 可用[二级索引]进行[全表查询] → index
				         [fa.id,film_id,remark 超出 fa 二级联合索引] → 只能[一级索引]进行[全表查询] → ALL
	   
		 fm 作为 fa 的 被驱动表
		 explain select * from film fm where fm.id = 1 -- (= fa.film_id)
	      查询条件 [fm.id 为 一级索引] → 依赖[fa 查询结果集]
		    查询字段 [未指定 默认 使用主键索引] → 直接用[一级索引]进行[关联匹配] → eq_ref
	*/
explain select fa.id,film_id from film_actor fa inner join film fm on fa.film_id = fm.id;
explain select fa.id,film_id,remark from film_actor fa inner join film fm on fa.film_id = fm.id;
  /* fa 作为驱动表
		 explain select fa.id,actor_id from film_actor AS fa; -- where fa.actor_id = fm.id
	      查询条件 [不是一个精确值] → 需要[fa 全表查询]
				查询字段 [fa.id,actor_id 未超出 fa 二级联合索引] → 可用[二级索引]进行[全表查询] → index
	   
		 fm 作为 fa 的 被驱动表
		 explain select * from film fm where fm.id = 1 -- (= fa.actor_id)
	      查询条件 [fm.id 为 一级索引] → 依赖[fa 查询结果集]
		    查询字段 [未指定 默认 使用主键索引] → 直接用[一级索引]进行[关联匹配] → eq_ref
	*/
explain select fa.id,actor_id from film_actor fa inner join film fm on fa.actor_id = fm.id;
# ref
explain select * from film where name = 'film1'; -- [一级索引]关联匹配[film]的[二级索引 idx_name]
  /* fm 作为第1个驱动表
	   explain select fm.id from film AS fm; -- where fm.id = fa.film_id
	      查询条件 [不是一个精确值] → 需要[fm 全表查询]
				查询字段 [fm.id 为主键 被 fm 二级索引(age) 包含] → 可用[二级索引]进行[全表查询] → index
	   
		 fa 作为第2个驱动表
		    explain select film_id,fa.actor_id from film_actor fa where fa.film_id = 1; -- (= fm.id)
		    查询条件 [fa.film_id 为 二级联合索引 的 部分前缀] → 依赖[fm 查询结果集]
				查询字段 [film_id,fa.actor_id 未超出 fa 二级索引覆盖] → 可用[二级索引]进行[关联匹配] → ref
	   
		 ac 作为 fa 的 被驱动表
		    explain select * from actor ac where ac.id = 2; -- (= fa.actor_id)
		    查询条件 [ac.id 为 一级索引] → 依赖[fa 查询结果集]
		    查询字段 [未指定 默认 使用主键索引] → 直接用[一级索引]进行[关联匹配] → eq_ref
	*/
explain select film_id from film fm left join film_actor fa on fm.id = fa.film_id left join actor ac on fa.actor_id = ac.id;
  /* fa 作为第1个驱动表
	   explain select fa.film_id,fa.actor_id from film_actor AS fa; -- where fa.actor_id = ac.id、fm.id = fa.film_id
	      查询条件 [不是一个精确值] → 需要[fa 全表查询]
				查询字段 [fa.film_id,fa.actor_id 未超出 fa 二级联合索引] → 可用[二级索引]进行[全表查询] → index
	   
		 ac 作为 fa 的 被驱动表
		 explain select * from actor ac where ac.id = 2; -- (= fa.actor_id)
		    查询条件 [ac.id 为 一级索引] → 依赖[fa 查询结果集]
		    查询字段 [未指定 默认 使用主键索引] → 直接用[一级索引]进行[关联匹配] → eq_ref
		 
		 fm 作为 fa 的 被驱动表
		 explain select * from film fm where fm.id = 1 -- (= fa.film_id)
	      查询条件 [fm.id 为 一级索引] → 依赖[fa 查询结果集]
		    查询字段 [未指定 默认 使用主键索引] → 直接用[一级索引]进行[关联匹配] → eq_ref
	*/
explain select film_id from film fm inner join film_actor fa on fm.id = fa.film_id left join actor ac on fa.actor_id = ac.id;
# range
explain select * from actor where id > 1;
explain select * from film_actor where film_id > 1;
# index
explain select id,`name` from film;  -- [二级索引]进行[全表扫描]
# 如果给 film 表，加一列 age，但不建索引(有索引的话，需要先删除，再测试)
-- alter table film drop index `idx_age`;
explain select id,`name`,age from film where name='film2';  -- 不用回表查询
explain select id,`name`,age from film where age = 1; -- 需要回表查询
# ALL
explain select * from actor;
-- key_len 表示使用到的索引类型的大小，以下用到了联合索引的一个索引，其为大整形，大小为8个字节
explain select * from film_actor where film_id = 2;
-- 使用了两个索引，一个大整形，一个整形，共12个字节
explain select * from film_actor where film_id = 2 and actor_id = 1;

/*
-- Extra解释
  Using index										where条件[是索引]的[前导列] → [无需回表]的[等值查询]
	                              索引[完全覆盖]所需的[查询条件]，直接从[二级索引]中查找数据
	
	Using where; Using index			where条件[是索引]的[前导列] → [无需回表]的[范围查询]
	                              索引[部分覆盖]所需的[查询条件]，还需要额外[WHERE子句]来[过滤结果]
  
	Using where										where条件[不是索引]的[前导列] → [需要回表]的[范围查询]
	                              索引[部分覆盖]所需的[查询条件]，还需要额外[WHERE子句]来[过滤结果]
  
	Using index condition					where条件[是索引]的[前导列] → [需要回表]的[范围查询]
	                              在[Using where]之上做了优化，[部分索引失效]使用[索引下推]
  
	NUlL													查询可能是简单的或未使用索引，可能导致全表扫描，性能较低
  
	Using temporary								mysql需要[创建一张临时表]来[处理查询]，没有使用索引(有索引的字段分组、去重 就不会产生临时表)
																出现这种情况一般是要进行优化的，首先是想到用索引来优化
  
	Using filesort								将用[外部排序]而不是[索引排序]，数据较小时[从内存排序]，否则需要在[磁盘完成排序]。
																这种情况下一般也是要考虑使用索引来优化的
  
	Select tables optimized away	使用某些[聚合函数(max、min、...)]来访问存在索引的某个字段时
  
	Using intersect()							[取交集](多个字段的复杂查询中，可以从多个索引中获取更多的信息，加速查询过程)
	
	(索引的)前导列
	  1) 联合索引 → 语句的第一列或者连续的多列
	     比如 → index idx_xyz on table(x, y, z)，则 x、xy、xyz 都是前导列
	  2) 其他索引 → 自身索引列
	注意：判断前导列需进行带入操作，分清楚当前查找操作 是在一级索引 还是在二级索引
*/
# Using index
explain select id,age from film where age = 1; -- 二级索引[idx_age]，age 是前导列
explain select id,film_id,actor_id from film_actor where film_id = 1;  -- 二级索引[idx_film_actor_id]，film_id 是前导列
# Using where; Using index
  /*
	  此时[查询条件 actor_id]不满足[最左匹配]，缺失的[查询条件 film_id]，即便[回表查询]，也[无法利用索引]
		但是[查询字段]满足[索引覆盖]，意味着[不用回表][也能查到所需字段]，不如利用[联合索引 film_id,actor_id]
		由于[actor_id]在[每个 film_id 之下，都有可能 = 1]，所以[film_id]的查询范围是[全表]
		
		部分所需的[查询条件 actor_id]，还需要额外的[范围条件 film_id]来[过滤结果]
	*/
explain select id,film_id,actor_id from film_actor where actor_id = 1;
  /*
	  部分所需的[查询条件 film_id]，还需要额外的[范围条件 actor_id]来[过滤结果]
	*/
explain select id,film_id,actor_id from film_actor where film_id = 1 and actor_id > 1;
  /*
	  [范围条件 film_id]
	*/
explain select id,film_id,actor_id from film_actor where film_id > 1;
# Using where
explain select name from actor where name = 'a'; -- name 没有索引，不是前导列 (回到一级索引 全表查询)
explain select id,film_id,remark from film_actor where actor_id > 1; -- actor_id 不是前导列 (回到一级索引 全表查询)
# Using index condition
  /*
	  查询的(id,film_id,remark)列中，remark未被覆盖
		索引下推
		此时在二级索引[idx_film_actor_id]中，where 先确定范围，再根据二级索引 film_id 筛选出结果集
			查询的(id,film_id,actor_id,remark)列中，remark未被覆盖，所以这些列不完全被索引覆盖，需要回表查询
	*/
explain select id,film_id,remark from film_actor where film_id > 1;
  /*
	    在二级索引[idx_title_price]中，where 先根据 title 确定右侧索引 price 有序
			接着确定 price 范围，再根据 price 筛选出结果集，需要回表查询
	*/
explain select id,title,price,description from course where title = '高等数学' and price > 666;
# NUlL
  -- 二级索引先查询，film_id 是前导列，索引不包含remark，需要回表查询
explain select id,film_id,remark from film_actor where film_id = 1;
  -- 没有二级索引条件，直接查的一级索引，id 是前导列
explain select id,film_id,remark from film_actor where id = 1;
  -- 二级索引[idx_hire_time]先查询，hire_time 是前导列，索引不包含position，需要回表查询
explain select id,position,hire_time from employees where hire_time = '2023-10-26 19:48:01';
# Using temporary
  -- actor.name没有索引，此时创建了张临时表来distinct
explain select distinct ac.`name` from actor ac;
  -- actor.name没有索引，此时创建了张临时表来group by
explain select ac.`name` from actor ac group by ac.`name`;
  -- film.name建立了idx_name索引，此时查询时extra是using index,没有用临时表
explain select distinct fm.`name` from film fm;
explain select fm.`name` from film fm group by fm.name;
# Using filesort
  -- actor.name未创建索引，会浏览actor整个表，保存排序关键字name和对应的id，然后排序name并检索行记录
explain select * from actor order by name;
  -- film.name建立了idx_name索引，可利用索引树的顺序取数据
explain select id,name from film order by name;
  -- name索引不包含所有查询字段，条件范围是整张表，需要回到一级索引全表扫描，(一级索引无法利用name)所以需要外部排序
explain select id,name,age from film order by name;
  -- 利用name索引
explain select id from film order by name;
# Select tables optimized away
explain select min(id) from film;
# Using intersect(idx_film_actor_id,PRIMARY); Using where 取交集
explain select * from film_actor where id > 1 and (film_id = 1 and actor_id = 1);

/*
  索引实践
*/
-- 1.全值匹配
explain select * from employees where name = 'LiLei';
explain select * from employees where name = 'LiLei' and age = 22;
explain select * from employees where name = 'LiLei' and age = 22 and position ='manager';
-- 2.最左前缀法则
explain select * from employees where name = 'Bill' and age = 31;
explain select * from employees where age = 30 and position = 'dev';
explain select * from employees where position = 'manager';
-- 3.不在索引列上做任何操作（计算、函数、（自动or手动）类型转换），会导致索引失效而转向全表扫描
explain select * from employees where name = 'LiLei';
explain select * from employees where left(name,3) = 'LiLei';
# 给hire_time增加一个普通索引
alter table `employees` add index `idx_hire_time` (`hire_time`) using btree;
  -- 使用 函数，使得与字段类型不匹配，不会走索引
explain select * from employees where date(hire_time) = '2018-09-30';
  -- 使用 比较运算符，会走索引(由于日期具有固定的格式，MySQL可以将其转换为数字进行比较，因此日期字段条件查询给字符串时也可以走索引)
explain select * from employees where hire_time = '2023-10-26 19:48:01';
explain select * from employees where hire_time >='2023-10-26 00:00:00' and hire_time <='2023-10-26 23:59:59';
  -- 如果数据量比较大的情况，且二级索引需要回表查询，不如直接从一级索引查找。如果数据量过小，可能会先走索引，再回表查询，如上所示
explain select * from employees where hire_time >='2018-09-30 00:00:00' and hire_time <='2023-10-31 23:59:59';
  -- int类型字段，条件查询给字符串时，实际上是将字符串转换成数字进行比较，如果字符串可以被转换成数字，MySQL会自动进行类型转换，并走索引
explain select * from employees where name = 'LiLei' and age = '22';
# 还原最初索引状态
alter table `employees` drop index `idx_hire_time`;
# 假设给 film 表，加一列 phone，且建立索引
alter table film add phone varchar(11);
alter table `film` add index `idx_phone`(`phone`) using btree;
  -- string类型字段，条件查询给数字时，MySQL会做隐式的类型转换，把它们转换为浮点数再做比较，自然索引会失效
explain select * from film where name = 'LiLei' or phone = 15001877572;
  -- 与索引类型匹配，索引不会失效
explain select * from film where name = 'LiLei' or phone = '15001877572';
# 还原最初索引状态
alter table film drop index idx_phone;
alter table film drop column phone;
-- 4.范围条件 → 索引失效
  /*
	  联合索引：索引从左到右依次排序
		  每一个索引都是确定的(name排完，在底下排age；age排完，在底下排position)
			在一个确定的name下，age有序；在一个确定的age下，position有序
			此时索引都能用到
	*/
explain select * from employees where name = 'LiLei' and age = 22 and position ='manager';
  /*
	  联合索引：右侧索引失效
	    此时在一个确定的name下，age有序；
			不过age是一个范围，每一个确定的age下，position有序，但一个范围内的age，无法保证position有序
			所以position索引失效
	*/
explain select * from employees where name = 'LiLei' and age > 22 and position ='manager';
-- and 和 or 失效情况
# 假设给 film 表，加一列 age，且建立索引
alter table film add age int;
alter table `film` add index `idx_age` (`age`) using btree;
  /*联合索引的情况下
	  or导致索引失效，虽然name可以使用索引，但是or表示age不一定在name条件下
		此时需要全表扫面，索引失效
	*/
	-- 二级索引全表扫描
explain select id,name,age from employees_copy where name = 'LiLei' or age = 22;
explain select id,name,age from employees where name = 'LiLei' or age = 22;
  -- 又要回表，所以不如直接一级索引全表扫描
explain select * from employees_copy where name = 'LiLei' or age = 22;
explain select * from employees where name = 'LiLei' or age = 22;
  /*普通索引的情况下的 索引选择
		and其实不会导致索引失效，以下and是由于索引优化没有选择，并非无法利用
		执行发现连接行数较多，只用索引[idx_name]，筛选主键值，返回一级索引查找 比 读取两个索引再取交集，然后回表查询的效率快
		所以，放弃使用索引[idx_age]
	*/
explain select * from film where name = 'film1' and age = 22;
  -- 强制使用索引[idx_age]
explain select * from film force index (idx_age) where name = 'film1' and age = 22;
  -- 强制使用索引[idx_name,idx_age]，发现[idx_name]回表查询更快(一级索引name顺序在age前)
explain select * from film force index (idx_name,idx_age) where name = 'film1' and age = 22;
  -- 原理同上
explain select * from film force index (idx_age,idx_name) where age = 22 and name = 'film1';
  /*普通索引的情况下的 索引交集处理
	  连接数行数较少时，可看出and并没有让索引失效
		以下发现，用两个索引交集，再返回一级索引中查询，效率更快
		所以两个索引都用到了
		select name from film GROUP BY name HAVING count(1) >= 2;
	*/
	-- name rows:2、age rows:83，取完交集后 rows:1
explain select * from film where name = 'film10033' and age = 28;
explain select * from film where age = 28 and name = 'film10033';
  -- 连接行数较多，不如一级索引全表查询
explain select * from film where name like 'film%' and age > 28;
  /*普通索引的情况下的 索引并集处理
		连接数行数较少时，可看出or并没有让索引失效
		以下发现，用两个索引并集，再返回一级索引中查询，效率更快
	*/
  -- name rows:2、age rows:83，取完并集后 rows:85
explain select * from film where name = 'film10033' or age = 28; -- 结果有84个
  -- t1 与 t2 有1条重复的数据，(2+83)-1 = 84个
select * from film where name = 'film10033'; -- 2个
select * from film where age = 28; -- 83个
select * from (select * from film where name = 'film10033') t1 join (select * from film where age = 28) t2 on t1.id = t2.id;
  -- 原理同上
explain select * from film where name = 'film10033' or age > 110;
  -- 连接行数较多，不如一级索引全表查询
explain select * from film where name = 'film10033' or age > 28;
  /*where后 跟着主键
	    由于任何索引中都有主键信息，查询时以and后面的索引为主
	*/
	 -- 直接看作是对联合索引的操作，筛选出符合条件的主键值后，回表查询
explain select * from employees where id >= 1 and (name = 'LiLei' and age = 22);
explain select * from employees where id > 99999 and (name = 'LiLei' and age = 22);
explain select * from employees where id > 99999 and (name = 'LiLei' and age > 22);
  /*where后 跟着主键
	  由于or的两个索引分别独立，联合索引操作玩之后，主键索引的值也有可能满足，所以需要并集处理
	*/
	-- 数据量大的时候，先从二级索引中筛选出主键值，然后返回一级索引，利用主键索引查询信息
explain select * from employees where id > 4 or (name = 'LiLei' and age = 22);
  -- 数据量小的时候，发现直接从一级索引全表扫描更快，索引失效
explain select * from employees_copy where id > 4 or (name = 'LiLei' and age = 22);
  # where后为主键，由于不用回表查询，可直接查询二级索引，但是二级索引主键无规则，主键索引失效
explain select id,name,age from employees where id > 1 or (name = 'LiLei' and age = 22);
# 还原最初索引状态
alter table film drop index idx_age;
alter table film drop column age;
-- in 和 or 失效情况
  # 如果in导致了匹配行过多，有可能全表扫描，从而索引失效(也有可能匹配行过少，全表扫面，从而索引失效 → 主要看cost时间，哪个更短)
explain select * from employees where name in ('LiLei','HanMeimei','Lucy') and age = 22 and position ='manager';
explain select * from employees_copy where name in ('LiLei','HanMeimei','Lucy') and age = 22 and position ='manager';
  # not in 同理
explain select * from employees where name not in ('LiLei','HanMeimei','Lucy') and age = 22 and position ='manager'; -- ALL
explain select * from employees_copy where name not in ('LiLei','HanMeimei','Lucy') and age = 22 and position ='manager';
  # or 同理
explain select * from employees where (name = 'LiLei' or name = 'HanMeimei') and age = 22 and position ='manager';
explain select * from employees_copy where (name = 'HanMeimei' or name = 'Lucy') and age = 22 and position ='manager';
-- 5.尽量使用覆盖索引[只访问索引的查询(索引列包含查询列)]，减少 select * 语句
explain select name,age from employees where name = 'LiLei' and age = 23 and position = 'manager';
-- 6.mysql在使用不等于（!=或者<>），not in ，not exists 的时候无法使用索引会导致全表扫描(如果数据量比较大的情况)
explain select * from employees where name != 'LiLei';
-- 7.is null,is not null 一般情况下也无法使用索引
explain select * from employees where name is null;
-- 8.like以通配符开头（'$abc...'）mysql索引失效会变成全表扫描操作
explain select * from employees where name like '%Lei';
explain select * from employees where name like 'Lei%';
#  解决like'%字符串%'索引不被使用的方法？
  -- a）使用覆盖索引，查询字段必须是建立覆盖索引字段
explain select name,age,position from employees where name like '%Lei%';
  -- b）如果不能使用覆盖索引则可能需要借助搜索引擎
-- 9.字符串不加单引号索引失效
explain select * from employees where name = '1000';
explain select * from employees where name = 1000;
-- 10.少用 or 或 in，用它查询时，mysql不一定使用索引，mysql内部优化器会根据检索比例、表大小等多个因素整体评估是否使用索引，详见范围查询优化
explain select * from employees where name = 'LiLei' or name = 'HanMeimei';
-- 11.范围查询优化
# 给年龄添加单值索引
alter table `employees` add index `idx_age` (`age`) using btree;
  /*没走索引原因：
		mysql内部优化器会根据检索比例、表大小等多个因素整体评估是否使用索引。
		比如这个例子，可能是由于单次数据量查询过大导致优化器最终选择不走索引(如果数据量比较大的情况)
	*/
explain select * from employees where age >=1 and age <=16000;
  /*
		优化方法：可以将大的范围拆分成多个小范围
	*/
explain select * from employees where age >=1 and age <=8000;
explain select * from employees where age >=8001 and age <=16000;
# 还原最初索引状态
alter table `employees` drop index `idx_age`;
-- 范围查询索引失效
explain select * from employees where name = 'LiLei' and age > 22 and position ='manager';
explain select * from employees where name = 'LiLei' and age >= 22 and position ='manager';
  # 不走索引
explain select * from employees where name > 'LiLei' and age = 22 and position ='manager';
  # 强制走索引
explain select * from employees force index (idx_name_age_position) where name > 'LiLei' and age = 22 and position ='manager';
# 8.0版本之后不再支持查询缓存
show variables like '%query_cache%';
# 8.0版本之前 关闭查询缓存
set global query_cache_size=0;
set global query_cache_type=0;
-- 走索引不一定快，如下所示
  # 不走索引 运行时间 → 0.721s
select * from employees where name > 'LiLei';
  # 强制走索引 运行时间 → 0.846s
select * from employees force index (idx_name_age_position) where name > 'LiLei';
  # 查询字段最好被覆盖索引包含 运行时间 → 0.634s
select id,`name`,age,position from employees where name > 'LiLei';

/*索引下推
  例如 course 表中的联合索引 (title,price)
	explain select id,title,price,description from course where title like '高%' and price = 999;
    5.6之前
		  若部分索引失效，失效的索引不会继续查找；拿到主键值，回表查询；拿到完整行数据，再筛选符合的条件
			title 最左匹配
			
    5.6之后
		  在未失效索引中，继续进行条件筛选，拿到符合条件的主键值，回表查询
*/
/* 查询各种操作的值 */
show variables like '%optimizer_switch%';
/* 关闭索引下推 */
SET optimizer_switch = 'index_condition_pushdown=off';
/* 开启索引下推 */
SET optimizer_switch = 'index_condition_pushdown=on';
/*字符串在索引中的存储逻辑
	  将字符串逐一转换成 ASCII 值，按照字母先后顺序先排好序，再存储
	
	比较符号 > 大于指的是当前字母之后的值。如：AB < ABC < AC < B < ... < Z，规则如下
	  AB 和 ABC	→ 第一位[A=A] 第二位[B=B] 第三位[''<C]	则 AB < ABC
		ABC 和 AC	→ 第一位[A=A] 第二位[B<C]								则 ABC < AC
		AC 和 B		→ 第一位[A<B]														则 AC < B
	通配符 % 表示匹配任意多个字符
	  'str%'	→ 以str开头，后面任意多个字符
	  '%str'	→ 以str结尾，前面任意多个字符
	  '%str%'	→ str再中间，两边任意多个字符
	通配符 _ 有几个下划线，就表示匹配几个字符
	  'str__'		→ 以str开头，后面2个字符
	  '___str'	→ 以str结尾，前面3个字符
	  '_str_'		→ str再中间，前后各1各字符
  select * from course_copy where title > 'ABC';
  select * from course_copy where title like 'AB%';
  select * from course_copy where title like 'AB_';
*/
  # >= 查找，发现比 LiLei 大的值太多，还要回表查询，不如直接全表扫描
explain select * from employees where name >= 'LiLei' and age = 22 and position ='manager';
  # like 模糊查询，匹配以 LiLei 开头的字符串，部分索引失效，引发索引下推
explain select * from employees where name like 'LiLei%' and age = 22 and position ='manager';
explain select * from employees_copy where name like 'LiLei%' and age = 22 and position ='manager';

/*
  查看执行计划详情
*/
# 开启trace
set session optimizer_trace="enabled=on",end_markers_in_json=on;
  -- 以下两个一起运行
explain select * from employees where name > 'a';
select * from information_schema.optimizer_trace;
  -- 复制运行[结果2]的[TRACE字段值]
explain select * from employees where name > 'zzz';
select * from information_schema.optimizer_trace;
# 关闭trace
set session optimizer_trace="enabled=off";

/*常见sql深入优化
	简述下索引失效(个人总结)：
	  索引失效，只是不能利用[前一个索引]来确定[后一个索引]的一个等值区间
		假设有联合索引 (name,age,position) 有以下查询条件
		  1) where age=? and position=?
			  由于少了name条件，age可能在任意一个name下足age=?
				由于age不确定，可能有很多个，position也可能在任意一个age下满足position=?
				所以 name、age、position 都失效
			2) where name=? and position=?
			  由于少了age条件，position可能在name=?下的任意一个age下满足position=?
				所以 age、position 都失效
			3) where name=? and age>? and position=?
			  由于age是一个范围，position可能在age范围内任意一个下面满足position=?
				所以 position 失效
	索引存储的顺序，是创建时就确立的，索引失效只是影响索引的查找效率，不影响索引的顺序
*/
-- Order by与 Group by
# Order by
  /*
	  employees 中联合索引为 (name,age,position)
	  在一个确定的name下，age存储是有序的，在每一个age下，position是有序的
	*/
	-- 最后一个是等值条件，每一个position = 'manager' 上面的age区间，都是按照顺序存储的，age自然可以利用索引
explain select * from employees where name = 'Lucy' and position ='manager' order by age;
  -- 所以此时 age、position 都可以利用索引
explain select * from employees where name = 'Lucy' and position ='manager' order by position,age;
	-- 但如果缺少等值条件的话，虽然age是有序的，只能确定每个age等值区间下position的有序，不能确定所有position有序
explain select * from employees where name = 'Lucy' order by age;
explain select * from employees where name = 'Lucy' order by position;
  /*
	  employees_copy2 中联合索引为 (name,age,position,address)
		等值查找：最后一个等值(注意等值也有可能是一个范围，只不过范围内的值都相等)条件，紧挨着的右侧索引，是按照顺序存储的
		          判断排序是否能利用索引时，where后 截止到最后一个等值条件，这些条件在排序时可以忽略(因为已经确定了)
	*/
  -- 最后一个等值条件是age=23，后面的position有序
explain select * from employees_copy2 where name = 'Lucy' and age = 23  order by position;
explain select * from employees_copy2 where name = 'Lucy' and age = 23  order by age,position; -- age 可忽略
explain select * from employees_copy2 where name = 'Lucy' and age = 23  order by position,age; -- age 可忽略
explain select * from employees_copy2 where name = 'Lucy' and age = 23  order by name,position,age; -- name、age 可忽略
explain select * from employees_copy2 where name = 'Lucy' and age = 23  order by age,position,name; -- age、name 可忽略
  -- position有序，所以能按照先position再address的顺序
explain select * from employees_copy2 where name = 'Lucy' and age = 23  order by position,address;
  -- 如果先address，则无法利用索引，因为它是基于position的每一个等值范围内有序
explain select * from employees_copy2 where name = 'Lucy' and age = 23  order by address,position;
explain select * from employees_copy2 where name = 'Lucy' and age = 23  order by address;
  /*
	  employees_copy2 中联合索引为 (name,age,position,address)
		范围查找：范围条件，紧挨着的右侧索引，在范围内的每个等值条件内，是按照顺序存储的
		          判断排序是否能利用索引时，需要先将范围条件排序，右侧逐一按照最左前缀排序
	*/
  -- 最后一个范围条件是age in(23,24)，从age依次从左往右查询，是有序的
explain select * from employees_copy2 where name = 'Lucy' and age in(23,24)  order by age,position,address;
explain select * from employees_copy2 where name = 'Lucy' and age in(23,24)  order by age,position;
  -- age虽然有序，但是address只在某一个等值position内有序，忽略position 则无法确定address的有序性
explain select * from employees_copy2 where name = 'Lucy' and age in(23,24)  order by age,address;
  -- 由于age是一个范围，position只在某一个等值age内有序，所以忽略age 则无法确定position的有序性
explain select * from employees_copy2 where name = 'Lucy' and age in(23,24)  order by position,address;
  /*
	  employees_copy2 中联合索引为 (name,age,position,address)
		注意：前两种都是查询条件在符合最左匹配原则的情况下
		如果查询条件不符合最左匹配原则：则从缺失的最左索引开始，按最左前缀顺序组合成排序条件
		                                查询条件中等值确定的索引，在排序条件中可以忽略
	*/
  -- 查询条件缺失的最左索引是age，排序条件 age,position,address 符合排序规则
explain select * from employees_copy2 where name = 'Lucy' and position = 'dev' order by age,position,address;
explain select * from employees_copy2 where name = 'Lucy' and position = 'dev' order by age,position;
  # 由于age不排序，position只能确定在一个等值的age中有序，不能确定在所有的age中有序，所以忽略age无法确定后面的有序性
explain select * from employees_copy2 where name = 'Lucy' and position = 'dev' order by position,address;
  -- age确定了顺序，则在每一个等值age下，position有序，又因为position确定了等值条件，则下面的address有序
explain select * from employees_copy2 where name = 'Lucy' and position = 'dev' order by age,address; -- position都一样，可以忽略它的排序
  -- 等值条件 position = 'dev' 已经确定，无论怎么排序，都是dev，所以position排序规则可以忽略
explain select * from employees_copy2 where name = 'Lucy' and position = 'dev' order by position,age,address; -- 等同于上面排序语句
  -- 若position是范围查询，只能确定address在一个等值范围内有序，则无法确定address在所有范围内有序
explain select * from employees_copy2 where name = 'Lucy' and position in('dev','manager') order by age,address;
  -- 若position在address之前确定顺序，则能确定address在一个等值范围内的顺序
explain select * from employees_copy2 where name = 'Lucy' and position in('dev','manager') order by age,position,address;
# Group by
  /*
	  其实质是先排序后分组，原理同 Order by
		  对于 group by 的优化：如果不需要排序，可以加上 order by null
	  注意：where高于having，能在where中限定的条件就不要去having限定了
	*/
select name,age,position from employees group by name;
select name,age,position from employees group by name order by null;
-- 如果分组查询报错 sql_mode=only_full_group_by，参考以下设置(不过容器中好像只有修改配置文件，然后重启才能生效)
# ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION
show variables like '%sql_mode%';
select @@global.sql_mode;
# 重启数据库后就会恢复(一次性配置)
set global sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
# 永久生效：修改配置文件(my.cnf | my.ini)
  /*
	  cd /usr/local/mysql/conf
		cp my.cnf my.cnf.bak
		vim my.cnf
		在[mysqld]模块下新增以下配置
		reboot
	*/
sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- range_test 范围测试
  /*
	  二级索引覆盖所有查询字段结果集
	  如果age>10条件包含了全部数据
		  数据量小的情况下，会对二级索引进行全表扫描，从而执行计划会看到索引全部被利用
	*/
explain select id,age,phone,money from range_test_copy where age>10 and phone>342124 and money>44;
explain select id,age,phone,money from range_test_copy where age>10 and money>44;
  -- 数据量多的情况下，就回到了范围索引右侧失效的状态下
explain select id,age,phone,money from range_test where age>10 and phone>342124 and money>44;
explain select id,age,phone,money from range_test where age>10 and money>44;
  /*
	  二级索引覆盖所有查询字段结果集
		如果age>11条件不包含全部数据
	    即便数据量小，仍然是范围查询，从而范围查询右侧索引失效
	*/
explain select id,age,phone,money from range_test_copy where age>11 and phone=342124 and money=44;
explain select id,age,phone,money from range_test_copy where age>11 and money=44;
  -- 数据量多的情况下，是正常范围查询，右侧索引失效
explain select id,age,phone,money from range_test where age>11 and phone=342124 and money=44;
explain select id,age,phone,money from range_test where age>11 and money=44;
  /*
		二级索引未能覆盖所有查询字段结果集
		无论age>?条件是否包含了全部数据，最终addi字段要从一级索引中查询
		  假设数据量比较少，有可能会 利用索引 和 索引下推，筛选好符合条件的主键值，再回表查询
			假设数据量比较多，有可能会 直接查询一级索引
	*/
	-- 少
explain select id,age,phone,money,addi from range_test_copy where age>10 and phone=342124 and money=44; -- rows 4
explain select id,age,phone,money,addi from range_test_copy where age>11 and phone=342124 and money=44; -- rows 3
explain select id,age,phone,money,addi from range_test where age>77 and phone=342124 and money=44; -- rows 2188
	-- 多
explain select id,age,phone,money,addi from range_test where age>10 and phone=342124 and money=44; -- rows 10236