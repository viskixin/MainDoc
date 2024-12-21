# [事务A2]
begin;
select * from account where id = 10 for update;
commit;

# [事务B2]
begin;
select * from account where id=2 for update;
-- 先返回[事务B1]，再select
select * from account where id=1 for update;
commit;