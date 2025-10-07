package entity;

import io.quarkus.hibernate.orm.panache.PanacheEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "coaches")
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class Coach extends PanacheEntity {

    @Column(nullable = false, length = 100)
    public String name;

    @Column(name = "date_of_birth")
    public LocalDate dateOfBirth;

    @Column(nullable = false, length = 50)
    public String nationality;

    @Column(length = 50)
    public String licence;

    // One-to-One: Coach → Club
    @OneToOne
    @JoinColumn(name = "current_club_id")
    public Club currentClub;
}
