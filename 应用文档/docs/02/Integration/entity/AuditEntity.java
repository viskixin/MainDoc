package year2022.month02.entity;

import java.util.Date;

/**
 * @Author weiskey
 * @Date 2022/01/26 10:03
 *
 * <p></p>
 * @Description:
 */
public abstract class AuditEntity extends BaseEntity {
    private static final long serialVersionUID = 3410036139963282450L;

    /**
     * @Fields createdById : is create UserId
     */
    protected Long createdById;
    /**
     * @Fields createdDate : is create Date
     */
    protected Date createdDate;
    /**
     * @Fields updatedById : is update UserId
     */
    protected Long updatedById;
    /**
     * @Fields updatedDate : is update Date
     */
    protected Date updatedDate;

    /**
     * getter method
     * @return the createdById
     */
    public Long getCreatedById() {
        return createdById;
    }

    /**
     * setter method
     * @param createdById
     *        the createdById to set
     */
    public void setCreatedById(Long createdById) {
        this.createdById = createdById;
    }

    /**
     * getter method
     * @return the createdDate
     */
    public Date getCreatedDate() {
        return createdDate;
    }

    /**
     * setter method
     * @param createdDate
     *        the createdDate to set
     */
    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    /**
     * getter method
     * @return the updatedById
     */
    public Long getUpdatedById() {
        return updatedById;
    }

    /**
     * setter method
     * @param updatedById
     *        the updatedById to set
     */
    public void setUpdatedById(Long updatedById) {
        this.updatedById = updatedById;
    }

    /**
     * getter method
     * @return the updatedDate
     */
    public Date getUpdatedDate() {
        return updatedDate;
    }

    /**
     * setter method
     * @param updatedDate
     *        the updatedDate to set
     */
    public void setUpdatedDate(Date updatedDate) {
        this.updatedDate = updatedDate;
    }
}
