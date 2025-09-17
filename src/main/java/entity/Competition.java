package entity;

import io.quarkus.hibernate.orm.panache.PanacheEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "competitions")
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class Competition extends PanacheEntity {

    @Column(nullable = false, length = 100)
    public String name; // Premier League, Champions League, FA Cup

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    public CompetitionType type;

    @Column(length = 50)
    public String country; // null for international competitions

    @Column(length = 50)
    public String organizer; // UEFA, FA, Premier League Ltd

    @OneToMany(mappedBy = "competition", fetch = FetchType.LAZY)
    public List<Match> matches;

    @OneToMany(mappedBy = "competition", fetch = FetchType.LAZY)
    public List<Honour> honours;

    public enum CompetitionType {
        LEAGUE,
        CUP,
        CONTINENTAL,
        INTERNATIONAL
    }
}