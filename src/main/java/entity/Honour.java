package entity;

import io.quarkus.hibernate.orm.panache.PanacheEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "honours")
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class Honour extends PanacheEntity {

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
    public Integer position; // 1st, 2nd, 3rd, etc.

    @Column(name = "date_awarded")
    public LocalDate dateAwarded;

    @Column(length = 100)
    public String description; // Premier League Champion, FA Cup Winner, etc.
}