package year2022.month02.dao.inter;

import java.util.List;

/**
 * @Author weiskey
 * @Date 2021/12/30 22:52
 *
 * <p>
 *     DataAccessObjects -> Dao层
 *     数据存取对象 -> 产品信息
 * </p>
 * @Description:
 */
public interface ProductInfoDao {
    /**
     * 查询某业务员管理的产品数量
     * @param empNo 员工号
     * @return int 产品数量
     */
    public int getNumOfProduct(String empNo);

    /**
     * 查询产品表所有信息
     * @param productCode 产品代码
     * @return List<Object[]> 产品信息
     */
    public List<Object[]> listProducts(String productCode);
}
