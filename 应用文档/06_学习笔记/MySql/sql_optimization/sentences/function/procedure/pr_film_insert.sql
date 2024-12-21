# 删除
DROP PROCEDURE IF EXISTS film_insert;

# 创建
DELIMITER $$ -- 将语句的结束符号从分号(;)临时改为两个$$(可以是自定义)
CREATE PROCEDURE film_insert()
BEGIN
    DECLARE i INT DEFAULT 0;
    
    WHILE i < 10000 DO
        INSERT INTO film (name,age) VALUES (CONCAT('film',(FLOOR(RAND()*99998) + 1)),(FLOOR(RAND()*119) + 1));
        SET i = i + 1;
    END WHILE;
    
		# 最后执行搜索语句
    SELECT 'Data inserted successfully.';
END $$
DELIMITER ; -- 将语句的结束符号恢复为分号

# 调用执行
CALL film_insert();