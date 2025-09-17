package entity;

import io.quarkus.hibernate.orm.panache.PanacheEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import jakarta.persistence.*;

@Entity
@Table(name = "appearances")
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class Appearance extends PanacheEntity {

    @ManyToOne
    @JoinColumn(name = "match_id", nullable = false)
    public Match match;

    @ManyToOne
    @JoinColumn(name = "player_id", nullable = false)
    public Player player;

    @ManyToOne
    @JoinColumn(name = "club_id", nullable = false)
    public Club club;

    @Column(name = "is_starter", nullable = false)
    public Boolean isStarter;

    @Column(name = "minute_on")
    public Integer minuteOn; // null if starter, otherwise substitution minute

    @Column(name = "minute_off")
    public Integer minuteOff; // null if played full match

    @Column(name = "shirt_number")
    public Integer shirtNumber;

    @Column(name = "position_at_kickoff", length = 10)
    public String positionAtKickoff; // GK, CB, CM, ST, etc.
}