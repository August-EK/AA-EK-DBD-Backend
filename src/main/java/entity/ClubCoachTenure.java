package entity;

import io.quarkus.hibernate.orm.panache.PanacheEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "club_coach_tenure")
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class ClubCoachTenure extends PanacheEntity {

    @ManyToOne
    @JoinColumn(name = "club_id", nullable = false)
    public Club club;

    @ManyToOne
    @JoinColumn(name = "coach_id", nullable = false)
    public Coach coach;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    public CoachRole role;

    @Column(name = "start_date", nullable = false)
    public LocalDate startDate;

    @Column(name = "end_date")
    public LocalDate endDate;

    public enum CoachRole {
        HEAD_COACH,
        ASSISTANT_COACH,
        GOALKEEPING_COACH,
        FITNESS_COACH
    }
}