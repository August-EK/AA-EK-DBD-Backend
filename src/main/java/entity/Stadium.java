package entity;

import io.quarkus.hibernate.orm.panache.PanacheEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import jakarta.persistence.*;

import java.util.List;

@Entity
@Table(name = "stadiums")
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class Stadium extends PanacheEntity {

    @Column(nullable = false, length = 100)
    public String name;

    @Column(nullable = false)
    public Integer capacity;

    @Column(length = 200)
    public String address;

    @Column(nullable = false, length = 50)
    public String city;

    @Column(nullable = false, length = 50)
    public String country;

    @Column(name = "opened_year")
    public Integer openedYear;

    // One-to-many relationship with clubs (current stadium)
    @OneToMany(mappedBy = "currentStadium", fetch = FetchType.LAZY)
    public List<Club> clubs;

    // One-to-many relationship with matches
    @OneToMany(mappedBy = "stadium", fetch = FetchType.LAZY)
    public List<Match> matches;
}