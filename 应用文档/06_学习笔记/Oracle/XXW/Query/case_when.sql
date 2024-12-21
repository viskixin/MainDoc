-- typeno NVARCHAR2时，会报错
SELECT 
  serialno AS applytype,(
  	CASE typeno
  	  WHEN '002' THEN '开户申请'
  	  WHEN '003' THEN '变更申请'
  	  WHEN '003' THEN '销户申请'
  	  ELSE ''
  	END
  ) AS description
FROM product_info;
-- 该方法也不会报错，但是需要将字段加在每一个条件上
SELECT 
  serialno AS applytype,(
  	CASE
  	  WHEN typeno = '002' THEN '开户申请'
  	  WHEN typeno = '003' THEN '变更申请'
  	  WHEN typeno = '003' THEN '销户申请'
  	  ELSE ''
  	END
  ) AS description 
FROM product_info;

/**
 * 解决办法1
 * 用[to_char()]函数,将[NVARCHAR2]转成[VARCHAR]
 */
SELECT 
  serialno AS applytype,(
  	CASE to_char(typeno)
  	  WHEN '002' THEN '开户申请'
  	  WHEN '003' THEN '变更申请'
  	  WHEN '003' THEN '销户申请'
  	  ELSE ''
  	END
  ) AS description 
FROM product_info;
  
/**
 * 解决办法2
 * 或者 在[前面]加[N]，将字符转成[UNICODE]
 * 注意：N要紧挨着条件值
 */
SELECT 
  serialno AS applytype,(
  	CASE typeno
  	  WHEN N'002' THEN '开户申请'
  	  WHEN N'003' THEN '变更申请'
  	  WHEN N'003' THEN '销户申请'
  	  ELSE ''
  	END
  ) AS description 
FROM product_info;