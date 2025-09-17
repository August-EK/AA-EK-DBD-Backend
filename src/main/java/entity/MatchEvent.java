package entity;

import io.quarkus.hibernate.orm.panache.PanacheEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import jakarta.persistence.*;

@Entity
@Table(name = "match_events")
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class MatchEvent extends PanacheEntity {

    @ManyToOne
    @JoinColumn(name = "match_id", nullable = false)
    public Match match;

    @Column(nullable = false)
    public Integer minute;

    @Column(name = "added_time_second")
    public Integer addedTimeSecond;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    public EventType type;

    @ManyToOne
    @JoinColumn(name = "player_id")
    public Player player;

    @ManyToOne
    @JoinColumn(name = "assisting_player_id")
    public Player assistingPlayer;

    @ManyToOne
    @JoinColumn(name = "club_id", nullable = false)
    public Club club;

    @Column(length = 100)
    public String details; // penalty, own-goal, VAR decision, etc.

    public enum EventType {
        GOAL,
        ASSIST,
        YELLOW_CARD,
        RED_CARD,
        SUBSTITUTION_ON,
        SUBSTITUTION_OFF,
        VAR_DECISION,
        PENALTY_MISS,
        SAVE
    }
}