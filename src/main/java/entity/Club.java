package entity;

import io.quarkus.hibernate.orm.panache.PanacheEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "clubs")
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class Club extends PanacheEntity {

    @Column(nullable = false, length = 100)
    public String name;

    @Column(name = "short_name", nullable = false, length = 20)
    public String shortName;

    @Column(name = "founded_year")
    public Integer foundedYear;

    @Column(nullable = false, length = 50)
    public String country;

    @Column(nullable = false, length = 50)
    public String city;

    // Many-to-One: Club → Stadium
    @ManyToOne
    @JoinColumn(name = "current_stadium_id")
    public Stadium currentStadium;

    // One-to-Many: Club → Honours
    @OneToMany(mappedBy = "club", fetch = FetchType.LAZY)
    public List<Honour> honours;

    @OneToMany(mappedBy = "currentClub", fetch = FetchType.LAZY)
    public List<Player> currentPlayers;

    // Many-to-Many: Club ↔ Competition
    @ManyToMany
    @JoinTable(name = "club_competitions")
    public List<Competition> competitions;
}
