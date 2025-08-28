package year2022.month02.dao.inter;

import year2022.month02.dao.BaseDao;
import year2022.month02.entity.info.User;

import java.util.List;

/**
 * @Author weiskey
 * @Date 2022/02/08 14:55
 *
 * <p>
 *     DataAccessObjects -> Dao层
 *     数据存取对象 -> 用户信息
 * </p>
 * @Description:
 */
public interface UserInfoDao extends BaseDao<User> {
    /**
     * 查询用户信息
     *
     * @param account 账号
     * @return List<User> 用户信息
     */
    public List<User> queryUserInfo(String account, String password);
}
