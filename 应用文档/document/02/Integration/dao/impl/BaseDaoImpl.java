package year2022.month02.dao.impl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import year2022.month02.dao.BaseDao;
import year2022.month02.entity.AuditEntity;
import year2022.month02.entity.BaseEntity;
import year2022.month02.entity.PageResult;

import javax.persistence.EntityManager;
import javax.persistence.LockModeType;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.math.BigDecimal;
import java.sql.*;
import java.util.Date;
import java.util.*;

/**
 * @Author weiskey
 * @Date 2021/12/30 22:35
 *
 * <p></p>
 * @Description:
 */
public class BaseDaoImpl<T extends BaseEntity> implements BaseDao<T> {
    public final Logger log = LoggerFactory.getLogger(super.getClass());

    private Class<T> entityClass;

    @PersistenceContext
    private EntityManager entityManager;

    @SuppressWarnings("unchecked")
    public BaseDaoImpl() {
        if (!(ParameterizedType.class.isAssignableFrom(super.getClass().getGenericSuperclass().getClass()))) {
            return;
        }
        Type[] actualTypeArguments = ((ParameterizedType) super.getClass().getGenericSuperclass()).getActualTypeArguments();
        this.entityClass = (Class<T>) actualTypeArguments[0];
    }

    @Override
    public T selectById(Long id) {
        return this.getEntityManager().find(this.entityClass, id);
    }

    @Override
    public T selectByIdNoWaitLock(Long id) {
        return this.getEntityManager().find(this.entityClass, id, LockModeType.PESSIMISTIC_READ);
    }

    @Override
    public List<T> selectList() {
        return selectEntityList(this.entityClass);
    }

