package entity;

import io.quarkus.hibernate.orm.panache.PanacheEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "matches")
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class Match extends PanacheEntity {

    @ManyToOne
    @JoinColumn(name = "competition_id", nullable = false)
    public Competition competition;

    @ManyToOne
    @JoinColumn(name = "season_id", nullable = false)
    public Season season;

    @Column(name = "matchday_round")
    public Integer matchdayRound;

    @Column(name = "match_datetime", nullable = false)
    public LocalDateTime matchDatetime;

    @ManyToOne
    @JoinColumn(name = "home_club_id", nullable = false)
    public Club homeClub;

    @ManyToOne
    @JoinColumn(name = "away_club_id", nullable = false)
    public Club awayClub;

    @ManyToOne
    @JoinColumn(name = "stadium_id")
    public Stadium stadium;

    @ManyToOne
    @JoinColumn(name = "referee_id")
    public Referee referee;

    @Column(name = "home_goals")
    public Integer homeGoals;

    @Column(name = "away_goals")
    public Integer awayGoals;

    @Enumerated(EnumType.STRING)
    @Column(length = 20)
    public MatchStatus status;

    // ✅ Enum defineret inde i klassen
    public enum MatchStatus {
        SCHEDULED,
        LIVE,
        HALFTIME,
        FINISHED,
        POSTPONED,
        CANCELLED,
        ABANDONED
    }
}