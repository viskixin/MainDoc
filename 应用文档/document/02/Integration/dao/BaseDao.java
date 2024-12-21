package year2022.month02.dao;

import year2022.month02.entity.BaseEntity;
import year2022.month02.entity.PageResult;

import javax.persistence.EntityManager;
import javax.persistence.LockModeType;
import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * @Author weiskey
 * @Date 2021/12/30 22:34
 *
 * <p></p>
 * @Description:
 */
public interface BaseDao<T extends BaseEntity> {
    /**
     * selectById() 根据Id查询对象
     * @param id  Long
     * @return IfTest 返回类型
     */
    T selectById(Long id);

    /**
     * selectByIdNoWaitLock()
     * @param id  Long
     * @return IfTest 对象类型
     */
    T selectByIdNoWaitLock(Long id);

    /**
     * selectList()
     * @return List<IfTest> 集合T对象类型
     */
    List<T> selectList();

    /**
     * 根据Model类返回该Model对象所有的数据
     * @param clazz         类对象
     * @return List<IfTest> 集合T对象
     */
    List<T> selectEntityList(Class<T> clazz);

    /**
     * selectByNamedQuery()
     * @param queryName
     * @param params
     * @return List<IfTest> 集合T对象类型
     */
    List<T> selectByNamedQuery(String queryName, Map<String, Object> params);

    /**
     * 根据SQL语句，进行查询
     * @param sql       SQL语句
     * @param params    参数泛型：Map<String, ?>
     */
    List<Object[]> nativeQuerySQL(final String sql, final Map<String, ?> params);

    /**
     * 根据SQL语句，进行分页查询
     * @param sql           SQL语句
     * @param countSql      统计语句
     * @param params        参数
     * @param offsetIndex   当前页
     * @param pageSize      每页记录数
     */
    PageResult<T> nativeQuerySQL(final String sql, final String countSql,
                                 final Map<String, ?> params,
                                 final int offsetIndex, final int pageSize);

    /**
     * 根据SQL和params参数，统计当前记录总数
     * @param countSql
     * @param params
     * @return int
     */
    int nativeQueryCountSQL(final String countSql, final Map<String, ?> params);

    /**
     * 根据HQL语句，进行查询
     * @param hql           HQL语句
     * @param params        参数类型为<String, ?>
     * @return List<IfTest> 集合T对象类型
     */
    List<T> nativeQueryHQL(String hql, Map<String, ?> params);

    /**
     * 根据HQL语句，进行分页查询
     * @param hql           查询HQL语句
     * @param countHql      统计行数
     * @param params        参数
     * @param offsetIndex   当前页数
     * @param pageSize      页面大小数据
     * @return List<IfTest> 集合T对象类型
     */
    PageResult<T> nativeQueryHQL(String hql, String countHql,
                                 Map<String, ?> params,
                                 int offsetIndex, int pageSize);

    /**
     * 根据HQL和params参数，计算返回查询的行数
     * @param countHql
     * @param params
     * @return int
     */
    int queryCountHQL(String countHql, Map<String, ?> params);

    /**
     * eagerLoad()
     * @param obj
     */
    void eagerLoad(T obj);

    /**
     * evict()
     * @param obj
     */
    void evict(T obj);

    /**
     * 更新对象
     * @param obj
     * @return int
     */
    void update(T obj);

    /**
     * 更新对象和更新日期
     * @param obj
     * @param updateDate
     */
    void update(T obj, Date updateDate);

    /**
     * 批量更新对象
     * @param objs
     */
    void updateObjects(Collection<T> objs);

    /**
     * 批量更新对象和更新日期
     * @param objs
     * @param updateDate
     */
    void updateObjects(Collection<T> objs, Date updateDate);

    /**
     * 根据查询名称更新
     * @param queryName 询名称
     * @param params    参数
     * @return int      返回更新数量
     */
    int nativeUpdateQueryByName(String queryName, Map<String, Object> params);

    /**
     * 根据SQL语句，更新数据
     * @param sql       SQL语句
     * @param params    参数
     * @return int      更新记录数
     */
    int nativeUpdateSQL(final String sql, final Map<String, ?> params);

    /**
     * updateHQL()
     * @param hql
     * @param params
     * @return
     */
    int updateHQL(String hql, Map<String, ?> params);

    /**
     * 强制进行从Session缓存到数据库的同步，然后清除Session缓存，事务提交前默认会执行这个方法
     * setFlushMode(FlushMode flushMode)可以设置flush什么时候执行
     * FlushMode.ALWAYS|AUTO|COMMIT|NEVER|MANUAL
     *   ALWAYS     任何代码都会flush
     *   AUTO       默认方式-自动
     *   COMMIT     COMMIT时
     *   NEVER      始终不
     *   MANUAL     手动
     */
    void flush();

    /**
     * clear() 强制清除缓存数据
     * param 设定文件
     * description 清除缓存数据
     */
    void clear();

    /**
     * lock()
     * @param entity
     * @param lockMode
     */
    void lock(T entity, LockModeType lockMode);

    /**
     * 删除对象
     * @param obj 对象
     */
    void remove(T obj);

    /**
     * 删除对象集合
     * @param objs 对象集合
     */
    void removeObjects(Collection<T> objs);

    /**
     * 用于保存对象
     * @param obj 为T对象
     */
    void save(T obj);

    /**
     * 用于保存集合对象
     * @param objs 集合T对象
     */
    void saveObjects(Collection<T> objs);

    /**
     * 先去数据库查询与参数obj具有相同id的对象
     * 然后判断这个对象与参数obj比较是否有改变
     * 如果有则产生Update语句，把数据库记录更新为参数obj的状态
     * 函数不会把参数obj设置为持久态(就是说参数obj不会被方法session缓存里)
     * 函数会返回一个新对象，这个返回的新对象跟参数obj具有相同的属性，而且是持久态的
     * @param obj 查询对象
     */
    void mergeObject(T obj);

    /**
     * 根据序列名称获取序列的下一个值
     * @param sequenceName
     * @return Long
     */
    Long getSequenceNextVal(String sequenceName);

    /**
     * 根据持久化对象获取该对象映射表的所有列名称
     * @param obj
     * @return List<String>
     * TODO
     */
    //public List<String> getColumns(IfTest obj);

    /**
     * 根据数据库表名获取该表的所有列名称
     * @param tableName     数据库表名
     * @return List<String> 返回表的列名
     */
    List<String> getColumns(String tableName);

    /**
     * 根据模板样式、表名样式获取表对象
     * @param schemaPattern
     * @param tableNamePattern
     * @return List<String>
     */
    List<String> getTables(String schemaPattern, String tableNamePattern);

    /**
     * 便于一些复杂操作
     * @return EntityManager
     */
    EntityManager getEntityManager();

    /**
     * 返回单个对象
     * @param sql
     * @param params
     * @return Object
     */
    Object querySQLSingleResult(String sql, Map<String, ?> params);
}
