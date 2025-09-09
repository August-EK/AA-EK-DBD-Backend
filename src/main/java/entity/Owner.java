package entity;

import io.quarkus.hibernate.orm.panache.PanacheEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "owners")
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class Owner extends PanacheEntity {

    @Column(nullable = false, length = 100)
    public String name;

    @Column(nullable = false, length = 50)
    public String country;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    public OwnerType type;

    @OneToMany(mappedBy = "owner", fetch = FetchType.LAZY)
    public List<ClubOwnership> ownerships;

    public enum OwnerType {
        PERSON, COMPANY
    }
}