/*
  函数 → 根据 姓名,年龄 获取主键id
	
	若创建函数报错：This function has none of DETERMINISTIC, NO SQL, or READS SQL DATA in ...
	# 查看是否允许函数创建
	show variables like '%log_bin_trust_function_creators%';
	# 在 MySQL 数据库中执行以下语句，临时生效，重启后失效
	set global log_bin_trust_function_creators=1;
	# 在配置文件 my.ini 的 [mysqld] 配置，永久生效
	log_bin_trust_function_creators=1
*/
# 删除
DROP FUNCTION IF EXISTS getEmpId;

CREATE FUNCTION getEmpId(nm VARCHAR(24), ag INT)
RETURNS INT
BEGIN
	DECLARE res_id INT DEFAULT 0;
	-- 如果没有结果集，搜出的id类型为[N/A]
	-- SELECT id INTO res_id FROM employees WHERE `name` = nm AND age = ag;
	-- 1) [MAX/MIN]等函数，处理[N/A]结果集时，会将结果转换为NULL
	-- SELECT IFNULL(MIN(id), NULL) INTO res_id FROM employees WHERE `name` = nm AND age = ag;
	-- 2) 不直接从表中搜索
	SELECT (SELECT id FROM employees WHERE `name` = nm AND age = ag) INTO res_id FROM DUAL;
	
-- 	IF (ISNULL(res_id)) THEN
-- 		SET res_id = 0;
-- 		ELSEIF (res_id < 10) THEN
-- 			SET res_id = 1;
-- 		ELSE
-- 			SET res_id = res_id;
-- 	END IF;
	
	SET res_id = 
		IF(ISNULL(res_id), 0,
			IF(res_id < 10, 1,
				res_id));
	
-- 	注意以下的 END; 是结束的 CASE，在整个函数中，需要指定分隔符来区分整体结束的 END，参考 getEmpId2
-- 	SET res_id = 
-- 		CASE
-- 			WHEN ISNULL(res_id) THEN 0
-- 			WHEN res_id < 10 THEN 1
-- 			ELSE 9
-- 		END;
	
	RETURN res_id;
END