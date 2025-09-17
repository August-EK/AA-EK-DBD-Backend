package entity;

import io.quarkus.hibernate.orm.panache.PanacheEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.util.List;

@Entity
@Table(name = "players")
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class Player extends PanacheEntity {

    @Column(nullable = false, length = 100)
    public String name;

    @Column(name = "date_of_birth")
    public LocalDate dateOfBirth;

    @Column(nullable = false, length = 50)
    public String nationality;

    @Column(name = "height_cm")
    public Integer heightCm;

    @Enumerated(EnumType.STRING)
    @Column(name = "preferred_foot", length = 10)
    public PreferredFoot preferredFoot;

    @OneToMany(mappedBy = "player", fetch = FetchType.LAZY)
    public List<PlayerPosition> playerPositions;

    @OneToMany(mappedBy = "player", fetch = FetchType.LAZY)
    public List<Contract> contracts;

    @OneToMany(mappedBy = "player", fetch = FetchType.LAZY)
    public List<Transfer> transfers;

    @OneToMany(mappedBy = "player", fetch = FetchType.LAZY)
    public List<Appearance> appearances;

    public enum PreferredFoot {
        LEFT, RIGHT, BOTH
    }
}