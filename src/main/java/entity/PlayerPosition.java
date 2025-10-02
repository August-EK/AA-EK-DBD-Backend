package entity;

import io.quarkus.hibernate.orm.panache.PanacheEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import jakarta.persistence.*;

@Entity
@Table(name = "player_positions")
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class PlayerPosition extends PanacheEntity {

    @ManyToOne
    @JoinColumn(name = "player_id", nullable = false)
    public Player player;

    @ManyToOne
    @JoinColumn(name = "position_id", nullable = false)
    public Position position;

    @Column(name = "is_primary", nullable = false)
    public Boolean isPrimary = false;
}
