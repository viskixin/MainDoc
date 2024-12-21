package year2022.month02.entity.info;

import year2022.month02.entity.AuditEntity;

import javax.persistence.*;

/**
 * @Author weiskey
 * @Date 2022/02/08 14:59
 *
 * <p>
 *     JPA注解元数据形式
 * </p>
 * @Description:
 */
@Entity
@Table(name = "user_info")
@SequenceGenerator(name = "SEQ_USER_ID", sequenceName = "SEQ_USER_ID", allocationSize = 1)
public class User extends AuditEntity {
    @Id
    @Column(name = "id")
    @GeneratedValue(generator = "SEQ_USER_ID")
    /** 主键 */
    private Long id;

    @Column(name = "user_account")
    /** 账号 */
    private String account;

    @Column(name = "user_nickname")
    /** 昵称 */
    private String nickname;

    @Column(name = "user_password")
    /** 密码 */
    private String password;

    @Column(name = "level")
    /* 等级 */
    private Long level;

    public void setId(Long id) {
        this.id = id;
    }

    public String getAccount() {
        return account;
    }

    public void setAccount(String account) {
        this.account = account;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Long getLevel() {
        return level;
    }

    public void setLevel(Long level) {
        this.level = level;
    }

    @Override
    public Long getId() {
        return null;
    }
}
