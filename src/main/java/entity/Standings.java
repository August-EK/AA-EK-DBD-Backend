package entity;

import io.quarkus.hibernate.orm.panache.PanacheEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(
        name = "standings",
        uniqueConstraints = {
                @UniqueConstraint(columnNames = {"competition_id", "season_id", "club_id"})
        }
)
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class Standings extends PanacheEntity {

    @ManyToOne
    @JoinColumn(name = "competition_id", nullable = false)
    public Competition competition;

    @ManyToOne
    @JoinColumn(name = "season_id", nullable = false)
    public Season season;

    @ManyToOne
    @JoinColumn(name = "club_id", nullable = false)
    public Club club;

    @Column(nullable = false)
    public Integer played;

    @Column(nullable = false)
    public Integer won;

    @Column(nullable = false)
    public Integer drawn;

    @Column(nullable = false)
    public Integer lost;

    @Column(name = "goals_for", nullable = false)
    public Integer goalsFor;

    @Column(name = "goals_against", nullable = false)
    public Integer goalsAgainst;

    @Column(name = "goal_difference", nullable = false)
    public Integer goalDifference;

    @Column(nullable = false)
    public Integer points;

    @Column(name = "last_updated")
    public LocalDateTime lastUpdated;
}