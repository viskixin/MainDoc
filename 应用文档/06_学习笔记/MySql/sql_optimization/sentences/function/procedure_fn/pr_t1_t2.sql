-- 插入一些示例数据
-- 往t1表插入1万行记录
drop procedure if exists t1_insert; 
delimiter $$
create procedure t1_insert()        
begin
  declare i int;                    
  set i=1;                          
  while(i<=10000)do                 
    insert into t1(a,b) values(i,i);  
    set i=i+1;                       
  end while;
end$$
delimiter ;
call insert_t1();

-- 往t2表插入100行记录
drop procedure if exists t2_insert; 
delimiter ;;
create procedure t2_insert()        
begin
  declare i int;                    
  set i=1;                          
  while(i<=100)do                 
    insert into t2(a,b) values(i,i);  
    set i=i+1;                       
  end while;
end;;
delimiter ;
call insert_t2();