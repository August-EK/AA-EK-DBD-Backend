package entity;

import io.quarkus.hibernate.orm.panache.PanacheEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import jakarta.persistence.*;
import java.math.BigDecimal;
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

    @Column(name = "founded_year")
    public Integer foundedYear;

    @Column(nullable = false, length = 50)
    public String country;

    @Column(nullable = false, length = 50)
    public String city;

    @ManyToOne
    @JoinColumn(name = "current_stadium_id")
    public Stadium currentStadium;

    @Column(name = "uefa_coefficient", precision = 8, scale = 3)
    public BigDecimal uefaCoefficient;

    // One-to-many relationships
    @OneToMany(mappedBy = "club", fetch = FetchType.LAZY)
    public List<ClubOwnership> ownerships;

    @OneToMany(mappedBy = "club", fetch = FetchType.LAZY)
    public List<ClubCoachTenure> coachTenures;

    @OneToMany(mappedBy = "club", fetch = FetchType.LAZY)
    public List<Contract> contracts;

    @OneToMany(mappedBy = "fromClub", fetch = FetchType.LAZY)
    public List<Transfer> transfersOut;

    @OneToMany(mappedBy = "toClub", fetch = FetchType.LAZY)
    public List<Transfer> transfersIn;

    @OneToMany(mappedBy = "homeClub", fetch = FetchType.LAZY)
    public List<Match> homeMatches;

    @OneToMany(mappedBy = "awayClub", fetch = FetchType.LAZY)
    public List<Match> awayMatches;

    @OneToMany(mappedBy = "club", fetch = FetchType.LAZY)
    public List<Honour> honours;
}