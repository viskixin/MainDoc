package year2022.month02.dao.impl.business;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Repository;
import year2022.month02.dao.inter.UserInfoDao;
import year2022.month02.dao.impl.BaseDaoImpl;
import year2022.month02.entity.info.User;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Author weiskey
 * @Date 2022/02/08 15:07
 *
 * <p>
 *     UserInfoDao的实现类
 * </p>
 * @Description:
 */
@Repository("userInfoDao")
public class UserInfoDaoImpl extends BaseDaoImpl<User> implements UserInfoDao {
    @Override
    public List<User> queryUserInfo(String account, String password) {
        Map<String, Object> params = new HashMap();
        StringBuffer hql = new StringBuffer();
        //hql.append(" from User where user_account = :account");
        hql.append(" from " + User.class.getSimpleName() + " where user_account = :account");
        params.put("empNo", account);
        if (StringUtils.isNotBlank(password)) {
            hql.append(" and user_password = :password");
            params.put("password", password);
        }

        List<User> users = null;
        try {
            users = this.nativeQueryHQL(hql.toString(), params);
        } catch (Exception e) {
            log.error("查询用户信息出错！！！" + e.getMessage(), e);
        }
        return users;
    }
}
