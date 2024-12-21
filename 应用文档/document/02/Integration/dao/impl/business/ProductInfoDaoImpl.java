package year2022.month02.dao.impl.business;

import cn.hutool.core.util.ObjectUtil;
import year2022.month02.dao.inter.ProductInfoDao;
import year2022.month02.dao.impl.BaseDaoImpl;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Author weiskey
 * @Date 2021/12/30 22:52
 *
 * <p>
 *     ProductInfoDao的实现类
 * </p>
 * @Description:
 */
public class ProductInfoDaoImpl extends BaseDaoImpl implements ProductInfoDao {
    @Override
    public int getNumOfProduct(String empNo) {
        Map<String, Object> params = new HashMap();
        StringBuffer sql = new StringBuffer();
        sql.append("select product_num from product_info where emp_no = :empNo");
        params.put("empNo", empNo);

        List list = null;
        try {
            list = this.nativeQuerySQL(sql.toString(), params);
        } catch (Exception e) {
            log.error("查询产品数量出错！！！" + e.getMessage(), e);
        }

        int num = 0;
        if (ObjectUtil.isNotNull(list) && ObjectUtil.isNotEmpty(list)) {
            Object obj = list.get(0);
            if (obj != null) {
                //num = Integer.valueOf(obj.toString());//最大值为：2147483647
                num = ((BigDecimal) obj).intValue();
            }
        }
        return num;
    }

    @Override
    public List<Object[]> listProducts(String productCode) {
        Map<Integer, Object> params = new HashMap();
        StringBuffer sql = new StringBuffer();
        sql.append("select * from product_info where product_code = ?");
        params.put(1, productCode);

        List<Object[]> listArr = null;
        try {
            listArr = this.nativeQuerySQL(sql.toString(), params);
        } catch (Exception e) {
            log.error("查询产品信息出错！！！" + e.getMessage(), e);
        }
        return listArr;
    }
}
