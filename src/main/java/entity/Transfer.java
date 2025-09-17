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
@Table(name = "transfers")
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class Transfer extends PanacheEntity {

    @ManyToOne
    @JoinColumn(name = "player_id", nullable = false)
    public Player player;

    @ManyToOne
    @JoinColumn(name = "from_club_id")
    public Club fromClub;

    @ManyToOne
    @JoinColumn(name = "to_club_id", nullable = false)
    public Club toClub;

    @Column(precision = 15, scale = 2)
    public BigDecimal fee;

    @Column(length = 3)
    public String currency; // EUR, GBP, USD

    @Column(name = "transfer_date", nullable = false)
    public LocalDate transferDate;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    public TransferType type;

    @Column(name = "loan_end_date")
    public LocalDate loanEndDate;

    public enum TransferType {
        PERMANENT,
        LOAN,
        FREE_TRANSFER,
        LOAN_WITH_OPTION_TO_BUY,
        LOAN_WITH_OBLIGATION_TO_BUY
    }
}