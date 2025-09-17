package entity;

import io.quarkus.hibernate.orm.panache.PanacheEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "positions")
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class Position extends PanacheEntity {

    @Column(nullable = false, unique = true, length = 10)
    public String code; // GK, CB, LB, RB, DM, CM, AM, LW, RW, ST

    @Column(nullable = false, length = 50)
    public String name; // Goalkeeper, Centre-back, Left-back, etc.

    @OneToMany(mappedBy = "position", fetch = FetchType.LAZY)
    public List<PlayerPosition> playerPositions;
}