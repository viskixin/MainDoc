/*
	存储过程 → 插入数据到 employees
*/

# 删除
DROP PROCEDURE IF EXISTS emp_insert;

# 创建
DELIMITER $$ -- 将语句的结束符号从分号(;)临时改为两个$$(可以是自定义)
CREATE PROCEDURE emp_insert()
BEGIN
    DECLARE i INT DEFAULT 7;
		# SET i = 7;
    
    WHILE (i < 100007) DO
        INSERT INTO employees (name,age,position,hire_time) VALUES (CONCAT('zhuge',i),i,'dev',SYSDATE());
        SET i = i + 1;
    END WHILE;
    
		# # 最后执行搜索语句
    SELECT 'Data inserted successfully.';
END $$
DELIMITER ; -- 将语句的结束符号恢复为分号

# 调用执行
CALL emp_insert();