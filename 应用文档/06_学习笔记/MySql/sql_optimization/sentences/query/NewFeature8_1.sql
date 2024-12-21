-- 新增降序索引
create table tb_nf1(c1 int,c2 int,index idx_c1_c2(c1,c2 desc));
insert into tb_nf1(c1,c2) values(1, 10),(2,50),(3,50),(4,100),(5,80);
# 查看表结构
show create table tb_nf1;
# c2利用了降序索引(5.7也会使用索引，但是Extra字段里有filesort文件排序)
explain select * from tb_nf1 order by c1,c2 desc;
# 反向扫描索引，c1也能降序
explain select * from tb_nf1 order by c1 desc,c2;
# 以下排序不符合索引创建时的存储顺序，不能利用索引
explain select * from tb_nf1 order by c1,c2;
explain select * from tb_nf1 order by c1 desc,c2 desc;

-- 不再隐式排序
# 8.0版本group by不再默认排序
select count(*),c2 from tb_nf1 group by c2;
# 分组之后需要加上排序语句
select count(*),c2 from tb_nf1 group by c2 order by c2;

-- 增加隐藏索引
create table tb_nf2(c1 int, c2 int, index idx_c1(c1), index idx_c2(c2) invisible);
# 查看索引信息
show index from tb_nf2;
# c1列能使用索引
explain select * from tb_nf2 where c1=1;
# 隐藏索引c2不会被使用
explain select * from tb_nf2 where c2=1;
-- 查看各种参数
select @@optimizer_switch;
# 在会话级别设置查询优化器可以看到隐藏索引
set session optimizer_switch="use_invisible_indexes=on";
# 此时，在这个session中，可以暂时使用c2的索引
explain select * from tb_nf2 where c2=1;
-- 修改索引为可见
alter table tb_nf2 alter index idx_c2 visible;
-- 修改索引为不可见
alter table tb_nf2 alter index idx_c2 invisible;

-- 新增函数索引
create table tb_nf3(c1 varchar(10),c2 varchar(10));
# 创建普通索引
create index idx_c1 on tb_nf3(c1);
# 创建一个大写的函数索引
create index func_idx on tb_nf3((UPPER(c2)));
# 查看索引
show index from tb_nf3;
# 未利用索引
explain select * from tb_nf3 where upper(c1)='ZHUGE';
explain select * from tb_nf3 where c2='ZHUGE';
# 使用了函数索引
explain select * from tb_nf3 where upper(c2)='ZHUGE';

-- select for update跳过锁等待
# 先打开一个session1
begin;
update tb_nf1 set c2 = 60 where c1 = 2; -- 锁定第二条记录
commit;

/*参数修改持久化
  可以将修改的参数持久化到新的配置文件（auto.cnf）中，重启MySQL时，可以从该配置文件获取到最新的配置参数。
	set global 设置的变量参数在mysql重启后会失效。
	注意：data/auto.cnf 后执行，会覆盖 conf/my.cnf 的配置
*/
set persist innodb_lock_wait_timeout=10; -- 设置完后重新连接mysql
--  行锁锁定时间，默认50s，根据公司业务定，没有标准值
show variables like 'innodb_lock_wait_timeout';
-- 死锁检查控制(高并发的系统，可以关闭死锁检测功能，提高系统性能。但是要确保系统极少情况会发生死锁)
show variables like '%innodb_deadlock_detect%'; -- 默认是打开的
-- binlog日志过期时间精确到秒
show variables like '%binlog_expire_logs_seconds%';

-- 窗口函数(Window Functions)：也称分析函数
# 创建一张账户余额表
CREATE TABLE `account_channel` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '姓名',
  `channel` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '账户渠道',
  `balance` int DEFAULT NULL COMMENT '余额',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;
INSERT INTO account_channel (`id`, `name`, `channel`, `balance`) VALUES ('1', 'zhuge', 'wx', '100');
INSERT INTO account_channel (`id`, `name`, `channel`, `balance`) VALUES ('2', 'zhuge', 'alipay', '200');
INSERT INTO account_channel (`id`, `name`, `channel`, `balance`) VALUES ('3', 'zhuge', 'yinhang', '300');
INSERT INTO account_channel (`id`, `name`, `channel`, `balance`) VALUES ('4', 'lilei', 'wx', '200');
INSERT INTO account_channel (`id`, `name`, `channel`, `balance`) VALUES ('5', 'lilei', 'alipay', '100');
INSERT INTO account_channel (`id`, `name`, `channel`, `balance`) VALUES ('6', 'hanmeimei', 'wx', '500');
  # 8版本之前
select name,sum(balance) from account_channel group by name;
  /*8版版本之后(推荐8.0.17及之后)
	  在聚合函数后面加上over()就变成分析函数了，后面可以不用再加group by制定分组
		因为在over里已经用partition关键字指明了如何分组计算，
		这种可以保留原有表数据的结构，不会像分组聚合函数那样每组只返回一条数据
	*/
select name,channel,balance,sum(balance) over(partition by name) as sum_balance from account_channel;
  # 可在over()里进行排序
select name,channel,balance,sum(balance) over(partition by name order by balance) as sum_balance from account_channel;
  # over()里如果不加条件，则默认使用整个表的数据做运算
select name,channel,balance,sum(balance) over() as sum_balance from account_channel;
  # over()还可分析其他函数
select name,channel,balance,avg(balance) over(partition by name) as avg_balance from account_channel;
  # 持久化严格分组语法检验
set persist sql_mode = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
show variables like 'sql_mode';