package entity;

import io.quarkus.hibernate.orm.panache.PanacheEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "contracts")
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class Contract extends PanacheEntity {

    @ManyToOne
    @JoinColumn(name = "player_id", nullable = false)
    public Player player;

    @ManyToOne
    @JoinColumn(name = "club_id", nullable = false)
    public Club club;

    @Column(name = "start_date", nullable = false)
    public LocalDate startDate;

    @Column(name = "end_date", nullable = false)
    public LocalDate endDate;

    @Column(name = "shirt_number")
    public Integer shirtNumber;

    @Column(precision = 12, scale = 2)
    public BigDecimal salary; // Weekly/Monthly salary - optional
}