    @Override
    public List<T> selectEntityList(Class<T> clazz) {
        String from = " from ";
        return this.getEntityManager().createQuery(from + clazz.getName()).getResultList();
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<T> selectByNamedQuery(String queryName, Map<String, Object> params) {
        Query query = this.getEntityManager().createNamedQuery(queryName);
        return this.setQueryParam(query, params).getResultList();
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<Object[]> nativeQuerySQL(String sql, Map<String, ?> params) {
        return setQueryParam(this.getEntityManager().createNativeQuery(sql), params).getResultList();
    }

    @Override
    @SuppressWarnings("unchecked")
    public PageResult<T> nativeQuerySQL(String sql, String countSql, Map<String, ?> params, int offsetIndex, int pageSize) {
        PageResult<T> pr = new PageResult();
        pr.setCurrentIndex(offsetIndex);
        pr.setPageSize(pageSize);

        if (countSql != null) {
            pr.setTotalCount(this.nativeQueryCountSQL(countSql, params));
        }

        if (pageSize != 0) {
            pr.setTotalPage((pr.getTotalCount() + pageSize - 1) / pageSize);
            pr.setCurrentPage((offsetIndex + pageSize) / pageSize);
        }

        //Query query = setQueryParam(this.getEntityManager().createNativeQuery(sql, this.entityClass), params).setFirstResult(offsetIndex);
        Query query = setQueryParam(this.getEntityManager().createNativeQuery(sql), params).setFirstResult(offsetIndex);
        if (pageSize != 0) {
            query.setMaxResults(pageSize);
        }

        pr.setContent(query.getResultList());
        return pr;
    }

    @Override
    @SuppressWarnings({"rawtypes"})
    public int nativeQueryCountSQL(String countSql, Map<String, ?> params) {
        List list = setQueryParam(this.getEntityManager().createNativeQuery(countSql), params).getResultList();
        if (list != null && !list.isEmpty()) {
            return ((BigDecimal) list.get(0)).intValue();
        }
        return 0;
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<T> nativeQueryHQL(String hql, Map<String, ?> params) {
        return setQueryParam(this.getEntityManager().createQuery(hql), params).getResultList();
    }

    @Override
    public PageResult<T> nativeQueryHQL(String hql, String countHql, Map<String, ?> params, int offsetIndex, int pageSize) {
        PageResult<T> pr = new PageResult();
        pr.setCurrentIndex(offsetIndex);
        pr.setPageSize(pageSize);

        if (countHql != null) {
            pr.setTotalCount(this.nativeQueryCountSQL(countHql, params));
        }

        if (pageSize != 0) {
            pr.setTotalPage((pr.getTotalCount() + pageSize - 1) / pageSize);
            pr.setCurrentPage((offsetIndex + pageSize) / pageSize);
        }

        //Query query = setQueryParam(this.getEntityManager().createQuery(hql, this.entityClass), params).setFirstResult(offsetIndex);
        Query query = setQueryParam(this.getEntityManager().createQuery(hql), params).setFirstResult(offsetIndex);
        if (pageSize != 0) {
            query.setMaxResults(pageSize);
        }

        pr.setContent(query.getResultList());
        return pr;
    }

    @Override
    @SuppressWarnings("rawtypes")
    public int queryCountHQL(String countHql, Map<String, ?> params) {
        List list = setQueryParam(this.getEntityManager().createQuery(countHql), params).getResultList();
        if (list != null && list.isEmpty()) {
            return ((Long) list.get(0)).intValue();
        }
        return 0;
    }

    @Override
    public void eagerLoad(T obj) {
        //TODO
    }

    @Override
    public void evict(T obj) {
        //TODO
    }

    @Override
    public void update(T obj) {
        this.update(obj, null);
    }

    @Override
    public void update(T obj, Date updateDate) {
        this.updateEntity((AuditEntity) obj, updateDate);
    }

    @Override
    public void updateObjects(Collection<T> objs) {
        this.updateObjects(objs, null);
    }

    @Override
    public void updateObjects(Collection<T> objs, Date updateDate) {
        for (Iterator<T> localIterator = objs.iterator(); localIterator.hasNext(); ) {
            T obj = localIterator.next();
            updateEntity((AuditEntity) obj, updateDate);
        }
    }

    @Override
    @SuppressWarnings("unchecked")
    public int nativeUpdateQueryByName(String queryName, Map<String, Object> params) {
        return setQueryParam(this.getEntityManager().createNativeQuery(queryName), params).executeUpdate();
    }

    @Override
    public int nativeUpdateSQL(String sql, Map<String, ?> params) {
        return setQueryParam(this.getEntityManager().createNativeQuery(sql), params).executeUpdate();
    }

    @Override
    public int updateHQL(String hql, Map<String, ?> params) {
        return setQueryParam(this.getEntityManager().createQuery(hql), params).executeUpdate();
    }

    @Override
    public void flush() {
        this.getEntityManager().flush();
    }

    @Override
    public void clear() {
        this.getEntityManager().clear();
    }

    @Override
    public void lock(T entity, LockModeType lockMode) {
        this.getEntityManager().lock(entity, lockMode);
    }

    @Override
    public void remove(T obj) {
        this.getEntityManager().remove(obj);
    }

    @Override
    public void removeObjects(Collection<T> objs) {
        for (T obj : objs) {
            this.remove(obj);
        }
    }

    @Override
    public void save(T obj) {
        this.addAuditInfo(obj);
        this.getEntityManager().persist(obj);
    }

    @Override
    public void saveObjects(Collection<T> objs) {
        for (T obj : objs) {
            this.save(obj);
        }
    }

    @Override
    public void mergeObject(T obj) {
        this.getEntityManager().merge(obj);
    }

    @Override
    public Long getSequenceNextVal(String sequenceName) {
        String sql = "select " + sequenceName + ".Nextval as seq from dual where 1=1";
        return ((BigDecimal) this.getEntityManager().createNativeQuery(sql).getResultList().get(0)).longValue();
    }

    @Override
    public List<String> getColumns(String tableName) {
        ArrayList<String> columns = new ArrayList<>();
        String sql = "select * from ? where 1 != 1";
        Connection conn = null;
        PreparedStatement preState = null;
        ResultSet rs = null;

        try {
            conn = this.getEntityManager().unwrap(Connection.class);
            preState = conn.prepareStatement(sql);
            preState.setString(1, tableName);
            //rs = conn.createStatement().executeQuery(sql);
            rs = preState.executeQuery();
            ResultSetMetaData meta = rs.getMetaData();
            int cols = meta.getColumnCount();
            for (int i = 1; i <= cols; ++i) {
                columns.add(meta.getColumnName(i));
            }
        } catch (SQLException e) {
            log.error(e.getMessage(), e);
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (Exception e) {
                log.error("close resources catch an exception", e);
            }

            try {
                if (preState != null) {
                    preState.close();
                }
            } catch (Exception e) {
                log.error("close resources catch an exception", e);
            }

            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (Exception e) {
                log.error("close resources catch an exception", e);
            }
        }
        return columns;
    }

    @Override
    public List<String> getTables(String schemaPattern, String tableNamePattern) {
        ArrayList<String> tables = new ArrayList<>();
        Connection conn = this.getEntityManager().unwrap(Connection.class);

        try {
            DatabaseMetaData meta = conn.getMetaData();
            ResultSet rs = meta.getTables(null, schemaPattern, tableNamePattern, new String[]{"TABLE"});
            while (rs.next()) {
                tables.add(rs.getString(3));
            }
        } catch (SQLException e) {
            log.error(e.getMessage(), e);
        }
        return tables;
    }

    @Override
    public EntityManager getEntityManager() {
        return this.entityManager;
    }

    @Override
    public Object querySQLSingleResult(String sql, Map<String, ?> params) {
        return setQueryParam(this.getEntityManager().createNativeQuery(sql), params).getResultList();
    }

    private Query setQueryParam(Query query, Map<String, ?> params) {
        if (params != null) {
            Set<String> set = params.keySet();
            for (String key : set) {
                query.setParameter(key, params.get(key));
            }
        }
        return query;
    }

    private void updateEntity(AuditEntity obj, Date updateDate) {
        if (updateDate == null) {
            obj.setUpdatedDate(Calendar.getInstance().getTime());
        } else {
            obj.setUpdatedDate(updateDate);
        }
        this.getEntityManager().merge(obj);
    }

    private void addAuditInfo(T obj) {
        if (obj instanceof AuditEntity) {
            AuditEntity obj1 = (AuditEntity) obj;
            Long id = obj1.getId();
            if ((id == null) || (id.longValue() <= 0L)) {
                //TODO 设置当前登录用户的ID
                obj1.setCreatedById(1L);
                if (obj1.getCreatedDate() == null) {
                    obj1.setCreatedDate(Calendar.getInstance().getTime());
                }
            }
            //TODO 设置当前登录用户的ID
            obj1.setUpdatedById(1L);
            obj1.setUpdatedDate(Calendar.getInstance().getTime());
        }
    }
}
