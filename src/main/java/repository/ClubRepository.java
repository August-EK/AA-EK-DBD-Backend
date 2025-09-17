package repository;

import io.quarkus.hibernate.orm.panache.PanacheRepository;
import entity.Club;
import jakarta.enterprise.context.ApplicationScoped;
import java.util.List;

@ApplicationScoped
public class ClubRepository implements PanacheRepository<Club> {

    public List<Club> findByCountry(String country) {
        return list("country", country);
    }

    public List<Club> findByCity(String city) {
        return list("city", city);
    }

    public Club findByName(String name) {
        return find("name", name).firstResult();
    }

    public List<Club> findByFoundedYearRange(Integer startYear, Integer endYear) {
        return list("foundedYear >= ?1 and foundedYear <= ?2", startYear, endYear);
    }

    public List<Club> searchByNameContaining(String searchTerm) {
        return list("lower(name) like lower(?1)", "%" + searchTerm + "%");
    }
}