begin;
insert into tb_point values(1,16);
insert into tb_point values(2,17);
insert into tb_point values(3,18);

savepoint x;


insert into tb_point values(4,21);
insert into tb_point values(5,22);

rollback to x;

select * from tb_point;

commit;