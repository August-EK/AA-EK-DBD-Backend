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
@Table(name = "club_ownership")
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class ClubOwnership extends PanacheEntity {

    @ManyToOne
    @JoinColumn(name = "owner_id", nullable = false)
    public Owner owner;

    @ManyToOne
    @JoinColumn(name = "club_id", nullable = false)
    public Club club;

    @Column(name = "ownership_percentage", precision = 5, scale = 2)
    public BigDecimal ownershipPercentage;

    @Column(name = "start_date", nullable = false)
    public LocalDate startDate;

    @Column(name = "end_date")
    public LocalDate endDate;
}