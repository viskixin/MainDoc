package year2022.month02.entity.info;

import year2022.month02.entity.BaseEntity;

/**
 * @Author weiskey
 * @Date 2022/02/08 11:59
 *
 * <p>
 *     XML元数据的形式（xml配置的实体）
 * </p>
 * @Description:
 *     它将覆盖实体类中的注解元数据信息
 */
public class Production extends BaseEntity {
    private static final long serialVersionUID = 4419907865236385775L;

    /** 主键 */
    private Long id;

    /** 订单号 */
    private Long orderNo;

    /** 产品号 */
    private Long productNo;

    /** 业务员工号 */
    private Long empNo;

    public void setId(Long id) {
        this.id = id;
    }

    public Long getOrderNo() {
        return orderNo;
    }

    public void setOrderNo(Long orderNo) {
        this.orderNo = orderNo;
    }

    public Long getProductNo() {
        return productNo;
    }

    public void setProductNo(Long productNo) {
        this.productNo = productNo;
    }

    public Long getEmpNo() {
        return empNo;
    }

    public void setEmpNo(Long empNo) {
        this.empNo = empNo;
    }

    @Override
    public Long getId() {
        return id;
    }
}
