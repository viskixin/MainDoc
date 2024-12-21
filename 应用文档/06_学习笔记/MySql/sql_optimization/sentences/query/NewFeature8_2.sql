-- select for update跳过锁等待
# 先打开一个session2
begin;
select * from tb_nf1 where c1 = 2 for update; # 等待超时
select * from tb_nf1 where c1 = 2 for update nowait; # 查询立即返回
select * from tb_nf1 for update skip locked; # 查询立即返回，过滤掉了第二行记录
commit;