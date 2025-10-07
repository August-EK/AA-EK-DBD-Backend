package entity;

import io.quarkus.hibernate.orm.panache.PanacheEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "referees")
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class Referee extends PanacheEntity {

    @Column(nullable = false, length = 100)
    public String name;

    @Column(nullable = false, length = 50)
    public String nationality;

    @Column(name = "date_of_birth")
    public LocalDate dateOfBirth;

    @Column(length = 50)
    public String licence;  // UEFA Pro, etc.
}