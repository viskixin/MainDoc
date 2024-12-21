/*
  函数 → 根据 姓名,年龄 获取主键id
*/
# 删除
DROP FUNCTION IF EXISTS getEmpId2;

DELIMITER $$

CREATE FUNCTION getEmpId2(nm VARCHAR(24), ag INT)
RETURNS INT
BEGIN
	DECLARE res_id INT DEFAULT 0;
	-- SELECT (SELECT id FROM employees WHERE `name` = nm AND age = ag) INTO res_id;
	SELECT id INTO res_id FROM employees WHERE `name` = nm AND age = ag;
	
-- 	SET res_id = 
-- 		CASE
-- 			WHEN (res_id IS NULL) THEN 0
-- 			WHEN (res_id < 10) THEN 1
-- 			ELSE res_id
-- 		END;
	
	-- case 后面加上条件，可处理[N/A]类型的结果集
	SET res_id = 
		CASE res_id
			WHEN NULL THEN 0
			WHEN LOWER(9) THEN 1
			ELSE res_id
		END;
	
	RETURN res_id;
END $$

DELIMITER ;