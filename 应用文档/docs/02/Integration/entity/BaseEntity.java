package year2022.month02.entity;

import java.io.Serializable;

/**
 * @Author weiskey
 * @Date 2021/12/30 22:20
 *
 * <p></p>
 * @Description:
 */
public abstract class BaseEntity implements Serializable {
    private static final long serialVersionUID = -8139984987373949214L;

    public static final String ID = "id";

    public abstract Long getId();

    public BaseEntity() {
    }

    public int hashCode() {
        final int PRIME = 31;
        int result = 1;
        result = PRIME * result + (getId() != null ? getId().hashCode() : super.hashCode());
        return result;
    }

    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null) {
            return false;
        }
        if (super.getClass() != obj.getClass()) {
            return false;
        }
        BaseEntity other = (BaseEntity) obj;
        if (getId() == null) {
            if (other.getId() != null) {
                return false;
            }
            if (!getId().equals(other.getId())) {
                return false;
            }
        }
        return true;
    }
}
