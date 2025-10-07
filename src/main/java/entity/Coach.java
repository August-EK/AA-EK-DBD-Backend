package entity;

import io.quarkus.hibernate.orm.panache.PanacheEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.util.List;

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

}